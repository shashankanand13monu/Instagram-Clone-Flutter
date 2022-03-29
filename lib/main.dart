import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/responsive/mobile_responsive.dart';
import 'package:instagram_flutter/responsive/responsive_screen.dart';
import 'package:instagram_flutter/responsive/webscreen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/screens/sign_up.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:provider/provider.dart';
import 'dart:ffi';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyB7H4_AQs3h2eJXdNXsh623mUwESD9tCRU',
          appId: '1:1041767658826:web:2db86f08f5557846687db3',
          messagingSenderId: '1041767658826',
          projectId: 'instagram-clone-ec0a3',
          storageBucket: 'instagram-clone-ec0a3.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => MobileResponsive()),
        // ChangeNotifierProvider(create: (_) => WebScreenLayout()),
        // ChangeNotifierProvider(create: (_) => AuthMethods()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),
        // webScreenLayout: WebScreenLayout(),),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout());
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.red,
                  child: Text(snapshot.error.toString()),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                color: Colors.blue,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return LoginScreen();
          },
        ),
      ),
    );
  }
}
