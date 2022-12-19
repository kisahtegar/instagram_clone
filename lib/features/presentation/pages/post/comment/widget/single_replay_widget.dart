import 'package:flutter/material.dart';
import 'package:instagram_clone/features/domain/entities/replay/replay_entity.dart';
import 'package:intl/intl.dart';
import 'package:instagram_clone/injection_container.dart' as di;
import '../../../../../../consts.dart';
import '../../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../../widgets/profile_widget.dart';

class SingleReplayWidget extends StatefulWidget {
  final ReplayEntity replay;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplayWidget({
    super.key,
    required this.replay,
    this.onLongPressListener,
    this.onLikeClickListener,
  });

  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
  // final TextEditingController _replayDescriptionController = TextEditingController();
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.replay.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.replay.userProfileUrl),
              ),
            ),
            sizeHor(10),
            // username, description, date, reply
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // username and like button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.replay.username}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onLikeClickListener,
                          child: Icon(
                            widget.replay.likes!.contains(_currentUid)
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            size: 20,
                            color: widget.replay.likes!.contains(_currentUid)
                                ? Colors.red
                                : darkGreyColor,
                          ),
                        ),
                      ],
                    ),
                    sizeVer(4),
                    // description
                    Text(
                      "${widget.replay.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    // Date
                    Text(
                      DateFormat("dd/MMM/yyy")
                          .format(widget.replay.createAt!.toDate()),
                      style: const TextStyle(
                        color: darkGreyColor,
                        fontSize: 12,
                      ),
                    ),
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
