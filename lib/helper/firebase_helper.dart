import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
    final ref = FirebaseStorage.instance
        .ref()
        .child('users/$userId/recipe/$recipeid')
        .child('thumbnailof$recipeid.jpg');
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  AddRecipe(Recipe recipe, String userId) {
    if (recipe.recipeid.isEmpty) {
      final newDoc = db.doc(userId).collection("recipe").doc().id;
      recipe.recipeid = newDoc;
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
    return db.doc(userId).collection("recipe").doc(recipeid).delete();
  }
}
