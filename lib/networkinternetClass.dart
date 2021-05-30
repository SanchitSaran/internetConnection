import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';

class InternetConnect extends StatefulWidget {
  @override
  InternetConnectState createState() => InternetConnectState();
}

class InternetConnectState extends State<InternetConnect> {
  ConnectivityResult previous;
  bool dialogshown = false;
  StreamSubscription connectivitySubscription;

  //below method is for check internet by calling google.com

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      //socketException gives us a result for no internet connection
      return Future.value(false);
    }
  }

  //this method is used here for checking internet with use of connectivity plugin
  void checkInternetConnect(BuildContext context) {
    //here we are listening to the event
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connresult) {
      if (connresult == ConnectivityResult.none) {
        //if internt conn is off we will show a dialog
        dialogshown = true;
        showDialog(
            context: context, barrierDismissible: false, child: alertDialog());
      } else if (previous == ConnectivityResult.none) {
        //here we our again checking if the internet is there we will pop the dialog
        checkinternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }

      previous = connresult;
    });
  }

  AlertDialog alertDialog() {
    return AlertDialog(
      title: Text('ERROR'),
      content: Text("No Internet Detected."),
      actions: <Widget>[
        FlatButton(
          // method to exit application programitacally

          onPressed: () {
            //and we will use appSetting package to open our setting if
            //u want u can use it
            AppSettings.openWIFISettings();
          },
          child: Text("Settings"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
