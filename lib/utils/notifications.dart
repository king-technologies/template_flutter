import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'constants.dart';

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initialize() {
  const initializationSettingsAndroid = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_launcher'));
  _notificationsPlugin.initialize(
    initializationSettingsAndroid,
  );
}

Future<void> display(RemoteMessage message) async {
  try {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    NotificationDetails? notificationDetails;
    notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        message.notification!.android!.sound ?? 'Channel Id',
        message.notification!.android!.sound ?? 'Main Channel',
        groupKey: 'notificationGroup',
        color: primaryColor,
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _notificationsPlugin.show(id, message.notification?.title,
        message.notification?.body, notificationDetails,
        payload: message.data['route'].toString());
  } on Exception catch (e) {
    debugPrint(e.toString());
  }
}

Future<String> downloadAndSaveFile(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final response = await get(Uri.parse(url));
  final file = File(filePath);
  await file.writeAsBytes(response.bodyBytes);
  return filePath;
}

Future<void> showBigPictureNotificationHiddenLargeIcon(
    RemoteMessage message) async {
  final largeIconPath = await downloadAndSaveFile(
      message.notification!.android!.imageUrl!, 'largeIcon');
  final bigPicturePath = await downloadAndSaveFile(
      message.notification!.android!.imageUrl!, 'bigPicture');
  final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: 'overridden <b>big</b> content title',
      summaryText: 'summary <i>text</i>');
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id', 'big text channel name',
      channelDescription: 'big text channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation);
  final platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await _notificationsPlugin.show(1, message.notification!.title,
      message.notification!.body, platformChannelSpecifics);
}
