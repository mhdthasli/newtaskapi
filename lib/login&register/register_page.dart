import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/my_button.dart';

import '../components/my_text_field.dart';
import '../pages/homepage.dart';
import '../services/firebase.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_open_rounded,
                    size: 100,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Let's create an account for you",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // email text field
                  MyTextfield(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return "Enter some value";
                        } else {
                          return null;
                        }
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
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // confirm password text field
                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                      validator: (confirmPassword) {
                        if (confirmPassword == null || confirmPassword.isEmpty) {
                          return "Password cannot be empty";
                        } else if (confirmPassword != passwordController.text) {
                          return "Passwords do not match";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // sign up button
                  MyButton(
                    text: "Sign Up",
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        FireHelper1 fireHelper = FireHelper1();
                        String? result = await fireHelper.signUp(
                          mail: emailController.text,
                          password: passwordController.text,
                        );
                        if (result == null) {
                          Get.to(() => ImageSearchScreen() );
                        } else {
                          Get.snackbar(
                            "Error",
                            "Sign Up failed: $result",
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // already have an account? Login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap ?? () {
                          print("onTap is not defined");
                        },
                        child: Text(
                          "Login Now",
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
        ),
      ),
    );
  }
}
