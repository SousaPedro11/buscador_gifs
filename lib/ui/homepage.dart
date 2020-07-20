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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Here',
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  case ConnectionState.waiting:
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGiftTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _createGiftTable(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: EdgeInsets.all(10.0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
    itemCount: snapshot.data['data'].length,
    itemBuilder: (context, index) {
      return GestureDetector(
        child: Image.network(
          snapshot.data['data'][index]['images']['fixed_height']['url'],
          height: 300.0,
          fit: BoxFit.cover,
        ),
      );
    },
  );
}
