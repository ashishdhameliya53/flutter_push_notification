import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_push_notification/notification_badge.dart';
import 'package:flutter_push_notification/second_screen.dart';
import 'package:flutter_push_notification/third_screen.dart';
import 'package:overlay_support/overlay_support.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  '101',
  'test',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.data}");
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: navigatorKey,
        home: MyHomePage(),
        routes: {
          '/homeScreen': (context) => MyHomePage(),
          '/secondScreen': (context) => SecondScreen(),
          '/thirdScreen': (context) => ThirdScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Map<String, dynamic>? arg;
  MyHomePage({this.arg});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

int _totalNotification = 0;

String? title;

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        switch (message.data['notification_type']) {
          case '1':
            // Navigator.pushReplacementNamed(context, '/homeScreen');
            navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                builder: (context) => MyHomePage(
                      arg: message.data as Map<String, dynamic>,
                    )));
            break;
          case '2':
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                "/secondScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/secondScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>);
            break;
          case '3':
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/thirdScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/thirdScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>);
            break;
          default:
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('new message published : ${message.data}');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      FirebaseMessaging.instance.getToken().then((value) {
        String? token = value;
        print('token --> $token');
      });
      // _streamController.add(message.data);
      if (notification != null && android != null) {
        switch (message.data['notification_type']) {
          case '1':
            // Navigator.pushReplacementNamed(context, '/homeScreen');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyHomePage(
                      arg: message.data as Map<String, dynamic>,
                    )));
            break;
          case '2':
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/secondScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/secondScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>);
            break;
          case '3':
            Navigator.of(context).pushNamedAndRemoveUntil(
                "/thirdScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/thirdScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>);
            break;
          default:
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      FirebaseMessaging.instance.getToken().then((value) {
        String? token = value;
        print('token --> $token');
      });
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? notificationType) async {
        if (notificationType != null) {
          switch (notificationType) {
            case '1':
              // Navigator.pushReplacementNamed(context, '/homeScreen');
              navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        arg: message.data as Map<String, dynamic>,
                      )));
              break;
            case '2':
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                "/secondScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/secondScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>,
              );
              break;
            case '3':
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/thirdScreen",
                (route) =>
                    route.isCurrent || route.settings.name == "/thirdScreen"
                        ? false
                        : true,
                arguments: message.data as Map<String, dynamic>,
              );
              break;
            default:
          }
        }
      });
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          )),
          payload: message.data['notification_type'],
        );
      }
    });
  }

  void showNotifictaion() {
    setState(() {
      counter++;
      _totalNotification++;
    });
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing $counter",
      "this is testing",
      NotificationDetails(
          android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        color: Colors.blue,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arg);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notification'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                showNotifictaion();
              },
              child: const Text('push notification')),
          NotificationBadge(totalNotifications: _totalNotification),
          // Text(widget.arg.toString()),
        ],
      )),
    );
  }
}
