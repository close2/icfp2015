// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'package:icfp2015/game/renderer.dart';

void main() {
  var output = querySelector('#output');
  output.text = 'Your Dart app is running.';
  var output2 = querySelector('#output2');

  WebSocket ws = new WebSocket('ws://127.0.0.1:9223/ws');
  ws.onMessage.listen((e) => output2.text += e.data);
  ws.onOpen.first.then((_) {
    output.text += 'XX';
    ws.send('↙↘↻→↻');
  });

  output.text += '!!!!.';

  CanvasElement canvas = querySelector('#honeycomb');
  var game = new GameDisplay(canvas);
  game.start();
}
