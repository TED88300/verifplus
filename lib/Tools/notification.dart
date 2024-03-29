import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:verifplus/Tools/MsgNotif.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  final MsgNotifCtlr = StreamController<MsgNotif>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        var data = "";
        var notification = "";

        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
          data = message.data['data'];
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
          notification = message.data['notification'];
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);

        var title = message.notification!.title!;
        var body = message.notification!.body!;

        MsgNotif wMsgNotif = MsgNotif(data: data, title: title, body: body, notification: notification);
        MsgNotifCtlr.sink.add(wMsgNotif);
      },
    );
    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
