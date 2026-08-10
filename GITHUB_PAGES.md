# Publish on GitHub Pages (mobile-friendly reader)

This repo includes [Docsify](https://docsify.js.org/) — a sidebar, search, and prev/next navigation over your existing Markdown. No build step.

## One-time setup

### 1. Create a GitHub repo

On [github.com/new](https://github.com/new), create a repository (e.g. `san_data_structure`).

### 2. Push this folder

From the repo root on your machine:

```bash
cd /Users/sandeepyadav/Documents/san_dsa/san_data_structure

git init
git add .
git commit -m "Add DSA for Mobile curriculum and GitHub Pages reader"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/san_data_structure.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.

### 3. Enable GitHub Pages

1. Open the repo on GitHub → **Settings** → **Pages**
2. Under **Build and deployment** → **Source**, choose **Deploy from a branch**
3. **Branch:** `main` · **Folder:** `/ (root)` → **Save**
4. Wait 1–3 minutes. GitHub shows a URL like:

   `https://YOUR_USERNAME.github.io/san_data_structure/`

Open that URL on your phone. Use **Add to Home Screen** (iOS/Android) for an app-like shortcut.

## Read on mobile

- Tap **☰** (top-left) for the chapter sidebar
- Use the **search** box to find topics
- **Previous / Next** at the bottom of each page
- Pinch to zoom code blocks if needed

## Preview locally before pushing

Any static server from the repo root:

```bash
cd /Users/sandeepyadav/Documents/san_dsa/san_data_structure
python3 -m http.server 8080
```

Then open `http://localhost:8080/` (note: local URL has no `/repo-name/` prefix; GitHub Pages adds it automatically via `index.html`).

## Troubleshooting

| Problem | Fix |
|---------|-----|
| 404 on GitHub Pages | Confirm Pages source is `main` / root; wait a few minutes |
| Blank page | Ensure `index.html` and `.nojekyll` are committed |
| Links broken | Use the site URL with trailing slash: `.../san_data_structure/` |
| Old content | Hard refresh or clear cache on mobile |

## Optional: custom domain

In **Settings → Pages → Custom domain**, add your domain and follow GitHub’s DNS instructions.
