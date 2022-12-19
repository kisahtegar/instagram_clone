import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/features/domain/entities/posts/post_entity.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/presentation/cubit/post/post_cubit.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../../consts.dart';
import '../../../../domain/use_cases/firebase_usecases/user/upload_image_to_storage_usecase.dart';
import '../../../widgets/profile_widget.dart';
import '../../profile/widgets/profile_form_widget.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          toast("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? _uploadPostWidget()
        : Scaffold(
            backgroundColor: backGroundColor,
            appBar: AppBar(
              backgroundColor: backGroundColor,
              leading: GestureDetector(
                onTap: () => setState(() => _image = null),
                child: const Icon(Icons.close, size: 28),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: _submitPost,
                    child: const Icon(Icons.arrow_forward),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: profileWidget(
                        imageUrl: "${widget.currentUser.profileUrl}",
                      ),
                    ),
                  ),
                  sizeVer(10),
                  Text(
                    "${widget.currentUser.username}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  sizeVer(10),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: profileWidget(image: _image),
                  ),
                  sizeVer(10),
                  ProfileFormWidget(
                    title: "Description",
                    controller: _descriptionController,
                  ),
                  sizeVer(10),
                  _uploading == true
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Uploading...",
                              style: TextStyle(color: Colors.white),
                            ),
                            sizeHor(10),
                            const CircularProgressIndicator()
                          ],
                        )
                      : const SizedBox(
                          width: 0,
                          height: 0,
                        ),
                ],
              ),
            ),
          );
  }

  _uploadPostWidget() {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Center(
        child: GestureDetector(
          onTap: selectImage,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(.3),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.upload,
                color: primaryColor,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submitPost() {
    if (_uploading == true) {
      return;
    }
    setState(() {
      _uploading = true;
    });
    di.sl<UploadImageToStorageUseCase>().call(_image!, true, "posts").then(
      (imageUrl) {
        _createSubmitPost(image: imageUrl);
      },
    );
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
          post: PostEntity(
            postId: const Uuid().v1(),
            creatorUid: widget.currentUser.uid,
            username: widget.currentUser.username,
            description: _descriptionController.text,
            postImageUrl: image,
            userProfileUrl: widget.currentUser.profileUrl,
            likes: const [],
            totalLikes: 0,
            totalComments: 0,
            createAt: Timestamp.now(),
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _uploading = false;
      _descriptionController.clear();
      _image = null;
    });
  }
}
