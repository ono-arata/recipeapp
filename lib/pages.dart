import 'package:flutter/material.dart';

Widget widget1() {
  return ListView(
    children: <Widget>[
      Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5),
            borderRadius: BorderRadius.circular(3.0)),
        child: Row(children: [
          Container(
            margin: const EdgeInsets.all(5),
            width: 160,
            height: 120,
            child: FittedBox(
                fit: BoxFit.fill, child: Image.asset('images/tkg.jpg')),
          ),
          const Column(
            children: [
              Text(
                'TKG',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              Text(
                '卵、ごはん、醤油',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ]),
      )
    ],
  );
}

Widget widget2() {
  return Container();
}
