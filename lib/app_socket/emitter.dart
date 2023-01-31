import 'package:fluttercodeoptimization/app_socket/app_socket.dart';
import 'package:fluttercodeoptimization/app_socket/events.dart';

class AppSocketEmitters {
  // for connectiong users
  static void connectUser() {
    AppSocket.socket?.emitWithAck(
        AppSocketEmitterEvents.user_connected.name,
        {
          // 'userId': "${Constant.pref?.getString("userId")}",
        },
        ack: (res) {});

    // log("User connected ${Constant.pref?.getString("userId")}");
  }

  static void disconnectUser() {
    AppSocket.socket?.emitWithAck(
        AppSocketEmitterEvents.disconnect_user.name,
        {
          // 'userId': "${Constant.pref?.getString("userId")}",
        },
        ack: (data) {});

    // log("User disconnected ${Constant.pref?.getString("userId")}");
  }

  static void sendMessage() {}
}
