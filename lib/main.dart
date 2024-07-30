import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_task/Providers/auth_provider.dart';
import 'package:pingolearn_task/Providers/comment_provider.dart';
import 'package:pingolearn_task/Providers/remote_config_provider.dart';
import 'package:pingolearn_task/Screens/Auth/auth_screen.dart';
import 'package:pingolearn_task/Screens/Home/home_screen.dart';
import 'package:pingolearn_task/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => RemoteConfigProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comments App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer<UserAuthProvider>(
        builder: (context, authProvider, _) {
          return StreamBuilder<User?>(
            stream: authProvider.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: Center(child:  CircularProgressIndicator()));
              } else if (snapshot.hasData) {
                return HomeScreen();
              } else {
                return AuthScreen();
              }
            },
          );
        },
      ),
      routes: {
        '/login': (context) => AuthScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
