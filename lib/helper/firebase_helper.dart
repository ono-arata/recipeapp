import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore instance = FirebaseFirestore.instance;
  final db = FirebaseFirestore.instance.collection("users");

//get current user id so that we can save user data to firestore
  GetUserId() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    return userId;
  }

  //save image to firebase storage
  Future<String> saveImageToFirebaseStorage(
      File imageFile, String recipeid) async {
    final userId = GetUserId();
    await FirebaseStorage.instance
        .ref()
        .child('users/$userId/recipe/$recipeid')
        .child('thumbnailof${recipeid}.jpg')
        .putFile(imageFile);
    final downloadUrl = await FirebaseStorage.instance
        .ref()
        .child('users/$userId/recipe/$recipeid')
        .child('thumbnailof${recipeid}.jpg')
        .getDownloadURL();
    return downloadUrl;
  }

  AddRecipe(Recipe recipe, String userId, File? imageFile) async {
    if (recipe.recipeid.isEmpty) {
      final newDoc = db.doc(userId).collection("recipe").doc().id;
      recipe.recipeid = newDoc;
    }
    if (imageFile != null) {
      await FirestoreHelper()
          .saveImageToFirebaseStorage(imageFile, recipe.recipeid);
      recipe.thumbnailUrl = await FirebaseStorage.instance
          .ref()
          .child('users/$userId/recipe/${recipe.recipeid}')
          .child('thumbnailof${recipe.recipeid}.jpg')
          .getDownloadURL();
    }
    final RecipeRef =
        db.doc(userId).collection("recipe").doc(recipe.recipeid).withConverter(
              fromFirestore: Recipe.fromFirestore,
              toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
            );
    return RecipeRef.set(recipe);
  }

  GetAllRecipes(String userId) async {
    final snapshot = db.doc(userId).collection("recipe").withConverter(
          fromFirestore: Recipe.fromFirestore,
          toFirestore: (Recipe recipe, _) => recipe.toFirestore(),
        );
    final recipe = await snapshot.get();
    return recipe.docs;
  }

  ShowRecipe(String userId, String recipeid) async {
    final recipeRef = db.doc(userId).collection("recipe").doc(recipeid);
    final recipe = await recipeRef.get();
    return recipe;
  }

  DeleteRecipe(String userId, String recipeid) async {
    //delete image and folder from firebase storage
    final ref = FirebaseStorage.instance
        .ref()
        .child('users/$userId/recipe/$recipeid')
        .child('thumbnailof${recipeid}.jpg');
    await ref.delete();
    return db.doc(userId).collection("recipe").doc(recipeid).delete();
  }
}
