import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  

  //.env file
  await dotenv.load(fileName: ".env");
  String apikey = dotenv.env["FIREBASE_API_KEY"].toString();
  String appId = dotenv.env["APP_ID"].toString();
  String messagingSenderId = dotenv.env["MESSAGING_SENDER_ID"].toString();
  String projectId = dotenv.env["PROJECT_ID"].toString();
  String storageBucket = dotenv.env["STORAGE_BUCKET"].toString();
  

  print(apikey);
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: apikey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId,
          storageBucket: storageBucket),
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
  //   SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.top],

  
  // );
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
