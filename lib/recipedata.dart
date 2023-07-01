import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/recipeaddpage.dart';

class RecipeData {
  String id;
  String title;
  Image thumbnail;
  String ingrediants;
  String recipe;
  String memo;
  DateTime? createdat;

  RecipeData({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.ingrediants,
    required this.recipe,
    required this.createdat,
    required this.memo,
  });
  factory RecipeData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RecipeData(
      id: data?['id'],
      title: data?['title'],
      thumbnail: data?['thumbnail'],
      ingrediants: data?['ingrediants'],
      recipe: data?['recipe'],
      createdat: data?['createdat'],
      memo: data?['memo'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "title": title,
      "thumnail": thumbnail,
      "ingrediants": ingrediants,
      "recipe": recipe,
      "createdat": createdat,
      "memo": memo,
    };
  }
}
