import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_dustbin/provider/authentication_provider.dart';
import 'package:smart_dustbin/screens/bin/bin_list.dart';
import 'package:smart_dustbin/screens/complaints/complaint_list.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main-screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [BinList(), ComplaintList()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authentication = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Smart Dusty",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                authentication.signOut(context);
              },
              icon: Icon(Icons.logout, color: Colors.black,),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Dustbins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Complaints',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xffff5f6d),
        onTap: _onItemTapped,
      ),
    );
  }
}
