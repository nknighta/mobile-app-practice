import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_app_class/login_screen.dart';
import 'todo_view.dart'; // Import TodoView
import 'firebase_options_secure.dart'; // Import secure Firebase options
import 'package:mobile_app_class/auth_service.dart'; // Import AuthService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Warning: Could not load .env file. Using fallback configuration.');
    // In production, you might want to exit the app or use fallback values
  }
  
  // Validate Firebase configuration
  if (!SecureFirebaseOptions.validateConfiguration()) {
    debugPrint('Warning: Firebase configuration is incomplete.');
  }
  
  await Firebase.initializeApp(
    options: SecureFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final title = 'Flutterサンプル';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: StreamBuilder<User?>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return TodoView(title: title);
          } 
          return LoginScreen();
        },
      ),
      routes: {
        '/todo': (context) =>
            TodoView(title: title), // Use TodoView as the home page
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
