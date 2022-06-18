import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'sandwich_info.dart';

class Sandwich extends StatefulWidget {
  const Sandwich({Key? key}) : super(key: key);

  @override
  _SandwichState createState() => _SandwichState();
}

class _SandwichState extends State<Sandwich> {
  String user1 = "";
  final List<GameData1> _games = [];
  final String _baseUrl = "10.0.2.2:3002";

  late Future<bool> fetchedGames;

  void username() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      user1 = prefs.getString("userName")!;
      print("222222222222222");
      print(user1 );
    });
  }


  Future<bool> fetchGames() async {
    http.Response response = await http.get(Uri.http(_baseUrl, "/api/sandwish"));

    List<dynamic> gamesFromServer = json.decode(response.body);
    for (int i = 0; i < gamesFromServer.length; i++) {
      _games.add(GameData1(
          int.parse(gamesFromServer[i]["id"].toString()),
          gamesFromServer[i]["title"],
          double.parse(gamesFromServer[i]["prix"].toString()),
          gamesFromServer[i]["image"],

          gamesFromServer[i]["description"]
      ));
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    fetchedGames = fetchGames();
    username();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.orange),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("G-Ga3four", style:TextStyle(color:Colors.orange),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.orange,
            ),
            onPressed: (){},
          )
        ],

      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text("Welcome Mr."+user1),

              automaticallyImplyLeading: false,
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.shopping_cart),
                  SizedBox(
                    width: 20,
                  ),
                  Text(" My Cart")
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/sandwich");
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.power_settings_new),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Deconnexion")
                ],
              ),
              onTap: () async {
                SharedPreferences preferences =
                await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushNamed(context, "/");
              },
            ),

          ],
        ),
      ),
      body: FutureBuilder(
        future: fetchedGames,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _games.length,
              itemBuilder: (BuildContext context, int index) {
                return  Sandwichinfo(
                    _games[index].id,
                    _games[index].title,
                    _games[index].prix,
                    _games[index].image,
                    _games[index].description

                );
              },

            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },

      ),


    );
  }
}
class GameData1 {
  final int id;
  final String title;
  final double prix;
  final String image;
  final String description;

  GameData1(this.id, this.title, this.prix, this.image, this.description);

  @override
  String toString() {
    return 'GameData1{id: $id, title: $title, prix: $prix, image: $image, description: $description}';
  }
}