import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:recall/utils/preference_manager.dart';
import 'package:url_launcher/url_launcher.dart';

const _clientId =
    "165097937134-tskprq9jlp7imtmahunv745s059f3469.apps.googleusercontent.com";
const _clientSecret = "ofi8swCMXIoBJpgWwgIlQ_fT";
const _scopes = [ga.DriveApi.DriveFileScope];

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
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    print("Uploading file");
    ga.File fileToUpload = ga.File();
    fileToUpload.parents = ["Recall_appData"];
    fileToUpload.name = p.basename(file.absolute.path);
    int fileLength = await file.length();
    var response = await drive.files.create(fileToUpload,
        uploadMedia: ga.Media(file.openRead(), fileLength));

    print("Result ${response.toJson()}");
  }
}
