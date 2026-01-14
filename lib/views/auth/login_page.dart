import 'package:demo/viewmodels/auth_cubit.dart';
import 'package:demo/widgets/google_sign_in_bottom.dart';
import 'package:demo/widgets/my_bottom.dart';
import 'package:demo/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Editing Controllers
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  // auth cubit
  late final authCubit = context.read<AuthCubit>();

  // login botton pressed
  void login() {
    final String email = emailController.text;
    final String pw = pwController.text;

    // ensure fields are not empty
    if (email.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    } else {
      // call login method from auth cubit
      authCubit.login(email, pw);
    }
  }

  // forgot password method
  void forgotPassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: MyTextfield(
          controller: emailController,
          hintText: "Enter email",
          obscureText: false,
        ),
        actions: [
          // close button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),

          // reset button
          TextButton(
            onPressed: () async {
              String message = await authCubit.forgotPassword(
                emailController.text,
              );
              if (message == "Password reset email sent") {
                Navigator.pop(context);
                emailController.clear();
              }
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      // AppBar

      // body
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // logo
                Icon(
                  Icons.lock_open,
                  size: 65,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(height: 20),

                // name of app
                Text(
                  "Login to Your Account",
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 20),
                // email input
                MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password input
                MyTextfield(
                  controller: pwController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => forgotPassword(),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // login button
                MyBottom(onTap: login, text: "LOGIN"),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // outh w gg
                GoogleSignInBottom(
                  onTap: () async {
                    authCubit.signInWithGoogle();
                  },
                ),

                // don't have account
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        " Register Now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
