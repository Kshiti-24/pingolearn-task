import 'package:flutter/material.dart';
import 'package:pingolearn_task/Constants/constants.dart';
import 'package:pingolearn_task/Utils/snackbar.dart';
import 'package:pingolearn_task/Widgets/rich_text.dart';
import 'package:provider/provider.dart';
import 'package:pingolearn_task/Providers/auth_provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _name = '';
  bool _isSignIn = true;
  bool _obscureText = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);

    try {
      if (_isSignIn) {
        await authProvider.signIn(_email, _password);
      } else {
        await authProvider.signUp(_name, _email, _password);
      }

      if (authProvider.error == null) {
        Navigator.of(context).pushReplacementNamed('/home');
        showSuccessSnackBar(context, 'Logged in Successfully');
      } else {
        showErrorSnackBar(context, authProvider.error!);
      }
    } catch (error) {
      showErrorSnackBar(context, 'An unexpected error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
          title: Text("Comments",
              style: TextStyle(
                color: AppColors.lightBlue,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isSignIn)
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _name = value!;
                              },
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: _submit,
                  child: Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.lightBlue),
                    child: Center(
                        child: Text(
                      _isSignIn ? 'Sign In' : 'Sign Up',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isSignIn = !_isSignIn;
                  });
                },
                child: TextWidget(isSignIn: _isSignIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
