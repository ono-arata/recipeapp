import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/firebase_helper.dart';
import 'package:flutter_application_1/models/recipe.dart';

class RecipeAddScreen extends StatefulWidget {
  final Recipe? recipe;
  final String userId;
  const RecipeAddScreen({Key? key, required this.userId, this.recipe})
      : super(key: key);
  @override
  _RecipeAddScreenState createState() => _RecipeAddScreenState();
}

class _RecipeAddScreenState extends State<RecipeAddScreen> {
  late String recipeid;
  late String title;
  late String thumbnailUrl;
  late String ingredients;
  late String instructions;
  late String? memo;
  late Timestamp createdat;
  late File? image;
  void initState() {
    super.initState();
    recipeid = widget.recipe?.recipeid ?? '';
    title = widget.recipe?.title ?? '';
    thumbnailUrl = widget.recipe?.thumbnailUrl ?? '';
    ingredients = widget.recipe?.ingredients ?? '';
    instructions = widget.recipe?.instructions ?? '';
    createdat = widget.recipe?.createdat ?? Timestamp.now();
    memo = widget.recipe?.memo ?? '';
    image = null;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('レシピ追加'),
        actions: [
          RecipeSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 16),
          Text(
            '料理名',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            maxLines: 1,
            initialValue: title,
            decoration: const InputDecoration(hintText: '料理名を入力してください'),
            validator: (title) =>
                title != null && title.isEmpty ? '料理名を入力してください' : null,
            onChanged: (title) => setState(() => this.title = title),
          ),
          //料理の写真が選択されていない場合は、二つのアイコンを表示
          SizedBox(height: 16),
          Text('料理の写真を選択してください',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () async {
                  _pickImageFromGarally();
                },
              ),
              IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () async {
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
          //料理の写真が選択されている場合は、選択された写真のみを表示
          if (image != null)
            Container(
              margin: const EdgeInsets.all(5),
              width: 300,
              height: 200,
              child: FittedBox(
                  fit: BoxFit.fill, child: Image.file(File(image!.path))),
            ),
          SizedBox(height: 16),
          Text(
            '材料',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            maxLines: 1,
            initialValue: ingredients,
            decoration: const InputDecoration(hintText: '材料を入力してください'),
            validator: (ingredients) =>
                ingredients != null && ingredients.isEmpty
                    ? '材料を入力してください'
                    : null,
            onChanged: (ingredients) =>
                setState(() => this.ingredients = ingredients),
          ),
          SizedBox(height: 16),
          Text(
            '作り方',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            maxLines: 6,
            initialValue: instructions,
            decoration: const InputDecoration(hintText: '作り方を入力してください'),
            validator: (instructions) =>
                instructions != null && instructions.isEmpty
                    ? '作り方を入力してください'
                    : null,
            onChanged: (instructions) =>
                setState(() => this.instructions = instructions),
          ),
          SizedBox(height: 16),
          Text(
            'メモ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            maxLines: 20,
            initialValue: memo,
            decoration: const InputDecoration(hintText: '作り方のメモ'),
            onChanged: (memo) => setState(() => this.memo = memo),
          ),
        ]),
      ),
    );
  }

  Widget RecipeSaveButton() {
    // タイトルと作り方が入力されている場合は、保存ボタンの色を変え、有効にする
    final isFormValid = title.isNotEmpty && instructions.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        child: const Text('保存'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor:
              isFormValid ? Colors.redAccent : Colors.grey.shade700,
        ),
        onPressed: isFormValid ? createOrUpdateRecipe : null,
      ),
    );
  }

  void createOrUpdateRecipe() async {
    final isUpdate = (widget.recipe != null);

    if (isUpdate) {
      await updateRecipe();
    } else {
      await createRecipe();
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // 更新処理の呼び出し
  Future updateRecipe() async {
    final recipe = Recipe(
      recipeid: recipeid,
      title: title,
      thumbnailUrl: thumbnailUrl,
      ingredients: ingredients,
      instructions: instructions,
      createdat: createdat,
      memo: memo,
    );
    final firestoreHelper = FirestoreHelper();
    await firestoreHelper.AddRecipe(recipe, widget.userId, image);
  }

  // 追加処理の呼び出し
  Future createRecipe() async {
    final firestoreHelper = FirestoreHelper();
    final recipe = Recipe(
      recipeid: recipeid,
      title: title,
      thumbnailUrl: thumbnailUrl,
      ingredients: ingredients,
      instructions: instructions,
      createdat: createdat,
      memo: memo,
    );
    await firestoreHelper.AddRecipe(recipe, widget.userId, image);
  }

  // 画像を選択し、画像のパスの取得とFirebase Storageへのアップロードを行う
  Future<void> _pickImageFromGarally() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);
    setState(() {
      image = imageFile;
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    final imageFile = File(pickedFile.path);
    setState(() {
      image = imageFile;
    });
  }
}
