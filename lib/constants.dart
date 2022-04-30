import 'package:flutter/material.dart';
import 'package:smart_dustbin/model/navigate_page.dart';
import 'package:smart_dustbin/screens/bin_screen.dart';
import 'package:smart_dustbin/screens/home_screen.dart';
import 'package:smart_dustbin/screens/login/login_screen.dart';
import 'package:smart_dustbin/screens/login/signup_screen.dart';
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
  NavigatePage.id : (context) => NavigatePage(),
  SignupPage.id : (context) => SignupPage(),
  LoginScreen.id : (context) => LoginScreen(),
};