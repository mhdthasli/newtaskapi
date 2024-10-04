import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../pages/homepage.dart';
import '../services/firebase.dart';




class LoginPages extends StatefulWidget {
  final void Function()? onTap;

  const LoginPages({super.key, required this.onTap});

  @override
  State<LoginPages> createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  String? email;
  String? password;

  // form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.lock_open_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // message, app slogan
              Text(
                " ",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 25),

              // form with email and password fields
              Form(
                key: formKey, // attach the form key
                child: Column(
                  children: [
                    // email text field
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(hintText: "Email"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) {
                          if (email == null || email.isEmpty || !email.contains("@") || !email.contains(".com")) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // password text field
                    MyTextfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(hintText: "Password"),
                        obscureText: true,
                        validator: (password) {
                          if (password == null || password.isEmpty || password.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // sign-in button
              MyButton(
                text: "Sign In",
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    // Access email and password directly from the TextEditingController
                    String email = emailController.text.trim();
                    String password = passwordController.text.trim();

                    print("Email: $email");
                    print("Password: $password");

                    if (email.isNotEmpty && password.isNotEmpty) {
                      FireHelper1()
                          .signIn(
                        mail: email,
                        password: password,
                      ).then((value) {
                        if (value == null) {
                          // Successful sign-in, navigate to HomePage
                          Get.to(() => ImageSearchScreen());
                        } else {
                          // Sign-in error, show a snackbar with the error message
                          Get.snackbar(
                            "Error",
                            "Sign-in failed: $value",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      });
                    } else {
                      Get.snackbar(
                        "Error",
                        "Email or Password cannot be empty.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
              ),


              const SizedBox(height: 25),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
