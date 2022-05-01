import 'dart:convert';

import 'package:github_page/models/repositories.dart';
import 'package:hive/hive.dart';

class HiveService {
  static String DB_NAME = 'database';
  static Box box = Hive.box(DB_NAME);

  /// FOR HISTORY LIST
  static Future<void> storeUserNames (String username) async {
    List<String> usernamesList = [];
    if(box.containsKey('usernames')){
      usernamesList = box.get('usernames');
    }

    if(!usernamesList.contains(username)){
      usernamesList.add(username);
    }else{
      usernamesList.remove(username);
      usernamesList.add(username);
    }

    await box.put('usernames', usernamesList);
    // print('STORED: $usernamesList');
  }

  static List<String> loadUserNames(){
    if(box.containsKey('usernames')){
      List<String> usernamesList = box.get('usernames');
      // print('LOADED: $usernamesList');
      return usernamesList;
    }
    return <String>[];
  }

  static Future<void> removeUserName(String username) async {
    List<String> usernamesList = [];
    if(box.containsKey('usernames')){
      usernamesList = box.get('usernames');
    }
    if(usernamesList.contains(username)){
      usernamesList.remove(username);
    }
    await box.put('usernames', usernamesList);
  }

  static Future<void> removeUserNames() async {
    await box.delete('usernames');
  }

  /// FOR PINNED REPOSITORIES LIST
  static Future<void> storePinnedRepos (List<Repositories> repos) async {
    // Object => Map => String
    List<String> stringList = repos.map((repo) => jsonEncode(repo.toJson())).toList();
    await box.put('pinnedRepos', stringList);
  }

  static List<Repositories> loadPinnedRepos(){
    if(box.containsKey('pinnedRepos')){
      // String => Map => Object
      List<String> stringList = box.get('pinnedRepos');
      List<Repositories> reposList = stringList.map((stringRepo) => Repositories.fromJson(jsonDecode(stringRepo))).toList();
      return reposList;
    }
    return <Repositories>[];
  }

  static Future<void> removePinnedRepos() async {
    await box.delete('pinnedRepos');
  }
}