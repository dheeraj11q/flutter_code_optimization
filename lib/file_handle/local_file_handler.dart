import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

String _appDirectoryName = "TalkieSpace";

enum AppDirectory { talkieSpace, send, download, enc }

class LocalFileHandler {
  static Future<String?> appDirectoryGenerate(
      {required AppDirectory appDir}) async {
    Directory? directory;

    try {
      // android
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          log("Here Path = ${directory?.path}");
          String newPath = "";
          List<String>? folders = directory?.path.split("/");

          for (int f = 1; f < folders!.length; f++) {
            String folder = folders[f];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          if (appDir == AppDirectory.talkieSpace) {
            newPath = newPath + "/$_appDirectoryName";
          } else {
            newPath = newPath + "/$_appDirectoryName/${appDir.name}";
          }

          directory = Directory(newPath);
        }
      }

      // iOS

      else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        }
      }

      // cerate dir
      if (!await directory!.exists()) {
        await directory.create(recursive: true);
      }

      if (await directory.exists()) {
        String dirPath = directory.path;

        // print("File save here");

        //* this code for save file
        // for download file
        // await mdio.Dio().download(
        //   "urlPath",
        //   savefile.path,
        //   onReceiveProgress: (count, total) {},
        // );

        //* iOS
        // if (Platform.isIOS) {
        //   await ImageGallerySaver.saveFile(savefile.path,
        //       isReturnPathOfIOS: true);
        // }

        return dirPath;
      }
    } catch (e) {
      log("Here File Save error $e");
    }

    // return false;
  }

  static Future<bool> saveFileInAppDirectory(
      {required File file,
      AppDirectory directory = AppDirectory.download}) async {
    String? dir = await appDirectoryGenerate(appDir: directory);
    if (dir != null) {
      await file.copy("$dir/${file.path.split('/').last}");
      return true;
    } else {
      return false;
    }
  }

  static Future<String> writeFile(
      {required List<int> bytes,
      AppDirectory appDir = AppDirectory.enc,
      required String fileName}) async {
    String? dir = await appDirectoryGenerate(appDir: appDir);
    print("writing ...");
    File f = File("$dir/$fileName");
    await f.writeAsBytes(bytes);

    print("writing done ...");
    return f.absolute.toString();
  }
}

Future<bool> _requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    var data = await permission.status;
    print("Here ${permission} : $data");
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> requestPermission(Permission permission) async {
  if (await permission.isGranted) {
    var data = await permission.status;
    print("Here ${permission} : $data");
    return true;
  } else {
    var result = await permission.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}
