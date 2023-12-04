import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medz/Classes/NotificationService.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:medz/Classes/Medicine.dart';

final formatter = DateFormat('yyyy-MM-dd');

class MedicineAlarmUtils {
  static Future scheduleAlarm(Medicine med) async {
    final scheduledDate = _nextInstanceOfAlarm(DateTime.now().add(
      const Duration(seconds: 15),
    ));

    print('Scheduling alarm for ${med.name}...');

    await NotificationService.flutterLocalNotificationsPlugin.zonedSchedule(
      1, // Notification ID
      'Time to take your meds', // Notification title
      med.name, // Notification body
      scheduledDate,
      await notificationDetails(),

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _nextInstanceOfAlarm(DateTime scheduledTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledTime.year,
        scheduledTime.month,
        scheduledTime.day,
        scheduledTime.hour,
        scheduledTime.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(
        const Duration(seconds: 20),
      );
    }
    return scheduledDate;
  }

  static Future<NotificationDetails> notificationDetails() async {
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
}
