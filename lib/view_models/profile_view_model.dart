import 'package:flutter/material.dart';
import 'package:github_page/models/repositories.dart';
import 'package:github_page/services/hive_service.dart';

class UserProfile extends ChangeNotifier {
  List<Repositories> pinnedRepositories = [];

  loadPinnedRepos(){
    pinnedRepositories = HiveService.loadPinnedRepos();
    notifyListeners();
  }
}