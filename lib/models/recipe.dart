import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String recipeid;
  String title;
  String thumbnailUrl;
  String ingredients;
  String instructions;
  String? memo;
  Timestamp createdat;

  Recipe({
    required this.recipeid,
    required this.title,
    required this.thumbnailUrl,
    required this.ingredients,
    required this.instructions,
    required this.createdat,
    this.memo,
  });
  factory Recipe.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Recipe(
      recipeid: data?['recipeid'],
      title: data?['title'],
      thumbnailUrl: data?['thumbnailUrl'],
      ingredients: data?['ingredients'],
      instructions: data?['instructions'],
      createdat: data?['createdat'],
      memo: data?['memo'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "recipeid": recipeid,
      "title": title,
      "thumbnailUrl": thumbnailUrl,
      "ingredients": ingredients,
      "instructions": instructions,
      "createdat": createdat,
      "memo": memo,
    };
  }
}
