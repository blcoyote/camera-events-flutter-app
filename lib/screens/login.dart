import 'package:camera_events/models/token.model.dart';
import 'package:camera_events/services/api_wrapper.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var appState = context.findAncestorStateOfType<MyAppState>();
    bool loading = false;
    final TextEditingController passwordEditingController =
        TextEditingController();
    final TextEditingController emailEditingController =
        TextEditingController();

    Future<void> processLogin() async {
      loading = true;

      // do api check and if successful. set token and
      try {
        TokenModel token = await ApiService()
            .login(emailEditingController.text, passwordEditingController.text);
        appState?.setLoggedIn(token.accessToken);
      } catch (e) {
        // TODO: else display error message snackbar?
      }

      

      loading = false;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Center(
                  child: SizedBox(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image(
                      image: AssetImage('lib/assets/cctv.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
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
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: MaterialButton(
                  onPressed: () {
                    processLogin();
                  },
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              const Text('New User? Create Account')
            ],
          ),
        ),
      ),
    );
  }
}
