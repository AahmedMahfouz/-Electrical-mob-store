import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import './home_body.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: homeAppBar(context),
      body: HomeBody(),
    );
  }

  AppBar homeAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      title: Text(
        'مرحبا بكم في متجر الإلكترونيات',
        style: GoogleFonts.almarai(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await _auth.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}