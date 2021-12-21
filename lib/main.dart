import 'package:firebase_template_app/view/ui/home/home_screen.dart';
import 'package:firebase_template_app/view/ui/root/root_screen.dart';
import 'package:firebase_template_app/view/ui/welcome/welcome_screen.dart';
import 'package:firebase_template_app/view/utils/flutter_fire_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// arch -x86_64 pod install
// arch -x86_64 pod repo update
// arch -x86_64 pod install --repo-update
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _fireUI = FlutterFireUIList();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: RootScreen.id,
        routes: {
          RootScreen.id: (context) => const RootScreen(),
          HomeScreen.id: (context) => const HomeScreen(),
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          '/sign_in': (context) => _fireUI.signIn(),
          '/profile': (context) => _fireUI.profileScreen(),
          '/forgot-password': (context) => _fireUI.forgotPasswordScreen(context)
        });
  }
}
