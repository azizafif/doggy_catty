import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home_screen.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      routeName: "/",
      navigateAfterSeconds: Home(),
      title: Text(
        'Doggy and catty',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color(0xFFE99600),
        ),
      ),
      image: Image.asset('assets/dogAndcat.jpg'),
      backgroundColor: Colors.black,
      photoSize: 100,
      loaderColor: Color(0xFFEEDA28),
    );
  }
}
