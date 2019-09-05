import 'package:flutter/material.dart';

import 'package:device_unlock/device_unlock.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _textToShow = 'Hidden Text';
  var _btnText = 'Show';
  DeviceUnlock deviceUnlock;

  @override
  void initState() {
    super.initState();
    deviceUnlock = DeviceUnlock();
  }

  void pressedButton() async {
    if (_btnText == 'Hide') {
      setState(() {
        _textToShow = 'Hidden Text';
        _btnText = 'Show';
      });
    } else {      
      var unlocked = await deviceUnlock.request();

      if (unlocked) {
        setState(() {
          _textToShow = 'Secret text now available';
          _btnText = 'Hide';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Unlock example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_textToShow),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: FlatButton(
                  child: Text(_btnText),
                  color: Colors.blue,
                  onPressed: pressedButton,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
