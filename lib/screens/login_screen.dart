import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './recipe_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

//This is the first screen that will be shown when the app is launched.
//make sign in page with google_sign_in
//save user data to firestore collection users when sign in
// if sign in success, move to recipe_list_screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //initialize google sign in
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //initialize firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //check if user is signed in or not
  Future<bool> _isSignedIn() async {
    return _googleSignIn.currentUser != null;
  }

  //sign in with google
  Future<void> _handleSignIn() async {
    try {
      //google sign in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      //get google auth
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      //create credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      //sign in with credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      //get user
      final User? user = userCredential.user;
      //check if user is null
      if (user == null) {
        throw Exception('User is null');
      }
      //save user data to firestore
      await saveUserData(user);
      //move to recipe_list_screen
      Navigator.of(context).pushReplacementNamed(RecipeListScreen.routeName);
    } catch (error) {
      print(error);
    }
  }

  //save user data to firestore
  Future<void> saveUserData(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userData = await userRef.get();
    if (!userData.exists) {
      await userRef.set({
        'userId': user.uid,
        'name': user.displayName,
        'email': user.email,
        'photoUrl': user.photoURL,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder<bool>(
        future: _isSignedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bool isSignedIn = snapshot.data!;
            return Center(
              child: isSignedIn
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('You are signed in'),
                        ElevatedButton(
                          onPressed: () => _handleSignIn(),
                          child: const Text('Sign in'),
                        ),
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () => _handleSignIn(),
                      child: const Text('Sign in'),
                    ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
