import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_dustbin/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenArguments {
  final String title;
  final String description;
  final String location;
  final String image;
  final GeoPoint position;

  ScreenArguments(
      this.title, this.description, this.location, this.image, this.position);
}

class ComplaintDetails extends StatelessWidget {
  static const String id = 'complaint-details';

  const ComplaintDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    double lat = args.position.latitude;
    double lon = args.position.longitude;
    final String url = "https://maps.google.com/?q=$lat,$lon";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Complaint Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 2.0,
      ),
      body: Stack(
        children: [
          Stack(
            children: [
              Container(height: 200, color: Colors.grey),
              Positioned.fill(
                child: Image.network(
                  args.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (
                    BuildContext context,
                    Widget child,
                    ImageChunkEvent? loadingProgress,
                  ) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  args.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  args.location,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(args.description, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              margin: EdgeInsets.all(15),
              height: 50.0,
              width: width(context) - 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Color(0xffff5f6d)),
                  ),
                  padding: EdgeInsets.all(10.0),
                  backgroundColor: Color(0xffff5f6d),
                ),
                onPressed: () async {
                  launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  );
                },
                child: Text(
                  "Go  to  Location",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
