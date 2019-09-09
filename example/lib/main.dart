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
      var unlocked = false;

      try {
        unlocked = await deviceUnlock.request(
          localizedReason: "We need to check your credentials to allow you to see the hidden text",
        );
      } on DeviceUnlockUnavailable {
        unlocked = true;
      } on RequestInProgress {
        unlocked = true;
      }

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
