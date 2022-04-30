import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin/constants.dart';
import 'package:smart_dustbin/model/custome_dustbin.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smart_dustbin/provider/dusty_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenArguments {
  final int number;
  final String url;
  final String name;
  final String location;

  ScreenArguments(this.number, this.url, this.name, this.location);
}

class DustbinClipper extends CustomClipper<Path> {
  Rect getApproximateClipRect(Size size) =>
      Rect.fromLTRB(0, 0, size.width, size.height);

  Path getClip(Size size) => CustomDustbin().getPath(size);

  bool shouldReclip(DustbinClipper _) => false;
}

class BinScreen extends StatefulWidget {
  static const String id = 'bin-screen';

  const BinScreen({Key? key}) : super(key: key);

  @override
  _BinScreenState createState() => _BinScreenState();
}

class _BinScreenState extends State<BinScreen> {
  @override
  Widget build(BuildContext context) {
    final _dustyProvider = Provider.of<DustyProvider>(context);

    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String path = "Dustbin" + args.number.toString();
    final database = FirebaseDatabase.instance.reference().child(path);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dustbin",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 2.0,
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Center(
            child: Container(
              height: height(context) * 0.5,
              width: width(context) * 0.6,
              child: ClipPath(
                clipBehavior: Clip.antiAlias,
                clipper: DustbinClipper(),
                child: StreamBuilder<Event>(
                  stream: database.onValue,
                  builder: (BuildContext context, AsyncSnapshot<Event> event) {
                    if (event.hasData) {
                      _dustyProvider
                          .setStatus(event.data!.snapshot.value["level"]);
                    }

                    return Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                                flex: (100 -
                                        event.data!.snapshot.value["level"]
                                            .toInt())
                                    .toInt(),
                                child: Container(color: Colors.blue[100])),
                            Expanded(
                                flex:
                                    event.data!.snapshot.value["level"].toInt(),
                                child: Container(color: Colors.blue)),
                          ],
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: CircularPercentIndicator(
                              radius: width(context) * 0.3,
                              lineWidth: 10.0,
                              animation: true,
                              percent: event.data!.snapshot.value["level"]
                                      .toDouble() /
                                  100,
                              center: new Text(
                                event.data!.snapshot.value["level"].toString() +
                                    "%",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: event
                                          .data!.snapshot.value["level"] >
                                      75
                                  ? Colors.red
                                  : event.data!.snapshot.value["level"] > 50
                                      ? Colors.yellow
                                      : event.data!.snapshot.value["level"] >= 0
                                          ? Colors.green
                                          : Colors.green,
                            ))
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.all(10),
            height: 50.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                padding: EdgeInsets.all(10.0),
                primary: Color.fromRGBO(0, 160, 227, 1),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 15),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Text(
                                    "Dustbin Details",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // SizedBox(height: 22),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Name: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.name,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Number: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.number.toString(),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Location: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          args.location,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Status: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          _dustyProvider.status.toString() +
                                              " %",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Close")),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Text("Show Dustbin details",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 50.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
                padding: EdgeInsets.all(10.0),
                primary: Color.fromRGBO(0, 160, 227, 1),
              ),
              onPressed: () async {
                if (await canLaunch(args.url)) {
                  launch(args.url);
                } else {
                  print("Its false");
                }
              },
              child: Text("Go To Location",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
