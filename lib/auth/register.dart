import 'package:bchecks/services/auth.dart';
import 'package:bchecks/widgets/forms/shared.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleAuthView;
  const Register({required this.toggleAuthView, Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _registerFormKey = GlobalKey<FormState>();
  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nickNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              'Register',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _registerFormKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textFieldDecorator.copyWith(
                        label: const Text('Nickname'),
                        hintText: 'e.g pokinated'),
                    validator: (val) => validateTextField(val),
                    controller: nickNameController,
                    // The validator receives the text that the user has entered.
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textFieldDecorator.copyWith(
                        label: const Text('E-mail'),
                        hintText: 'e.g pokinated@example.com'),
                    validator: (input) =>
                        input!.isValidEmail() ? null : "enter a valid email",
                    controller: emailController,
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
                    validator: (val) => validatePasswordField(val),
                    controller: passwordController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: textFieldDecorator.copyWith(
                        label: const Text('Re-Password'),
                        hintText: 'Re-type your password'),
                    obscureText: true,
                    validator: (val) =>
                        validateRePasswordField(val, passwordController),
                    controller: confirmPasswordController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: btnStyle,
                    onPressed: () {
                      if (_registerFormKey.currentState!.validate()) {
                        showSnackBar(
                            context: context, message: 'processing data');
                        _registerUser();
                      }
                    },
                    child: const Text(
                      'Register',
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
                    const Text('Already have an account? '),
                    TextButton.icon(
                        onPressed: () {
                          widget.toggleAuthView();
                        },
                        icon: const Icon(Icons.login),
                        label: const Text('Sign In'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    dynamic result = await _authService.registerUser(
        email: emailController.text,
        password: passwordController.text,
        nickname: nickNameController.text);
    print(result);
    if (result is String) {
      showSnackBar(context: context, message: result);
    }
  }
}
