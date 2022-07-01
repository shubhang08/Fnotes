import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fnotes/screens/note_editor.dart';
import 'package:fnotes/screens/note_reader.dart';
import 'package:fnotes/widgets/notes_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import '../widgets/app_style.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Dainandini'),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Your Recent Notes', style: GoogleFonts.roboto(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 8.0,),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("Notes")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return Container(
                        child: GridView(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                            children: snapshot.data!.docs.map((note) =>
                                noteCard(() {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) =>
                                          NoteReaderScreen(note)));
                                }, note)).toList()),
                      );
                      //   return GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      // children:snapshot.data!.docs.map((note)=>noteCard(() {}, note)).toList(growable: true)
                      //   );
                    }
                    //   return GridView(
                    //     gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    //     children: snapshot.data!.docs.map((note)=>noteCard((){} ,note)).toList());
                    // }
                    return Text("there's no Notes",
                        style: GoogleFonts.nunito(color: Colors.white));
                  }

              ),
            ),



          ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context)=>NoteEditorScreen()));
        }, label:const Text('Add Note'), icon: const Icon(Icons.add),),
    );
  }
}
