import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_page/models/repositories.dart';
import 'package:github_page/models/user_model.dart';
import 'package:github_page/pages/profile_page.dart';
import 'package:github_page/services/hive_service.dart';
import 'package:github_page/services/http_service.dart';
import 'package:github_page/services/status_codes.dart';
import 'package:github_page/services/web_scraping_service.dart';
import 'package:github_page/widgets/snackBar.dart';

class FindUser extends ChangeNotifier {
  final TextEditingController accountController = TextEditingController();
  final FocusNode accountFocus = FocusNode();
  bool isLoading = false;
  int? funcResponse;
  bool isNotEmpty = false;

  List<String> history = [];

  clear() {
    isNotEmpty = false;
    accountFocus.unfocus();
    accountController.clear();
    notifyListeners();
  }

  change(String txt) {
    isNotEmpty = txt.isNotEmpty;
    notifyListeners();
  }

  update(String value) {
    isNotEmpty = true;
    accountFocus.unfocus();
    accountController.text = value;
    notifyListeners();
  }

  storeHistory(String username) async{
    await HiveService.storeUserNames(username);
    loadHistory();
  }

  loadHistory(){
    history = HiveService.loadUserNames();
    notifyListeners();
  }

  deleteHistory(String value){
    HiveService.removeUserName(value);
    history.remove(value);
    notifyListeners();
  }

  onTimeOut(BuildContext context){
    snackBar(context, 'Request time out');
    isLoading = false;
    notifyListeners();
  }

  Future<void> findUser(BuildContext context) async{
    accountFocus.unfocus();
    String user = accountController.text.toString().trim();

    if (user.isEmpty) {
      snackBar(context, 'Type the username, please!');
      return;
    }

    isLoading = true;
    notifyListeners();

    await WebScraping.getWebsiteData(user);
    dynamic response = await Network.GET(Network.API_GET + user, Network.paramsEmpty());
    await _check(context, response);
  }

  Future<void> _check(BuildContext context, dynamic _response) async {
    if (_response is String) {
      User user = Network.parseUser(_response);

      if (user.starredReposLink != null) {
        if (kDebugMode) {
          print(
            'API: ${user.starredReposLink!.substring(22).replaceFirstMapped('{/owner}{/repo}', (m) => '')}');
        }
        String? response = await Network.GET(
            user.starredReposLink!
                .substring(22)
                .replaceFirstMapped('{/owner}{/repo}', (m) => ''),
            Network.paramsEmpty());
        await starredRepos(user, response!);
      }

      if (kDebugMode) {
        print('-----------------------------------------');
        print('Name: ${user.name}   Username: ${user.username}');
        print('Image: ${user.profileImage}  Starred: ${user.starredRepos}');
        print('-----------------------------------------');
      }
      if (funcResponse != null) {
        isLoading = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage(user: user)));
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } else {
      if (kDebugMode) {
        print(_response);
      }
      snackBar(context, StatusCodes.response(_response));
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> starredRepos(User user, String response) async {
    List json = await jsonDecode(response);
    user.starredRepos = json.length;
    funcResponse = json.length;
    notifyListeners();
  }
}
