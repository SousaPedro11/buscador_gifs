import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    String url;
    if (_search == null) {
      url =
          'https://api.giphy.com/v1/gifs/trending?api_key=1CZM7oBlmcKG3qD6S6CXMG6aAxJHMDRS&limit=25&rating=g';
    } else {
      url =
          'https://api.giphy.com/v1/gifs/search?api_key=1CZM7oBlmcKG3qD6S6CXMG6aAxJHMDRS&q=$_search&limit=25&offset=$_offset&rating=g&lang=en';
    }
    response = await http.get(url);

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) => {print(map)});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
