import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _authenticate(AuthFormValues formValues, AuthTypes authType) async {
    try {
      setState(() => _isLoading = true);

      if (authType == AuthTypes.Register) {
        // Register logic
        if (formValues.userImage == null)
          throw PlatformException(message: "No Image selected", code: "Oops");

        final authResult = await _auth.createUserWithEmailAndPassword(
          email: formValues.email,
          password: formValues.password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(formValues.userImage).onComplete;

        final imgUrl = await ref.getDownloadURL();

        Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          "username": formValues.username,
          "email": formValues.email,
          "image_url": imgUrl,
        });
      } else {
        // Login logic
        await _auth.signInWithEmailAndPassword(
          email: formValues.email,
          password: formValues.password,
        );
      }
    } on PlatformException catch (e) {
      var message = "An error occured, please check your credentials";

      if (e.message != null) message = e.message;

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.primaryColor,
      body: AuthForm(
        onLogin: (formValues) => _authenticate(formValues, AuthTypes.Login),
        onRegister: (formValues) =>
            _authenticate(formValues, AuthTypes.Register),
        isLoading: _isLoading,
      ),
    );
  }
}
