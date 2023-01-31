import 'dart:convert';
import 'dart:developer';
import 'package:fluttercodeoptimization/app_socket/app_socket.dart';
import 'package:fluttercodeoptimization/app_socket/events.dart';

void appSocketEventListen() {
  AppSocket.eventListenersOn();
  AppSocket.eventsListeners?.stream.asBroadcastStream().listen((event) {
    var jsonData = json.encode(event.responseData);
    log("Events : Type - ${event.eventType} $jsonData");

    // messages

    if (event.eventType == AppSocketEvents.receive_chat) {
      // run your function on message
    }
  });
}
