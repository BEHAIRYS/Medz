import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medz/Classes/Medicine.dart';
import 'package:medz/Classes/NotificationService.dart';
import 'package:medz/Screens/medicines.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineInfo extends StatelessWidget {
  const MedicineInfo({super.key, required this.med});
  final Medicine med;
  get doseInterval {
    double timeInterval = 24 / med.dozes;
    return timeInterval.toInt();
  }

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

  Future scheduleAlarm(BuildContext context) async {
    final scheduledDate = _nextInstanceOfAlarm(DateTime.now().add(
      const Duration(seconds: 15),
    ));

    print('Scheduling alarm...');

    Future alarm =
        NotificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID
      'Time to take your meds', // Notification title
      med.name, // Notification body
      scheduledDate,
      await notificationDetails(),

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    Duration interval = scheduledDate.difference(
      tz.TZDateTime.now(tz.local),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Alarm goes off in ${interval.inHours} hours and ${interval.inMinutes % 60} minutes'),
        ),
      );
    }
    return alarm;
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
        Duration(hours: doseInterval),
      );
    }
    print('Scheduled Date: $scheduledDate');
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Text('Medicine Name:'),
                    Text(med.name),
                  ],
                ),
                Row(
                  children: [
                    const Text('Expiry Date:'),
                    Text(med.date),
                  ],
                ),
                Row(
                  children: [
                    const Text('Number of doses per day:'),
                    Text(
                      med.dozes.toString(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await scheduleAlarm(context);
                      if (context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return Medicines();
                          }),
                        );
                      }
                    },
                    child: const Text('Set Reminder'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
