import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'models/Post.dart';
import 'models/DataPost.dart';

void main() => runApp(new MaterialApp(
      home: new MyReddit(),
    ));

class MyReddit extends StatefulWidget {
  State<StatefulWidget> createState() => _MyRedditState();
}

class _MyRedditState extends State<MyReddit> with SingleTickerProviderStateMixin{
  final myController = TextEditingController();
  String data="default";
  String title ="/r/all";
  List<String> _titles = ["test"];
  List<Widget> _wTitles =[];
  Future<Post> fetchPost(String t) async {

    var titles = new List<Post>();
    var response = await http.get('https://www.reddit.com/r/$t.json',
    headers: {
      "Accept":"application/json"
    });
    final data = json.decode(response.body);
    Post p = new Post.fromJson(data);
    //p.posts.map((f)=>print(f.title));
    
    return p;
  }


  @override
    void dispose() {
      
      myController.dispose();
      super.dispose();
    }
  void _updateScreen(){
    setState(() {
          data = myController.text;
          title = "/r/"+myController.text;
          fetchPost(data).then((v){
            v.posts.forEach((f){
              print("Title : "+f.title);
              _titles.add(f.title);
              _wTitles.add(Text(f.title));
            });
          });
          
        });
  }
  @override
  Widget build(BuildContext context) {
    
    var futureBuilder = new FutureBuilder(
      future: fetchPost(title),
      builder: (BuildContext c, AsyncSnapshot snapshot){
        List<DataPost> v = snapshot.data;
        return new ListView.builder(
          itemCount: v.length,
          itemBuilder: (BuildContext c, int index){
            return new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(v[index].title),
                ),
                new Divider(height: 2.0,)
              ],
            );
          },
        );

      }
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
        ),
        drawer: new Drawer(
          
          child: ListView(
            
            children: <Widget>[
            Container(
                height: 100.0,
                child:DrawerHeader(
                  child: Column(
                    children: <Widget>[
                      Text("Search"),
                      TextField(
                        controller: myController,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        onEditingComplete: (){
                          _updateScreen();
                          
                          
                          Navigator.pop(context);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Please enter subreddit'
                        )
                      )
                ],
              )) 
              ),
            
            ListTile(
              title: Text("Item 1"),
            ),
          ],

        )),
        body: new Container(
          child: ListView.builder(
            itemBuilder: (context,i){
              
            },
          )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            return showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: Text(myController.text),
                );
              },
            );

          },
        ),
      );  
  }
}
