import 'package:flutter/foundation.dart';
import 'package:github_page/models/repositories.dart';
import 'package:github_page/services/hive_service.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class WebScraping {

  static Future getWebsiteData(String username) async {
    final url = Uri.parse('https://github.com/$username');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html.querySelectorAll('div.flex-1 > a > span').map((e) => e.innerHtml.trim()).toList();

    final urls = html.querySelectorAll('div.flex-1 > a').map((e) => 'https://github.com/${e.attributes['href']}').toList();

    final langColors = html.querySelectorAll('div > p.mb-0.mt-2.f6.color-fg-muted > span').map((e) => e.innerHtml.trim()).toList();

    final colors = List.generate(langColors.length, (index) => langColors[index].substring(langColors[index].lastIndexOf('"background-color: #'), langColors[index].indexOf('"></span>')).replaceAll('"background-color: #', ''));

    final languages = List.generate(langColors.length, (index) => langColors[index].substring(langColors[index].lastIndexOf('"programmingLanguage">'), langColors[index].lastIndexOf('</span>')).replaceAll('"programmingLanguage">', ''));

    final List<Repositories> list = List.generate(
        titles.length,
            (index) =>
            Repositories(
                repoName: titles[index],
                repoURL: urls[index],
                color: colors[index],
                language: languages[index]
            )
    );

    await HiveService.storePinnedRepos(list);

    // FindUser().pinned(List.generate(
    //     titles.length,
    //         (index) =>
    //         Repositories(
    //             repoName: titles[index],
    //             repoURL: urls[index],
    //             color: colors[index],
    //             language: languages[index],
    //         )
    // ));
    
    for (final title in titles) {
      debugPrint(title);
    }
  }
}