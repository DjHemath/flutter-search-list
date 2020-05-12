import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text( 'Search List' );
  List<dynamic> data = [];
  List<dynamic> filteredData = [];

  Future fetchData() async {
      // final rawData = await DefaultAssetBundle.of(context).loadString("assets/birds.json");
      final rawData = await rootBundle.loadString("assets/birds.json");
      final List<dynamic> jsonData =  jsonDecode(rawData);
      setState(() {
        data = jsonData;
        filteredData = jsonData;
      });
  }

  void textChangeListener() {
    final text = _filter.text.toLowerCase();
      if(!text.isEmpty) {
        List<dynamic> filter = [];
        this.data.forEach((dynamic datum){
          if(datum['c'].toString().toLowerCase().contains(text)){
            filter.add(datum);
          }
        });
        print(filter.length);
        if(filter.length > 0){
          setState(() {
            filteredData = filter;
          });
        } else {
          setState(() {
            filteredData = [];
          });
        }
      } else {
        setState(() {
          filteredData = this.data;
        });
      }
  }

  _MyHomePageState() {
    this.fetchData();
    _filter.addListener(this.textChangeListener);
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search List');
        _filter.clear();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this._appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: this._searchIcon,
            onPressed: this._searchPressed
          )
        ],
      ),
      body: ListView.builder(
        itemCount: this.filteredData.length,
        itemBuilder: (BuildContext context, i){
          return ListTile(
            title: Text(this.filteredData[i]['c']),
            onTap: (){print('Tapped!');}
          );
        },
      ),
    );
  }
}
