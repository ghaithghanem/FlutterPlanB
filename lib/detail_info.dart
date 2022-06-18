import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class ProductDetails extends StatefulWidget {
  const ProductDetails();

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late int _id;
  late String _image;
  late String _title;
  late String _description;
  late double _prix;
  late SharedPreferences prefs;

  final String _baseUrl = "10.0.2.2:3002";
  late Future<bool> fetchedGame;
  late Future<GameData> fetchedSandwich;
/*
  Future<bool> fetchGame() async {
    prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt("id")!;
    _image = prefs.getString("image")!;
    _title = prefs.getString("title")!;
    _description = prefs.getString("description")!;
    _prix = (prefs.getDouble("prix")!);

    return true;
  }
  */
  Future<GameData> fetchSandwich() async {
    prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt("id")!;
    final response =
    await http.get(Uri.http(_baseUrl, "/api/sandwish/" + _id.toString()));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GameData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    //fetchedGame = fetchGame();
    fetchedSandwich = fetchSandwich();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedSandwich,
      builder: (BuildContext context, AsyncSnapshot<GameData> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(snapshot.data!.title, style:TextStyle(color:Colors.orange),),
            ),
            body: Column(
              children: [
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Image.network(
                        "http://10.0.2.2:3002/" + snapshot.data!.image,
                        width: 460,
                        height: 215)),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                  child: Text(snapshot.data!.description),
                ),
                Text(snapshot.data!.prix.toString() + " TND",
                    textScaleFactor: 3),
                const SizedBox(
                  height: 50,
                )
              ],
            ),

            floatingActionButton:  FloatingActionButton.extended(
            onPressed: (){
              //Navigator.pushNamed(context, "/home");
            },
            //label: Text('Approve'),

            label: Text('Add to cart '),
            icon: Icon(Icons.shopping_cart),
            backgroundColor: Colors.deepOrange,
            //const Icon(Icons.shopping_cart),
            //const Text("fddsfsfd"),

          ),
            /*floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.shopping_basket_rounded),
              label: const Text(
                "Acheter",
                textScaleFactor: 1.5,
              ),
              onPressed: () async {
                http
                    .get(Uri.http(_baseUrl, "/api/sandwish/" + _id.toString()))
                    .then((http.Response response) async {
                  Map<String, dynamic> dataFromServer =
                      json.decode(response.body);

                  Map<String, dynamic> game = {
                    "id": _id,
                    "image": _image,
                    "prix": _prix,
                    "title": _title,
                    "description": _description
                  };
                });
              },
            ),*/
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class GameData {
  final int id;
  final String title;
  final double prix;
  final String image;
  final String description;

  GameData(
      {required this.id,
        required this.title,
        required this.prix,
        required this.image,
        required this.description});

  @override
  String toString() {
    return 'GameData{id: $id, image: $image, country: $prix, town: $image, temperature: $description}';
  }

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['id'],
      title: json['title'],
      prix: json['prix'],
      image: json['image'],
      description: json['description'],
    );
  }
}