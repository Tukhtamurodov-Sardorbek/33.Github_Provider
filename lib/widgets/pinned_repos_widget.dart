import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:github_page/extension.dart';
import 'package:github_page/models/repositories.dart';
import 'package:github_page/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

InkWell repository(int index, User user, Repositories repo) {

  return InkWell(
    child: Container(
      height: 150,
      width: 300,
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.grey, width: 3)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: CachedNetworkImage(
                  imageUrl: user.profileImage,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/default_img.png'),
                  height: 22,
                  width: 22,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 6.0),
              Text(user.username,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
          Text(
              repo.repoName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white)),
          Row(
            children: [
              Text(' ● ',
                  style:
                  TextStyle(color: HexColor.fromHex(repo.color), fontSize: 19)),
              Text(' ${repo.language}',
                  style: const TextStyle(color: Colors.grey, fontSize: 17)),
            ],
          )
        ],
      ),
    ),
    onTap: () async{
      if(await canLaunchUrl(Uri.parse(repo.repoURL))){
        await launchUrl(Uri.parse(repo.repoURL));
      }
    },
  );
}