import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = '/Login';
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final TextEditingController passwordEditingController =
        TextEditingController();
    final TextEditingController emailEditingController =
        TextEditingController();

    loginError(String errorMessage) {
      final snackBar = SnackBar(
        content: Text('Error logging in: $errorMessage'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // no action needed
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    login() {
      appState.processLogin(emailEditingController.text.trim(), passwordEditingController.text.trim(), loginError);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60.0, bottom: 20.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 150,
                    child: Image(
                      image: AssetImage('lib/assets/cctv.webp'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailEditingController,
                    autofillHints: const [AutofillHints.username],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter valid username',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: passwordEditingController,
                    autofillHints: const [AutofillHints.password],
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      login();
                    },
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (_) => const ForgotPassword())
                  //     );
                },
                child: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: MaterialButton(
                  onPressed: () {
                    login();
                  },
                  child: appState.loggingIn
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),

              const Text(
                'New User? Create Account',
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
