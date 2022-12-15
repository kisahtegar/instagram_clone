import 'package:flutter/material.dart';
import 'package:instagram_clone/features/domain/entities/comment/comment_entity.dart';
import 'package:instagram_clone/features/presentation/widgets/profile_widget.dart';
import 'package:intl/intl.dart';

import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../../../consts.dart';
import '../../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../widgets/form_container_widget.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    this.onLongPressListener,
    this.onLikeClickListener,
  });

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  bool _isUserReplaying = false;
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
        debugPrint("SingleCommentWidget[initState]: _currentUid($_currentUid)");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                            widget.comment.likes!.contains(_currentUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 20,
                            color: widget.comment.likes!.contains(_currentUid)
                                ? Colors.red
                                : darkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.comment.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.comment.createAt!.toDate()),
                          style: const TextStyle(
                            color: darkGreyColor,
                            fontSize: 12,
                          ),
                        ),
                        sizeHor(15),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isUserReplaying = !_isUserReplaying;
                            });
                          },
                          child: const Text(
                            "Replay",
                            style: TextStyle(
                              color: darkGreyColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        sizeHor(15),
                        const Text(
                          "View Replays",
                          style: TextStyle(
                            color: darkGreyColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    // Replay comment section
                    _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const FormContainerWidget(
                                  hintText: 'Post your replay...'),
                              sizeVer(10),
                              const Text(
                                'Post',
                                style: TextStyle(color: blueColor),
                              ),
                            ],
                          )
                        : const SizedBox(width: 0, height: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
