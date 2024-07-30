import 'package:flutter/material.dart';
import 'package:pingolearn_task/Constants/constants.dart';
import 'package:pingolearn_task/Providers/auth_provider.dart';
import 'package:pingolearn_task/Providers/comment_provider.dart';
import 'package:pingolearn_task/Providers/remote_config_provider.dart';
import 'package:pingolearn_task/Utils/snackbar.dart';
import 'package:pingolearn_task/Widgets/comment_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CommentProvider>(context, listen: false).fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        title: Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              Provider.of<UserAuthProvider>(context, listen: false).signOut();
              Navigator.of(context).pushReplacementNamed('/login');
              showSuccessSnackBar(context, 'Logged out Successfully');
            },
          ),
        ],
      ),
      body: Consumer<CommentProvider>(
        builder: (context, commentProvider, _) {
          if (commentProvider.error != null) {
            return Center(child: Text('Error: ${commentProvider.error}'));
          }
          if (commentProvider.comments.isEmpty) {
            return Center(child: Text('No comments found.'));
          }
          return Consumer<RemoteConfigProvider>(
            builder: (context, remoteConfigProvider, _) {
              return ListView.builder(
                itemCount: commentProvider.comments.length,
                itemBuilder: (context, index) {
                  final comment = commentProvider.comments[index];
                  final email = remoteConfigProvider.maskEmail
                      ? '${comment.email.substring(0, 3)}****@${comment.email.split('@')[1]}'
                      : comment.email;

                  return CommentCard(comment: comment, email: email);
                },
              );
            },
          );
        },
      ),
    );
  }
}
