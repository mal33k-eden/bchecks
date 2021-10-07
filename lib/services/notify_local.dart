import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotifyLocal {
  void init() {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/res_logo.png',
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              channelShowBadge: true,
              importance: NotificationImportance.High,
              ledColor: Colors.white)
        ]);
  }

  void permission(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Allow Notifications'),
                  content: Text(
                      'BCHECKS will only send you notifications when neccessary.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Don\t Allow',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((value) => Navigator.pop(context));
                        },
                        child: Text(
                          'Allow',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ));
      }
    });
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  Future<void> notifyEasy() async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title:
            '${Emojis.money_money_bag} ${Emojis.smile_crying_face} High On The Spending',
        body:
            'You have exceeded your budgets. You balance is in the negatives!',
      ),
    );
  }
}
