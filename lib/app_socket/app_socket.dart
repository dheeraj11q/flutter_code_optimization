import 'dart:async';
import 'dart:developer';
import 'package:fluttercodeoptimization/app_socket/emitter.dart';
import 'package:fluttercodeoptimization/app_socket/event_listener.dart';
import 'package:fluttercodeoptimization/app_socket/events.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

String socketUrl = "https://app_url";

// this a singleton app socket class

class AppSocket {
  AppSocket._();

  static io.Socket? socket;
  // for listener
  static StreamController<SocketResponseModel>? eventsListeners;

  // socket connections

  static void connect() async {
    // socket initialize
    eventsListeners = StreamController<SocketResponseModel>.broadcast();
    socket = io.io(
        socketUrl,
        io.OptionBuilder()
            .setTransports(
              ['websocket'],
            )
            .enableReconnection()
            .enableAutoConnect()
            .enableForceNewConnection()
            .setTimeout(15000)
            .build());
    disconnect();
    if (socket!.disconnected) {
      _connectionListen();
      socket?.connect();
    }
  }

  static void disconnect() {
    if (socket!.connected) {
      eventsListeners?.close();
      AppSocketEmitters.disconnectUser();
      socket?.disconnect();
    }
  }

  // for socket event listen

  static eventListenersOn({AppSocketEvents? event}) async {
    if (event != null) {
      await _eventListen(event: event);
    } else {
      // multipule event listen here
      for (AppSocketEvents event in AppSocketEvents.values) {
        await _eventListen(event: event);
      }
    }
  }

  static Future<void> _eventListen({required AppSocketEvents event}) async {
    socket?.on(event.name, (data) async {
      _addDataToStream(event, data);
    });
  }

  // sinking socket event data to stream

  static void _addDataToStream(AppSocketEvents eventName, data) async {
    try {
      eventsListeners?.sink
          .add(SocketResponseModel(eventType: eventName, responseData: data));
    } catch (e) {
      log("Error add event in Socket : $e");
    }
  }

  static void _connectionListen() {
    socket?.onConnect((data) async {
      // connected.complete
      log("Socket onConnected ${socket?.connected}");
      AppSocketEmitters.connectUser();
      appSocketEventListen();
    });

    socket?.onDisconnect((data) {
      log("Socket disconnect  $data");
    });

    socket?.onConnectError((data) {
      log("Socket connect error $data");
    });
  }
}

// << Model

class SocketResponseModel {
  AppSocketEvents eventType;
  dynamic responseData;

  SocketResponseModel({required this.eventType, required this.responseData});
}

// >>
