import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'Note.dart';


class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<FormState>key1=GlobalKey();
  TextEditingController _controller =TextEditingController();

  GlobalKey<FormState>key2=GlobalKey();
  late TextEditingController _controllerEdit ;

  var noteRef=Hive.box('Notes');

  List<Map<String,dynamic>> noteList=[];
  
  @override
  void initState() {
    getNotes();
    super.initState();
  }
  
  Future<void> addNote(Note note) async {
    await noteRef.add(note);
    getNotes();
    setState(() {
    });
    print(noteList.first);

  }

  void getNotes(){
    noteList=noteRef.keys.map((key){
     var current=noteRef.get(key);
     return {
       'key': key,
       'containt': current.containt,
       'date':current.date
     };

    }).toList();

  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(

       title: Text('Note App'),
       backgroundColor: Colors.cyan,
     ),

     body: SingleChildScrollView(
       child: Padding(
         padding: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
         child: Column(
           children: [
             Form(
                 key: key1,
                 child: TextFormField(
       
                   controller: _controller,
       
                   validator: (value) {
                     return value!.isEmpty ?'This Field IS Required': null;
                   },
       
                   keyboardType: TextInputType.text,
       
                   decoration: InputDecoration(
                       prefixIcon: Icon(Icons.note_add),
                       prefixIconColor: Colors.cyan,
                       label: Text('Type Your Note'),
                       enabledBorder:OutlineInputBorder(
                         borderRadius: BorderRadius.circular(25),
                         borderSide: BorderSide(color: Colors.green,width: 2),
                       ),
                       errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(25),
                           borderSide: BorderSide(color: Colors.red,width: 2)
                       ),
                       focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(25),
                           borderSide: BorderSide(color: Colors.indigo,width: 2)
                       )
       
                   ),
                 )
             ),
       
             SizedBox(height: 20,),
       
             ElevatedButton(
                 onPressed: (){
       
                   if(key1.currentState!.validate()) {
                     Note n=Note(containt: _controller.value.text, date: _getDate());
                     addNote(n);
                     _controller.clear();
                   }
                 },
                 child: Text('Submit',style: TextStyle(fontSize: 17),)),
       
             SizedBox(height: 15,),
       
       
             noteList.isEmpty?
             Column(
                   children: [
                     Image.network('https://icons.veryicon.com/png/o/business/financial-category/no-data-6.png',width: 200,fit:BoxFit.cover,),
                     SizedBox(height: 10,),
                     Text('No Data Found',style: TextStyle(fontSize: 18,color: Colors.red),),
                   ],
                 )
             :Container(
               height: 500,
               padding: EdgeInsets.symmetric(horizontal: 5),
               child: ListView.builder(
                 shrinkWrap: true,
                 itemCount: noteList.length,
                 itemBuilder: (context, index) {
                   return  ListTile(
                      leading: Icon(Icons.note_alt,color: Colors.cyanAccent,),
                      title:Text(noteList[index]['containt']) ,
                      subtitle:Text(noteList[index]['date']) ,
                     trailing: Container(
                       width: 100,
                       child: Row(
                         mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                         children: [
                           IconButton(
                               onPressed:(){
                                 _showDialog(noteList[index]['key']);
                               }
                               , icon: Icon(Icons.edit,color: Colors.blue,)
                           ),
                           IconButton(
                               onPressed:(){
                                 _deleteNote(noteList[index]['key'],index);
                               }
                               , icon: Icon(Icons.delete,color: Colors.red,)
                           ),
                         ],
                       ),
                     ),
                   );
                 },
                ),
             )

       
       
           ],
         ),
       ),
     )


     ,
   );
  }

 String _getDate() {
  DateTime date =DateTime.now();
  String dateFormated=DateFormat('yyy-MM-dd- hh:mm ').format(date);
  return dateFormated;

  }

  void _showDialog(int key) {
  _controllerEdit=TextEditingController();
  showDialog(
      context: context,
      builder:(context)=>
         AlertDialog(

            title: const Text('Update Note',textAlign: TextAlign.center,style: TextStyle(decoration: TextDecoration.underline,decorationColor: Colors.blueAccent,decorationThickness:1.5 ),),

            content: Container(
              width: MediaQuery.of(context).size.width*.95,
              child: Wrap(
                  children: [
                    Container(
                      height: 10,
                    ),
                    Form(
                        key: key2,
                        child:  TextFormField(

                          controller: _controllerEdit,

                          validator: (value) {
                            return value!.isEmpty ?'This Field IS Required': null;
                          },

                          keyboardType: TextInputType.text,

                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.note_add),
                              prefixIconColor: Colors.cyan,
                              label: Text('Type Your Note'),
                              enabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.green,width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.red,width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide(color: Colors.indigo,width: 2)
                              )

                          ),
                        )
                    ),
                  ],

              ),
            ),
           actions: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 ElevatedButton(onPressed: (){
                   Navigator.of(context ).pop();
                 },
                     child: Text('Cancel',style: TextStyle(color: Colors.red),)
                 ),
                 SizedBox(width: 10,),
                 ElevatedButton(onPressed: (){
                   if(key2.currentState!.validate()){
                     Note note=Note(containt: _controllerEdit.value.text, date: _getDate());
                     _updateNote(note,key);
                   }
                   Navigator.of(context ).pop();
                 },
                     child: Text('Update',style: TextStyle(color: Colors.blue),)
                 ),
               ],
             )


           ],
          )
  );


  }

  void _deleteNote(int key,int index) {
    noteRef.delete(key);
    noteList.removeAt(index);
    setState(() {
    });
  }

  void _updateNote(Note note, int key) {
    noteRef.put(key, note);
    getNotes();
    setState(() {
    });

  }




}