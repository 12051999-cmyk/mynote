import 'package:flutter/material.dart';
import 'package:mynote/DBHelper.dart';
import 'package:mynote/NotePage.dart';
import 'package:mynote/Listnote.dart';




void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Mynote',
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var db = new DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        backgroundColor: Colors.purple,
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => new NotePage(null, true))),
      ),
      appBar: AppBar(
        title:
            Text('Mynote your note', style: TextStyle(color: Colors.white, fontSize: 24.0)),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.grey[2000],
      body: FutureBuilder(
        future: db.getNote(),
        builder: (context,snapshot){
          if(snapshot.hasError)print(snapshot.error);

          var data = snapshot.data;

          return snapshot.hasData
          ? new NoteList(data)
          : Center(child: Text("No Data"),);
        
        },
      ),
    );
  }
}
