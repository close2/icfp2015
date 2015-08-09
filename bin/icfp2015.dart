library icfp2015;

import 'dart:io';
import 'dart:convert';

import 'dart:async';

import 'dart:math' show Point;

import 'package:args/args.dart';
import 'package:route/server.dart' show Router;
import 'package:logging/logging.dart' show Logger, Level, LogRecord;

import 'package:icfp2015/game/game.dart';

final Logger log = new Logger('icfp2015');


void sendProblem(WebSocket webSocket, Game game) {
  log.info('Going to send description of game to webSocket');
  webSocket.add('Description of game');
}

typedef void onData(var event);

onData getProcessCommandsHandler(WebSocket webSocket, Game game) {
  log.info('Returning on Date Handler');
  return (String command) {
    log.info('New Command: $command');
    command.split('').forEach(game.addCommand);
    var boardState = game.boardState;
    webSocket.add(boardState.board.cells.map((i) => '$i').join(','));
  };
}

Map<Game, WebSocket> handlers = new Map();
void handleWebSocket(WebSocket webSocket) {
  log.info('New WebSocket connection');
  Game game = games.firstWhere((g) => !handlers.containsKey(g), orElse: () => null);
  if (game == null) {
    log.info('No game available');
    webSocket.add('No game available');
    webSocket.close();
    return;
  }

  handlers[game] = webSocket;
  // first send problem
  sendProblem(webSocket, game);
  webSocket.listen(getProcessCommandsHandler(webSocket, game));
}

Future<ProblemDescription> fileToProblemDescription(String fileName) {
  log.info('Looking at file: ' + fileName);
  var file = new File(fileName);

  return file
      .openRead()
      .transform(UTF8.decoder)
      .transform(JSON.decoder)
      .map((probJson) => new ProblemDescription.fromJson(probJson))
      .first;
}

Future<List<Problem>> descToProblems(Future<ProblemDescription> description) {
  return description.then((desc) {
    return desc.sourceSeeds.map((int seed) => new Problem(desc, seed)).toList();
  });
}

List<Game> games = new List();

void start(Problem problem) {
  log.info('Ready for problem #${problem.description.id} with seed: ${problem.seed}');
  games.add(new Game(problem));
  //games.add(new GameDisplay(problem));
}

void main(List<String> args) {
  // Set up logger.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  var parser = new ArgParser();
  parser.addOption('file', abbr: 'f', allowMultiple: true);
  parser.addOption('phrase-of-power', abbr: 'p', allowMultiple: true);

  var parseResults = parser.parse(args);

  print("Phrases of power: ");
  List<String> pows = parseResults['phrase-of-power'];

  print("Files: ");
  List<String> files = parseResults['file'];
  var probDescFutures = files.map(fileToProblemDescription);
  var probFutures = probDescFutures.map(descToProblems);

  probFutures.forEach((gListFuture) {
    gListFuture.then((List<Problem> problems) {
      problems.forEach((problem) {
        start(problem);
      });
    });
  });

  int port = 9223; // TODO use args from command line to set this

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, port).then((server) {
    log.info("Search server is running on "
        "'http://${server.address.address}:$port/'");
    var router = new Router(server);

    // The client will connect using a WebSocket. Upgrade requests to '/ws' and
    // forward them to 'handleWebSocket'.
    router
        .serve('/ws')
        .transform(new WebSocketTransformer())
        .listen(handleWebSocket);
  });
}
