import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/comment/comment_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/button_container_widget.dart';

import '../../../../../../consts.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentEntity comment;
  const EditCommentMainWidget({super.key, required this.comment});

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;
  bool? _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            ProfileFormWidget(
              controller: _descriptionController,
              title: "description",
            ),
            sizeVer(10),
            ButtonContainerWidget(
              text: "Save Changes",
              color: blueColor,
              onTapListener: _editComment,
            ),
            sizeVer(10),
            _isCommentUpdating == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Updating...",
                        style: TextStyle(color: Colors.white),
                      ),
                      sizeHor(10),
                      const CircularProgressIndicator(),
                    ],
                  )
                : const SizedBox(width: 0, height: 0)
          ],
        ),
      ),
    );
  }

  _editComment() {
    debugPrint("EditCommentMainWidget[_editComment]: Passing here");
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
      comment: CommentEntity(
        postId: widget.comment.postId,
        commentId: widget.comment.commentId,
        description: _descriptionController!.text,
      ),
    )
        .then((value) {
      _isCommentUpdating = false;
      _descriptionController!.clear();
      Navigator.pop(context);
    });
  }
}
