// import 'dart:async';
// import 'dart:io';
// import 'dart:isolate';
// import 'dart:typed_data';
// import 'package:encrypt/encrypt.dart' as enc;

// class _Encryption {
//   static final myKey = enc.Key.fromUtf8("my32lengthsupersecretnooneknows1");
//   static final myIv = enc.IV.fromLength(16);
//   static final myEncrypt = enc.Encrypter(enc.AES(myKey));
// }

// // < encryption isolate

// _encryptDataWithIsolate(Map<String, dynamic> data) {
//   SendPort sendPort = data["port"];
//   var mapData = data["data"];

//   var encrypted =
//       _Encryption.myEncrypt.encryptBytes(mapData, iv: _Encryption.myIv);

//   sendPort.send(encrypted.bytes);
// }

// // < decryption isolate

// _decryptDataWithIsolate(Map<String, dynamic> data) {
//   SendPort sendPort = data["port"];
//   var mapData = data["data"];

//   enc.Encrypted en = enc.Encrypted(mapData);
//   var decData = _Encryption.myEncrypt.decryptBytes(en, iv: _Encryption.myIv);

//   sendPort.send(decData);
// }

// Future<Uint8List> decryptFile(File file) async {
//   Completer<Uint8List> c = Completer<Uint8List>();

//   var bytData = await file.readAsBytes();

//   var receiverPort = ReceivePort();

//   Map<String, dynamic> data = {'port': receiverPort.sendPort, 'data': bytData};
//   await Isolate.spawn(
//     _decryptDataWithIsolate,
//     data,
//   );

//   receiverPort.listen(
//     (enResult) async {
//       c.complete(enResult);
//     },
//   );

//   return await c.future;
// }

// Future<Uint8List> encryptFile(File file) async {
//   Completer<Uint8List> c = Completer<Uint8List>();

//   var bytData = await file.readAsBytes();

//   var receiverPort = ReceivePort();

//   Map<String, dynamic> data = {'port': receiverPort.sendPort, 'data': bytData};
//   await Isolate.spawn(
//     _encryptDataWithIsolate,
//     data,
//   );

//   receiverPort.listen(
//     (enResult) async {
//       c.complete(enResult);
//     },
//   );

//   return await c.future;
// }
