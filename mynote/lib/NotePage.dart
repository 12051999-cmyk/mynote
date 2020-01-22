import 'package:flutter/material.dart';
import 'package:mynote/DBHelper.dart';
import 'package:mynote/mynote.dart';

class NotePage extends StatefulWidget {
  NotePage(this._mynote, this._isNew);

  final Mynote _mynote; 
  final bool _isNew;

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String title;
  bool btnSave=false;
  bool btnEdit=true;
  bool btnDelete=true;

  Mynote mynote;
  String createDate;

  final cTitle=TextEditingController();
  final cNote=TextEditingController();

   var now = DateTime.now();

   bool _enabledTextFiled=true; 


   Future addRecord() async{
     var db= DBHelper();
     String dateNow="${now.day}-${now.month}-${now.year}, ${now.hour}:${now.minute}";

     var mynote= Mynote(cTitle.text, cNote.text,dateNow,dateNow,now.toString());
     await db.saveNote(mynote);
     print("saved");

   }

    Future updateRecord() async{
     var db= new DBHelper();
     String dateNow="${now.day}-${now.month}-${now.year}, ${now.hour}:${now.minute}";

     var mynote=new Mynote(cTitle.text, cNote.text, createDate, dateNow, now.toString());


     mynote.setNoteid(this.mynote.id);
     await db.updateNote(mynote);
   }


  void saveData(){
    if(widget._isNew){
      addRecord();
    }else{
      updateRecord();
    }
    Navigator.of(context).pop();
  }

  void _editData(){
    setState(() {
      _enabledTextFiled=true;
      btnEdit=false;
      btnSave=true;
      btnDelete=true;
      title="Edit Note"; 
    });
  }

  void delete(Mynote mynote){
    var db=new DBHelper();
    db.deleteNote(mynote);
  }

  void _comfireDelete(){
    AlertDialog alertDialog= AlertDialog(
      content: Text("anda yakin ??", style: TextStyle(fontSize: 20.0),),
      actions: <Widget>[
        RaisedButton(
          color: Colors.red,
          child: Text("OK Hapus", style: TextStyle(color: Colors.black)),
          onPressed: (){
            Navigator.pop(context);
              delete(mynote);
            Navigator.pop(context);  
          },
        ),

        RaisedButton(
          color: Colors.yellow,
          child: Text("Cencle", style: TextStyle(color: Colors.blue)),
          onPressed: (){
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(context: context, child: alertDialog);
  }

  @override
  void initState() {
    if(widget._mynote !=null){
       mynote = widget._mynote;
       cTitle.text=mynote.title;
       cNote.text = mynote.note;
       title="My Note";
       _enabledTextFiled=false;
       createDate=mynote.createDate;

    }
    
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    if (widget._isNew) {
      title = "New Note";
      btnSave = true;
      btnEdit = false;
      btnDelete = false;
    
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(title,
                style: TextStyle(color: Colors.black, fontSize: 20.0))),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: Colors.black,
              size: 25.0,
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CreateButton(
                  icon: Icons.save,
                  enable: btnSave,
                  onpress: saveData,
                ),
                CreateButton(
                  icon: Icons.edit,
                  enable: btnEdit,
                  onpress: _editData,
                ),
                CreateButton(
                  icon: Icons.delete,
                  enable: btnDelete,
                  onpress: _comfireDelete,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                enabled: _enabledTextFiled,
                controller: cTitle,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none
                ),
                style: TextStyle(fontSize: 24.0,color: Colors.grey[800]),
                maxLines: null,
                keyboardType: TextInputType.text,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: cNote,
                enabled: _enabledTextFiled,
                decoration: InputDecoration(
                  hintText: "Write here..",
                  border: InputBorder.none
                ),
                style: TextStyle(fontSize: 24.0,color: Colors.grey[800]),
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.newline,
              ),
            )

          ],
        ),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  final IconData icon;
  final bool enable;
  final onpress;

  CreateButton({this.icon, this.enable, this.onpress});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: enable ? Colors.purple : Colors.grey),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 20.0,
        onPressed: () {
          if (enable) {
            onpress();
          }
        },
      ),
    );
  }
}
