class User{
  String username;
  String? name;
  String profileImage;
  String? location;
  String? email;
  String? bio;
  String? blog;
  String? twitter;
  String? starredReposLink;
  int following = 0;
  int followers = 0;
  int gists = 0;
  int repos = 0;
  int starredRepos = 0;


  User({required this.username, required this.name, required this.profileImage});

  User.fromJson(Map<String, dynamic> json)
      : username = json['login'],
        name = json['name'],
        profileImage = json['avatar_url'],
        email = json['email'],
        location = json['location'],
        bio = json['bio'],
        blog = json['blog'],
        twitter = json['twitter_username'],
        starredReposLink = json['starred_url'],
        repos = json['public_repos'],
        gists = json['public_gists'],
        following = json['following'],
        followers = json['followers'];
}