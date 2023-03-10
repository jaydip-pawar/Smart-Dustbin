import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin/provider/dusty_provider.dart';
import 'package:smart_dustbin/screens/complaints/add_complaint.dart';
import 'package:smart_dustbin/screens/complaints/complaint_details.dart';

class ComplaintList extends StatelessWidget {
  static const String id = 'complaint-list';

  const ComplaintList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dustyProvider = Provider.of<DustyProvider>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _dustyProvider.db.collection('Complaints').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.size,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  title: Text(snapshot.data!.docs[index].get("title")),
                  subtitle: Text(snapshot.data!.docs[index].get("location")),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ComplaintDetails.id,
                      arguments: ScreenArguments(
                        snapshot.data!.docs[index].get("title"),
                        snapshot.data!.docs[index].get("description"),
                        snapshot.data!.docs[index].get("location"),
                        snapshot.data!.docs[index].get("image"),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xffff5f6d),
              Color(0xffff5f6d),
              Color(0xffffc371),
            ],
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AddComplaint.id),
          child: Icon(Icons.add),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}
