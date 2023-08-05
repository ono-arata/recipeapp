import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/recipe_detail_screen.dart';
import 'package:flutter_application_1/models/recipe.dart';
import 'package:flutter_application_1/helper/firebase_helper.dart';
import 'package:flutter_application_1/screens/recipe_add_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);
  static const routeName = '/list';
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<DocumentSnapshot> RecipeSnapshot = [];
  List<Recipe> RecipeList = [];
  bool _isloading = false;
  String userId = '';

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    setState(() => _isloading = true);
    userId = FirestoreHelper().GetUserId();
    RecipeSnapshot = await FirestoreHelper().GetAllRecipes(userId);
    RecipeList = RecipeSnapshot.map((doc) => Recipe(
          recipeid: doc['recipeid'],
          title: doc['title'],
          thumbnailUrl: doc['thumbnailUrl'],
          ingredients: doc['ingredients'],
          instructions: doc['instructions'],
          createdat: doc['createdat'],
          memo: doc['memo'],
        )).toList();
    setState(() => _isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipe List'),
        ),
        body: _isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: RecipeList.length,
                itemBuilder: (context, index) {
                  final recipe = RecipeList[index];
                  return InkWell(
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 0.5),
                          borderRadius: BorderRadius.circular(3.0)),
                      child: Row(children: [
                        if (recipe.thumbnailUrl != '')
                          Container(
                            margin: const EdgeInsets.all(5),
                            width: 160,
                            height: 120,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.network(recipe.thumbnailUrl)),
                          ),
                        Column(
                          children: [
                            Text(
                              recipe.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              recipe.ingredients,
                              style: TextStyle(fontSize: 24),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ]),
                    ),
                    onTap: () async {
                      String selectedrecipeid = recipe.recipeid;
                      await Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            recipeId: selectedrecipeid,
                            userId: userId,
                          ),
                        ),
                      )
                          .then((value) {
                        loadRecipes();
                      });
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return RecipeAddScreen(
                  userId: userId,
                );
              }),
            ).then((value) {
              loadRecipes();
            });
          },
          child: Icon(Icons.add),
        ));
  }
}
