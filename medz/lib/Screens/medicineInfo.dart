import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medz/Classes/Medicine.dart';
import 'package:medz/Classes/NotificationService.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineInfo extends StatelessWidget {
  const MedicineInfo({super.key, required this.med});
  final Medicine med;
  static notificationDetails() async {
    print('object');
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id', // Replace with your channel ID
        'Your Channel Name', // Replace with your channel name
        channelDescription:
            'Channel description', // Replace with your channel description
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future scheduleAlarm() async {
    // Request notification permissions

    print('Scheduling alarm...');
/*
    return NotificationService.flutterLocalNotificationsPlugin
        .show(0, 'here', 'body', await notificationDetails());
*/
    return NotificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID
      'Your Alarm', // Notification title
      'Time to wake up!', // Notification body
      _nextInstanceOfAlarm(
        DateTime.now().add(
          const Duration(seconds: 15),
        ),
      ),
      await notificationDetails(),

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfAlarm(DateTime scheduledTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute);
    print('Now: $now');
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(seconds: 20),
      );
    }
    print('Scheduled Date: $scheduledDate');
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await scheduleAlarm();
            },
            child: const Text('Set Alarm'),
          ),
        ],
      ),
    );
  }
}
