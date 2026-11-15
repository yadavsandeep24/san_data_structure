#!/usr/bin/env python3
"""Run the book's code snippets against tests.

For each target below, every fenced ```kotlin / ```dart / ```typescript block in the
listed Markdown files is extracted into one source file per language, joined with
the matching test in code/snippet-tests/<target>/, then compiled and run.

Languages whose toolchain is missing are skipped (exit code stays 0 for skips).
Swift isn't run: it needs a macOS/Linux Swift toolchain. Keep Swift snippets in step
with the Kotlin ones by review.

Usage (from the repo root or anywhere):
    python3 code/verify_snippets.py            # all targets
    python3 code/verify_snippets.py ch13 ch16  # selected targets
"""
import os
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TESTS = os.path.join(ROOT, 'code', 'snippet-tests')

# target -> (markdown files, optional section heading to restrict extraction to)
TARGETS = {
    'ch13': (['book/part-iv/13-two-pointers.md', 'solutions/ch13/README.md'], None),
    'ch14': (['book/part-iv/14-sliding-window.md', 'solutions/ch14/README.md'], None),
    'ch15': (['book/part-iv/15-prefix-sums.md', 'solutions/ch15/README.md'], None),
    'ch16': (['book/part-iv/16-monotonic-stack-deque.md', 'solutions/ch16/README.md'], None),
    'ch17': (['book/part-iv/17-intervals-sweep-line.md', 'solutions/ch17/README.md'], None),
    'ch21': (['book/part-vi/21-searching-sorting.md'], '## Binary search on the answer'),
}


def extract(lang, files, section):
    out = []
    for rel in files:
        text = open(os.path.join(ROOT, rel), encoding='utf-8').read()
        if section:
            start = text.index(section)
            nxt = re.search(r'\n## ', text[start + len(section):])
            text = text[start:start + len(section) + (nxt.start() if nxt else len(text))]
        out += re.findall(r'```' + lang + r'\n(.*?)```', text, re.S)
    return '\n'.join(out)


def run(cmd, cwd):
    p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    noise = ('JAVA_TOOL_OPTIONS', 'warning:')
    log = '\n'.join(l for l in (p.stdout + p.stderr).splitlines() if not l.startswith(noise))
    return p.returncode == 0, log


def check_ts(src, test, work):
    if not shutil.which('node'):
        return None, 'no node'
    open(os.path.join(work, 'all.ts'), 'w').write(src + '\n' + test)
    if shutil.which('tsc'):
        ok, log = run(['tsc', '--strict', '--target', 'es2022', '--lib', 'es2022,dom', '--outDir', 'js', 'all.ts'], work)
        if not ok:
            return False, log
        return run(['node', 'js/all.js'], work)
    # Node 22.6+ can strip types without tsc (no type-checking)
    return run(['node', '--experimental-strip-types', 'all.ts'], work)


def check_dart(src, test, work):
    if not shutil.which('dart'):
        return None, 'no dart'
    lines = (test + '\n' + src).splitlines()
    imports = sorted({l for l in lines if l.startswith('import ')})
    body = [l for l in lines if not l.startswith('import ')]
    open(os.path.join(work, 'all.dart'), 'w').write('\n'.join(imports + body))
    return run(['dart', 'run', 'all.dart'], work)


def check_kotlin(src, test, work):
    if not (shutil.which('kotlinc') and shutil.which('java')):
        return None, 'no kotlinc/java'
    open(os.path.join(work, 'src.kt'), 'w').write(src)
    open(os.path.join(work, 'test.kt'), 'w').write(test)
    ok, log = run(['kotlinc', 'src.kt', 'test.kt', '-include-runtime', '-d', 't.jar'], work)
    if not ok:
        return False, log
    return run(['java', '-jar', 't.jar'], work)


CHECKS = [('typescript', 'test.ts', check_ts), ('dart', 'test.dart', check_dart), ('kotlin', 'test.kt', check_kotlin)]


def main(argv):
    targets = argv or list(TARGETS)
    failed = 0
    for t in targets:
        files, section = TARGETS[t]
        for lang, test_name, fn in CHECKS:
            test = open(os.path.join(TESTS, t, test_name), encoding='utf-8').read()
            with tempfile.TemporaryDirectory() as work:
                ok, log = fn(extract(lang, files, section), test, work)
            if ok is None:
                print(f'SKIP {t} {lang} ({log})')
            elif ok:
                print(f'OK   {t} {lang}')
            else:
                failed += 1
                print(f'FAIL {t} {lang}\n{log}')
    print('all snippet tests passed' if not failed else f'{failed} failure(s)')
    return 1 if failed else 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
