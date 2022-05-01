import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_page/models/user_model.dart';
import 'package:github_page/view_models/profile_view_model.dart';
import 'package:github_page/widgets/pinned_repos_widget.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static const String id = '/profile_page';
  final User user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile viewModel = UserProfile();

  @override
  void initState() {
    viewModel.loadPinnedRepos();
    super.initState();
    print('INIT STATE: ${viewModel.pinnedRepositories.length}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<UserProfile>(builder: (BuildContext context, model, index) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black,
                  pinned: false,
                  snap: false,
                  floating: true,
                  leading: IconButton(
                    splashRadius: 1,
                    icon: const Icon(Icons.arrow_back_ios_sharp,
                        color: CupertinoColors.systemBlue, size: 27),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Image.asset('assets/logo.png', width: 150),
                  actions: [
                    IconButton(
                      splashRadius: 1,
                      icon: const Icon(Icons.share_outlined,
                          color: CupertinoColors.systemBlue, size: 30),
                      onPressed: () {},
                    ),
                    IconButton(
                      splashRadius: 1,
                      icon: const Icon(Icons.settings_outlined,
                          color: CupertinoColors.systemBlue, size: 30),
                      onPressed: () {},
                    )
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            color: Colors.black54,
                            child: Column(
                              children: [
                                // #profile image & nickname
                                SizedBox(
                                  height: 100,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.user.profileImage,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/default_img.png'),
                                          height: 90,
                                          width: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              widget.user.name ??
                                                  widget.user.username,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white)),
                                          Text(
                                            widget.user.username,
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.grey, width: 2)),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.smartphone,
                                          color: Colors.white, size: 22),
                                      SizedBox(width: 5.0),
                                      Text('Mobile Apps',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(widget.user.bio ?? '',
                                    style: const TextStyle(
                                        fontSize: 17, color: Colors.white)),
                                const SizedBox(height: 10.0),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        color: Colors.white),
                                    const SizedBox(width: 6.0),
                                    Text(widget.user.location ?? '',
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    Transform.rotate(
                                        angle: 3 * pi / 4,
                                        child: const Icon(Icons.link,
                                            color: Colors.white)),
                                    const SizedBox(width: 6.0),
                                    Text(widget.user.blog ?? '',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  children: [
                                    const Icon(Icons.person,
                                        color: Colors.white),
                                    const SizedBox(height: 8.0),
                                    Text(widget.user.followers.toString(),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const Text(' followers • ',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white)),
                                    Text(widget.user.following.toString(),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const Text(' following',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 8.0),
                            color: Colors.black54,
                            child: Column(
                              children: [
                                // #pinned
                                viewModel.pinnedRepositories.isEmpty
                                    ? const SizedBox()
                                    : Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          Transform.rotate(
                                            angle: 3 * pi / 2 + pi / 4,
                                            child: const Icon(
                                                Icons.push_pin_outlined,
                                                size: 24,
                                                color: Colors.white),
                                          ),
                                          const Text('  Pinned',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.white)
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 160,
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        scrollDirection:
                                        Axis.horizontal,
                                        shrinkWrap: true,
                                        physics:
                                        const BouncingScrollPhysics(),
                                        itemCount: viewModel.pinnedRepositories.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          return repository(index, widget.user, viewModel.pinnedRepositories[index]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: 170,
                                    child: Column(
                                      children: [
                                        const Divider(
                                            color: Colors.white54,
                                            thickness: 2),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          dense: true,
                                          minVerticalPadding: 0.0,
                                          minLeadingWidth: 0.0,
                                          leading: const Icon(
                                              Icons.book_outlined,
                                              color: Colors.white),
                                          title: const Text('Repositories',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                          trailing: Text(
                                              widget.user.repos.toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                        ),
                                        const ListTile(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 0.0),
                                          dense: true,
                                          minVerticalPadding: 0.0,
                                          minLeadingWidth: 0.0,
                                          leading: Icon(Icons.apartment,
                                              color: Colors.white),
                                          title: Text('Organizations',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                          trailing: Text('1',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          dense: true,
                                          minVerticalPadding: 0.0,
                                          minLeadingWidth: 0.0,
                                          leading: const Icon(
                                              Icons.star_border_outlined,
                                              color: Colors.white),
                                          title: const Text('Starred',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                          trailing: Text(
                                              widget.user.starredRepos == 30
                                                  ? widget.user.starredRepos
                                                          .toString() +
                                                      ' more'
                                                  : widget.user.starredRepos
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          const SizedBox(height: 20.0)
                        ],
                      ),
                    ),
                  ]),
                )
              ]),
          bottomNavigationBar: CupertinoTabBar(
            backgroundColor: Colors.black,
            currentIndex: 3,
            activeColor: CupertinoColors.systemBlue,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_outlined),
                  label: 'Notifications'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined), label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      }),
    );
  }
}
