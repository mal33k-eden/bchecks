import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bchecks/models/owner.dart';
import 'package:bchecks/services/auth.dart';
import 'package:bchecks/settings.dart';
import 'package:bchecks/transactions.dart';
import 'package:bchecks/widgets/onboarding.dart';
import 'package:bchecks/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  isViewed = preferences.getInt('onBoard');
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/res_logo',
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

  ///
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Owner?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[900],
          appBarTheme: AppBarTheme(backgroundColor: Colors.green[900]),
          primarySwatch: Colors.green,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.green[900]),
          scaffoldBackgroundColor: Colors.amber[50],
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => isViewed != 0 ? Onboard() : Wrapper(),
          'settings': (context) => Settings(),
          'allTrx': (context) => Transactions(),
        },
      ),
    );
  }
}
