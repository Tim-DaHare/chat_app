import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthFormValues {
  String username = '';
  String email = '';
  String password = '';
  File userImage;
}

enum AuthTypes {
  Login,
  Register,
}

class AuthForm extends StatefulWidget {
  final void Function(AuthFormValues formValues) onLogin;
  final void Function(AuthFormValues formValues) onRegister;
  final bool isLoading;

  const AuthForm({
    Key key,
    this.onLogin,
    this.onRegister,
    this.isLoading,
  }) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formValues = AuthFormValues();
  var _authType = AuthTypes.Login;

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();
    _authType == AuthTypes.Login
        ? widget.onLogin(_formValues)
        : widget.onRegister(_formValues);
  }

  void _toggleAuthType() {
    setState(() {
      _authType =
          _authType == AuthTypes.Login ? AuthTypes.Register : AuthTypes.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_authType == AuthTypes.Register)
                  UserImagePicker(
                    onImagePicked: (pickedFile) =>
                        _formValues.userImage = pickedFile,
                  ),
                TextFormField(
                  key: ValueKey('email_input'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                  onSaved: (newValue) => _formValues.email = newValue.trim(),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                ),
                if (_authType == AuthTypes.Register)
                  TextFormField(
                    key: ValueKey('username_input'),
                    decoration: InputDecoration(labelText: "Username"),
                    onSaved: (newValue) =>
                        _formValues.username = newValue.trim(),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return "Username must be at least 4 characer long";
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password_input'),
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (newValue) => _formValues.password = newValue.trim(),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return "Password must be at least 7 characer long";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    onPressed: _onSubmit,
                    child: Text(
                      _authType == AuthTypes.Login ? "Login" : "Register",
                    ),
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    onPressed: _toggleAuthType,
                    textColor: theme.primaryColor,
                    child: Text(_authType == AuthTypes.Login
                        ? "Create new account"
                        : "Return to login"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
