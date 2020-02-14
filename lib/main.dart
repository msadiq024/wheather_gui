import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wheather_gui/util.dart' as util;


void main() => runApp (kal());


class kal  extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "hamari app ",
        debugShowCheckedModeBanner: false,
        home: klimatic()
    );
  }
}

class klimatic  extends StatefulWidget {
  @override
  _klimaticState  createState() => new _klimaticState ();
}

class _klimaticState extends State<klimatic>{

  String _cityEntered;
  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
        new  MaterialPageRoute(builder: (BuildContext context){
          return new changeCity();
        })
    );
    if(results != null && results.containsKey('enter')){
      print(results['enter'].toString());
      _cityEntered = results['enter'];
      //debugPrint("From First Screen "+results['enter'].toString());
    }
  }
  void showStuff() async {
    Map data = await getWeather(util.appId, util.defultcity);
    print(data.toString());
  }
    @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: (){_goToNextScreen(context); })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/background.jpg',
              width: 470.0,
              height: 1200.0,
              fit: BoxFit.fill,
          ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 20.9, 0.0),
            child: new Text('${_cityEntered == null ? util.defultcity : _cityEntered}',
            style:  cityStyle(),
            ),

          ),
          new Container(
            alignment: Alignment.center,
    child: new Image.asset('images/background.jpg'),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city)
 async {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=imperial';
        // String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q={city name}&appid='
    // '{your api key}';

    http.Response response = await http.get(apiUrl);

    //var JSON;
    return json.decode(response.body);
 }
 Widget updateTempWidget(String city){
    return new FutureBuilder(
      future: getWeather(util.appId, city == null? util.defultcity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          Map content = snapshot.data;
          return  new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(content['main']['temp'].toString(),
                  style: new TextStyle(
                    fontSize: 49.9,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    color: Colors.white,
                  ),
                  ),
                ),
              ],
            ),
          );
        }else {
          return new Container();
        }

      }
    );
 }
}

class changeCity extends StatelessWidget {
  var  _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: new Text('Change City '),
        centerTitle: true,
      ),
      body: new Stack(
      children: <Widget>[
    new Center(
    child: new Image.asset('images/background.jpg',
      width: 360,
      height: 200.0,
      fit: BoxFit.fill,
    ),
    ),
        new ListView(
          children: <Widget>[
            new ListTile(
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: 'Enter City ',
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              ),

            ),
            new ListTile(
              title: new FlatButton(
                  onPressed: (){
                    Navigator.pop(context, {
                      'enter': _cityFieldController.text
                    });
                  },
                  textColor: Colors.red,
                  color: Colors.white70,
                  child: new Text('Get weather')),
            )
          ],
        )
       ]
      ),
    );
  }
}

    TextStyle temStyle() {
    return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 49.9,

    );
    }

TextStyle cityStyle() {
   return new TextStyle(
     color: Colors.yellow,
     fontSize: 30,
     fontStyle: FontStyle.italic,
   );
}