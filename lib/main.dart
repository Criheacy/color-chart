import 'package:flutter/material.dart';
import 'package:color_chart/widgets/scroll_wheel.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Color Chart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Stack(children: [
            Center(
              child: ScrollWheel(
                minValue: 1,
                maxValue: 30,
                defaultValue: 15,
                onValueChanged: (value) {
                  print("Value Changed: $value");
                },
              ),
            ),
          ]),
        ));
  }
}
