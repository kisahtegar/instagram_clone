import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:instagram_clone/consts.dart';
import 'package:instagram_clone/features/domain/entities/user/user_entity.dart';
import 'package:instagram_clone/features/domain/use_cases/firebase_usecases/user/upload_image_to_storage_usecase.dart';
import 'package:instagram_clone/features/presentation/cubit/user/user_cubit.dart';
import 'package:instagram_clone/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:instagram_clone/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
  }

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          // ignore: invalid_use_of_visible_for_testing_member
          await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          debugPrint("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      appBar: AppBar(
        backgroundColor: backGroundColor,
        title: const Text("Edit Profile"),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, size: 32),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: _updateUserProfileData,
              child: const Icon(
                Icons.done,
                color: blueColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              // NOTE: Image Profile
              Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: profileWidget(
                      imageUrl: widget.currentUser.profileUrl,
                      image: _image,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              Center(
                child: TextButton(
                  onPressed: selectImage,
                  child: const Text(
                    'Change profile photo',
                    style: TextStyle(
                      color: blueColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              sizeVer(15),
              // NOTE: Name Form
              ProfileFormWidget(
                controller: _nameController,
                title: 'Name',
              ),
              sizeVer(15),
              // NOTE: Username Form
              ProfileFormWidget(
                controller: _usernameController,
                title: 'Username',
              ),
              sizeVer(15),
              // NOTE: Website Form
              ProfileFormWidget(
                controller: _websiteController,
                title: 'Website',
              ),
              sizeVer(15),
              // NOTE: Bio Form
              ProfileFormWidget(
                controller: _bioController,
                title: 'Bio',
              ),
              sizeVer(10),
              _isUpdating == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Please wait...",
                          style: TextStyle(color: Colors.white),
                        ),
                        sizeHor(10),
                        const CircularProgressIndicator(),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // _updateUserProfileData() {
  //   setState(() => _isUpdating = true);

  //   if (_image == null) {
  //     _updateUserProfile("");
  //   } else {
  //     di
  //         .sl<UploadImageToStorageUseCase>()
  //         .call(_image!, false, "profileImages")
  //         .then((profileUrl) {
  //       _updateUserProfile(profileUrl);
  //     });
  //   }
  // }

  _updateUserProfileData() {
    setState(() => _isUpdating = true);
    if (_image == null) {
      _updateUserProfile("");
    } else {
      di
          .sl<UploadImageToStorageUseCase>()
          .call(_image!, false, "profileImages")
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {
    BlocProvider.of<UserCubit>(context)
        .updateUser(
          user: UserEntity(
            uid: widget.currentUser.uid,
            username: _usernameController!.text,
            name: _nameController!.text,
            website: _websiteController!.text,
            bio: _bioController!.text,
            profileUrl: profileUrl,
          ),
        )
        .then((_) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _usernameController!.clear();
      _nameController!.clear();
      _bioController!.clear();
      _websiteController!.clear();
    });
    Navigator.pop(context);
  }
}
