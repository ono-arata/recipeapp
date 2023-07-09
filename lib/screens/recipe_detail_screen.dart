import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/firebase_helper.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:flutter_application_1/screens/recipe_add_screen.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String userId;
  final String recipeId;

  RecipeDetailScreen({required this.userId, required this.recipeId});

  Future<Recipe> _fetchRecipe() async {
    final firestoreHelper = FirestoreHelper();
    final snapshot = await firestoreHelper.ShowRecipe(userId, recipeId);
    final recipe = Recipe.fromFirestore(snapshot, null);
    return recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('レシピ詳細'),
        actions: [
          IconButton(
            onPressed: () async {
              Recipe Tappedrecipe = await _fetchRecipe();
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeAddScreen(
                    recipe: Tappedrecipe,
                    userId: userId, //←userIdを追加
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              await FirestoreHelper().DeleteRecipe(
                  userId, recipeId); //←firestore_helperに変更。渡userId,nameを渡すよう変更
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder<Recipe>(
        future: _fetchRecipe(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error occurred: ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            Recipe recipe = snapshot.data;
            // レシピのタイトル、サムネイル画像、材料、作り方、メモを
            // recipe_add_screen.dartと同じようなUIで表示する
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (recipe.thumbnailUrl != '')
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: Image.network(
                        recipe.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '材料',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          recipe.ingredients,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '作り方',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          recipe.instructions,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'メモ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          recipe.memo!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
