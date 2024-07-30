import 'package:flutter/material.dart';
import 'package:pingolearn_task/Constants/constants.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
    required bool isSignIn,
  }) : _isSignIn = isSignIn;

  final bool _isSignIn;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: _isSignIn
                ? 'New user? '
                : 'Already have an account? ',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: _isSignIn ? 'Signup' : 'Login',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: AppColors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }
}
