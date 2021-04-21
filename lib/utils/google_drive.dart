import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:recall/utils/preference_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

const _clientId =
    "165097937134-boa46nejv9ugu09f4mphh7f6551dh1gc.apps.googleusercontent.com";
const _clientSecret = "pDV3s-o7TQs_sIb3VD9axbYt";
const _scopes = [ga.DriveApi.DriveAppdataScope];

class GoogleDrive {
  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await PreferenceManager().getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(_clientId, _clientSecret), _scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await PreferenceManager().saveCredentials(
          authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              _scopes));
    }
  }

  //Upload File
  Future upload(File uploadFile) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    print("Uploading file");
    ga.File fileToUpload = ga.File();
    fileToUpload.parents = ["appDataFolder"];
    fileToUpload.name = p.basename(uploadFile.absolute.path);
    int fileLength = await uploadFile.length();
    print("file length ==> $fileLength");
    var response = await drive.files.create(fileToUpload,
        uploadMedia: ga.Media(uploadFile.openRead(), uploadFile.lengthSync()));

    print("Result ${response.toJson()}");
    return response.id != null && response.id.isNotEmpty ? true : false;
  }

  Future<bool> listGoogleDriveFiles() async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    ga.FileList fileList = await drive.files.list(spaces: 'appDataFolder');
    print("Id: ${fileList.files[0].id} File Name:${fileList.files[0].name}");
    await processFile(fileList.files[0],
        fileList.files[0].name.contains('habit') ? 'habit' : 'revision');
    print("Id: ${fileList.files[1].id} File Name:${fileList.files[1].name}");
    await processFile(fileList.files[1],
        fileList.files[1].name.contains('habit') ? 'habit' : 'revision');
    return true;
  }

  processFile(file, type) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    ga.Media response = await drive.files
        .get(file.id, downloadOptions: ga.DownloadOptions.FullMedia);

    List<int> dataStore = [];
    response.stream.listen((data) {
      print("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = File('$tempPath/test');
      await file.writeAsBytes(dataStore);
      String content = file.readAsStringSync(); // Reading String from the file

      await PreferenceManager().setData(type, content);

      print("Task Done");
      return true;
    }, onError: (error) {
      print("Some Error");
      return true;
    });
  }

  Future<bool> deleteFile({filename}) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    String id = '';

    drive.files.list(spaces: 'appDataFolder').then((value) async {
      print("deleting");
      for (var i = 0; i < value.files.length; i++) {
        if (value.files[i].name.trim() == filename) {
          id = value.files[i].id;
          break;
        }
      }

      if (id != '') {
        print("deleting file $id");
        await drive.files.delete(id);
        return true;
      }

      return true;
    });
  }
}
