import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart'; // سيتم إنشاؤه تلقائياً
import 'screens/auth/splash.dart';
import 'screens/auth/login.dart';
import 'screens/auth/signup.dart';
import 'screens/store/home_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase مع الخيارات الجديدة
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Center Dream Store',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        // إعدادات النص العربية
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Almarai', fontSize: 16),
          bodyMedium: TextStyle(fontFamily: 'Almarai', fontSize: 14),
          titleLarge: TextStyle(fontFamily: 'Almarai', fontSize: 20, fontWeight: FontWeight.bold),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: kPrimaryColor),
      ),
      // دعم العربية من اليمين لليسار
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [Locale("ar", "AE")],
      locale: Locale("ar", "AE"),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/store': (context) => HomeScreen(),
      },
    );
  }
}