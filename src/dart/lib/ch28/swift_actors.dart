// Swift actors
// Source: book/part-vii/28-concurrency.md
import 'dart:isolate';

// An isolate is Dart's actor: it owns its heap and is reached only by messages.

Future<SendPort> spawnCounter() async {
  final ready = ReceivePort();
  await Isolate.spawn(_counterMain, ready.sendPort);
  return await ready.first as SendPort;
}

void _counterMain(SendPort ready) {
  var value = 0; // only this isolate can touch it
  final inbox = ReceivePort();
  ready.send(inbox.sendPort);
  inbox.listen((msg) {
    final (cmd, reply) = msg as (String, SendPort);
    if (cmd == 'inc') value++;
    reply.send(value);
  });
}

Future<int> ask(SendPort counter, String cmd) async {
  final reply = ReceivePort();
  counter.send((cmd, reply.sendPort));
  return await reply.first as int;
}
