import 'package:flutter/material.dart';
import 'package:mobile_book/authentication/LoginScreen.dart';
import 'package:mobile_book/home/DetailsScreen.dart';
import 'package:mobile_book/home/HomeScreen.dart';
import 'package:mobile_book/registration/RegistrationScreen.dart';
import 'package:mobile_book/utils/Constants.dart';
import 'package:mobile_book/utils/Routes.dart';

void main()  => runApp(
    MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        )
      ),
      initialRoute: Routes.LOGIN,
      routes: {
        Routes.LOGIN : (context) => LoginScreen(),
        Routes.REGISTRATION : (context) => RegistrationScreen(),
        Routes.HOME: (context) => HomeScreen(),
        Routes.DETAILS: (context) => DetailsScreen()
      },
));