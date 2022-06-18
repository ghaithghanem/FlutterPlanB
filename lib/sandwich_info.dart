import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Sandwichinfo extends StatelessWidget {
  final int _id;
  final String _title;
  final double _prix;
  final String _image;
  final String _description;


  Sandwichinfo(
      this._id, this._title, this._prix, this._image, this._description);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();


          prefs.setInt("id", _id);
          prefs.setString("title", _title);
          prefs.setDouble("prix", _prix);
          prefs.setString("image", _image);
          prefs.setString("description", _description);

          Navigator.pushNamed(context, "/detail_info");
        },
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Image.network("http://10.0.2.2:3002/" + _image,
                  width: 400, height: 400),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title, textScaleFactor: 2,textAlign: TextAlign.center,style:TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text(_prix.toString() + "DT", textScaleFactor: 3,textAlign: TextAlign.center),
              ],
            )
          ],
        ),
      ),
    );
  }
}
