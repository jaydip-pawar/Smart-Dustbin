import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin/provider/dusty_provider.dart';
import 'package:smart_dustbin/screens/bin_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _dustyProvider = Provider.of<DustyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dustbin List",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _dustyProvider.db.collection('Dustbins').orderBy("Number").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.size,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  title: Text(snapshot.data!.docs[index].get("Name")),
                  subtitle: Text(snapshot.data!.docs[index].get("Location")),
                  trailing: Icon(
                    snapshot.data!.docs[index].get("Status") == true
                      ? CupertinoIcons.trash_fill
                      : CupertinoIcons.trash_slash_fill,
                    color: snapshot.data!.docs[index].get("Status") == true
                      ? Colors.green
                      : Colors.red,
                  ),
                  onTap: () {
                    if(snapshot.data!.docs[index].get("Status") == true) {
                      Navigator.pushNamed(
                        context,
                        BinScreen.id,
                        arguments: ScreenArguments(
                          snapshot.data!.docs[index].get("Number").toInt(),
                          snapshot.data!.docs[index].get("LocationLink"),
                          snapshot.data!.docs[index].get("Name"),
                          snapshot.data!.docs[index].get("Location"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Dustbin not installed yet!")));
                    }
                  },
                ),
              ),
            );
        },
      ),
    );
  }
}
