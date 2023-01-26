// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/cloud_firestore.dart';
import '../../helper/firebase_auth_helper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisible = false;
  String? email;
  String? password;
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
            key: registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
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
                  controller: emailController,
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
                  obscureText: isVisible,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Voter password",
                    hintStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
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
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white),
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
                  controller: passwordController,
                  onSaved: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your password first" : null,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (registerFormKey.currentState!.validate()) {
                        registerFormKey.currentState!.save();
                        User? user = await FireBaseAuthHelper.fireBaseAuthHelper
                            .registerUser(email: email!, password: password!);
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Register Successful"),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          await CloudFirestoreHelper.cloudFirestoreHelper
                              .insertRecord(email: email!, vote: false);
                          Navigator.of(context)
                              .pushReplacementNamed('login_page');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Register Failed"),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        email = "";
                        password = "";
                        emailController.clear();
                        passwordController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Register",
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
