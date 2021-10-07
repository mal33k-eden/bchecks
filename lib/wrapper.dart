import 'package:bchecks/auth/auth_manager.dart';
import 'package:bchecks/home.dart';
import 'package:bchecks/models/owner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Owner?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      return HomePage(
        userId: user.uid,
      );
    }
  }
}
