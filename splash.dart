import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() {
    User? user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Navigator.pushReplacementNamed(context, '/store');
      } else {
        // يوديه للـ login مع رسالة
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ لازم تفعّل بريدك الإلكتروني الأول")),
        );
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الصورة
          SizedBox.expand(
            child: Image.asset(
              "assets/images/img_1.png",
              fit: BoxFit.cover,
            ),
          ),
          // طبقة شفافة فوق الصورة
          Container(color: Colors.black.withOpacity(0.3)),
          // نص الترحيب في المنتصف
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "مرحبا بكم في",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Almarai',
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "سنتر دريم",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Almarai',
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(3.0, 3.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}