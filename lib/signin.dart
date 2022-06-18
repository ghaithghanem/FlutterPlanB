import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late String? _username;
  late String? _password;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "10.0.2.2:3002";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
        key: _keyForm,
        child: ListView(
            children: [

              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Image.asset("assets/images/logo.png", width: 460, height: 215)
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Username"),
                  onSaved: (String? value) {
                    _username = value;
                  },
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return "Le username ne doit pas etre vide";
                    }
                    else {
                      return null;
                    }
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Mot de passe"),
                  onSaved: (String? value) {
                    _password = value;
                  },
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return "Le mot de passe ne doit pas etre vide";
                    }
                    else if(value.length < 4) {
                      return "Le mot de passe doit avoir au moins 5 caractères";
                    }
                    else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(150, 20, 150, 0),
                  child: ElevatedButton(
                    child: const Text("Login"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      foregroundColor: MaterialStateProperty.all(Colors.black45),
                      //padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                      // textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 10))
                    ),
                    onPressed: () {
                      if(_keyForm.currentState!.validate()) {
                        _keyForm.currentState!.save();

                        Map<String, dynamic> userData = {
                          "username": _username,
                          "password" : _password
                        };

                        Map<String, String> headers = {
                          "Content-Type": "application/json; charset=UTF-8"
                        };

                        http.post(Uri.http(_baseUrl, "/api/login"), headers: headers, body: json.encode(userData))
                            .then((http.Response response) async {
                          if(response.statusCode == 200) {
                            Map<String, dynamic> userData = json.decode(response.body);

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("userName", userData["username"]);
                            print("11111111111111111111");
                            print(userData["username"]);



                            Navigator.pushNamed(context, "/sandwich");
                          }
                          else if(response.statusCode == 401) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("Information"),
                                    content: Text("Username et/ou mot de passe incorrect"),
                                  );
                                });
                          }
                          else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("Information"),
                                    content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                                  );
                                });
                          }
                        });
                      }
                    },
                  )
              ),
            ],
        ),
        ),
    );
  }
}
