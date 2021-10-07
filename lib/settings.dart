import 'package:bchecks/services/auth.dart';
import 'package:bchecks/settings/welcome_card.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    bool _signedIn = true;
    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        // backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          WelcomeCard(),
          Expanded(
            child: ListView(
              children: [
                SwitchListTile(
                  activeColor: Colors.green,
                  tileColor: Colors.white,
                  title: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.red),
                  ),
                  secondary: Icon(Icons.power_settings_new_sharp),
                  value: _signedIn,
                  onChanged: (bool value) async {
                    await _authService.signOut();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
