import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final TextEditingController passwordEditingController =
        TextEditingController();
    final TextEditingController emailEditingController =
        TextEditingController();

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
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) {
                      appState.processLogin(
                          context,
                          emailEditingController.text.trim(),
                          passwordEditingController.text.trim());
                    },
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  //TODO FORGOT PASSWORD SCREEN GOES HERE

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (_) => const LoginScreen())
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
                    appState.processLogin(
                        context,
                        emailEditingController.text.trim(),
                        passwordEditingController.text.trim());
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
