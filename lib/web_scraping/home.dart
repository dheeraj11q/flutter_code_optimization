import 'dart:developer';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:web_scraper/web_scraper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> loadWeb() async {
    log("Run ...");

    var res = await http
        .get(Uri.parse('https://webscraper.io/test-sites/e-commerce/allinone'));

    if (res.statusCode == 200) {
      var document = parser.parse(res.body);
      // var data = document.getElementsByClassName('jumbotron');
      // var data2 = parser.parse(data[0].outerHtml);

      // log("Here data ${data2.getElementsByTagName('h1')[0].innerHtml}");

      var data = document.getElementsByClassName('col-sm-4 col-lg-4 col-md-4');
      log("Here = ${data.length}");
    }

    // final webScraper = WebScraper('https://webscraper.io');
    // if (await webScraper.loadWebPage('/test-sites/e-commerce/allinone')) {
    //   List<Map<String, dynamic>> elements =
    //       webScraper.getElement('h4 > a', ['']);
    //   print(elements);
    // }

    // var parser = await Chaleno()
    //     .load('https://webscraper.io/test-sites/e-commerce/allinone');

    // var result = parser?.getElementsByClassName('jumbotron');

    // print(result?[0].html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadWeb();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Web"),
      ),
    );
  }
}
