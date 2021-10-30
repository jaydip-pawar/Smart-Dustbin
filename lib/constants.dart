import 'package:flutter/material.dart';
import 'package:smart_dustbin/screens/bin_screen.dart';
import 'package:smart_dustbin/screens/home_screen.dart';
import 'package:smart_dustbin/screens/splash_screen.dart';

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Map<String, Widget Function(BuildContext)> routes = {
  SplashScreen.id : (context) => SplashScreen(),
  HomeScreen.id : (context) => HomeScreen(),
  BinScreen.id : (context) => BinScreen(),
};