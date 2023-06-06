import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final emailNode = FocusNode();
  final passwordNode = FocusNode();
  bool passVisibility = false, success = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  Future login({email, password}) async {
    try {
      print(email);
      print(password);
      var response = await http.post(Uri.parse("https://reqres.in/api/login"),
          body: json.encode({"email": email, "password": password}),
          headers: {"content-type": "application/json"});
      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        success = true;
        setState(() {});
      } else {
        print(response.statusCode);
        success = false;
        setState(() {});
      }
    } catch (err) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Login Screen'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                textInputAction: TextInputAction.next,
                inputFormatters: [LengthLimitingTextInputFormatter(25)],
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(passwordNode),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: GoogleFonts.poppins(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the email";
                  } else if (!value.contains("@")) {
                    return "Please enter the valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                obscureText: passVisibility == true ? false : true,
                textInputAction: TextInputAction.done,
                controller: password,
                focusNode: passwordNode,
                inputFormatters: [LengthLimitingTextInputFormatter(15)],
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: GoogleFonts.poppins(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      passVisibility = !passVisibility;
                      setState(() {});
                    },
                    child: Icon(passVisibility == true
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35.0),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    print("Validated");
                    login(email: email.text, password: password.text)
                        .then((value) {
                      if (success == true) {
                        _scaffoldKey.currentState!.showSnackBar(const SnackBar(
                            content: Text("Logged in successfully")));
                      } else {
                        _scaffoldKey.currentState!.showSnackBar(
                            const SnackBar(content: Text("Login failed")));
                      }
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
