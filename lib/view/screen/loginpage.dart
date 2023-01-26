// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../global/global.dart';
import '../../helper/cloud_firestore.dart';
import '../../helper/firebase_auth_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  String? email;
  String? password;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.purple,
        body: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          alignment: Alignment.center,
          height: height,
          width: width,
          child: Form(
            key: loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter Voter email",
                    hintStyle: TextStyle(color: Colors.white),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                    labelText: "Voter email",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white),
                    ),
                    border: OutlineInputBorder(),
                  ),
                  controller: emailLoginController,
                  onSaved: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your email first" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    hintText: "Enter Voter password",
                    hintStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.white),
                    labelText: "Voter password",
                  ),
                  controller: passwordLoginController,
                  onSaved: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your password first" : null,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not Yet Resister ?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('r_page');
                      },
                      child: const Text(
                        "New",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        loginFormKey.currentState!.save();
                        await CloudFirestoreHelper.firebaseFirestore
                            .collection('user')
                            .doc(email!)
                            .snapshots()
                            .forEach((element) async {
                          Global.user = {
                            'email': element.data()?['email'],
                            'vote': element.data()?['vote'],
                          };

                          User? user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .loginUser(email: email!, password: password!);

                          // ignore: duplicate_ignore
                          if (user != null) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Successful"),
                                backgroundColor: Colors.purple,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            Navigator.of(context).pushReplacementNamed('/');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Failed"),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                          email = "";
                          password = "";
                          emailLoginController.clear();
                          passwordLoginController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
