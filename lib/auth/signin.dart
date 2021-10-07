import 'package:bchecks/services/auth.dart';
import 'package:bchecks/widgets/forms/shared.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuthView;
  const SignIn({required this.toggleAuthView, Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _siginInFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'B C H E C K S',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                ),
                Icon(
                  Icons.widgets,
                  color: Colors.red,
                )
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            const Text(
              'Sign In',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _siginInFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textFieldDecorator.copyWith(
                        label: const Text('E-mail'),
                        hintText: 'Enter a valid email'),
                    controller: emailController,
                    validator: (val) => validateTextField(val),
                    // The validator receives the text that the user has entered.
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textFieldDecorator.copyWith(
                        label: const Text('Password'),
                        hintText: 'Enter your password'),
                    obscureText: true,
                    controller: passwordController,
                    validator: (val) => validateTextField(val),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: () async {
                      if (_siginInFormKey.currentState!.validate()) {
                        showSnackBar(
                            context: context, message: 'processing data');
                        _signinUser();
                      }
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
                  children: [
                    const Text('Don\'t have an account? '),
                    TextButton.icon(
                        onPressed: () {
                          widget.toggleAuthView();
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Register'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signinUser() async {
    dynamic result = await _authService.signinUser(
      email: emailController.text,
      password: passwordController.text,
    );
    print(result);
    if (result is String) {
      showSnackBar(context: context, message: result);
    }
  }
}
