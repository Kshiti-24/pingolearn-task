import 'package:flutter/material.dart';
import 'package:pingolearn_task/Constants/constants.dart';
import 'package:pingolearn_task/Models/comment.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.email,
  });

  final Comment comment;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundColor: AppColors.darkGrey,
              child: Text(
                comment.email.isNotEmpty ? comment.email[0].toUpperCase() : '',
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(comment.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
