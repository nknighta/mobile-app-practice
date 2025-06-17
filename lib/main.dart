import 'package:flutter/material.dart';
import 'layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final title = 'Flutterサンプル';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: this.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title}) : super();
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static var _message = 'ok.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                _message,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Roboto",
                ),
              ),
            ),

            Padding(padding: EdgeInsets.all(10.0)),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: buttonPressed,
                child: Text(
                  "TAP ME!",
                  style: TextStyle(
                    fontSize: 32.0,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: showLicense,
                child: Text(
                  "LICENSE!",
                  style: TextStyle(
                    fontSize: 32.0,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: showSubView,
                child: Text(
                  "Sub View",
                  style: TextStyle(
                    fontSize: 32.0,
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _message = 'You pressed the button!';
                });
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            ),
            
          ],
        ),
      ),
    );
  }

  void buttonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("is open page?"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
            autofocus: false,
            clipBehavior: Clip.hardEdge,
          ),
        ],
        content: Text("You pressed the button!"),
      ),
    );
  }

  void showLicense() {
    showAboutDialog(
      context: context,
      applicationName: 'Test Application',
      applicationVersion: '0.1.0',
      applicationIcon: Icon(Icons.flutter_dash),
      children: [
        Text('this is flutter practice application.'),
        Text('This application is for learning Flutter.'),
      ],
    );
  }

  void showSubView() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubView()));
  }
}

class SubView extends StatelessWidget {
  const SubView({Key? key}) : super(key: key);
  void backToMainView(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sub View'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => backToMainView(context),
        ),
      ),
      body: Center(
        child: Text(
          'This is a sub view.',
          style: TextStyle(fontSize: 24.0),
        ),
      ), 
    );
  }
}
