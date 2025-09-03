import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mgs_app2/services/firebase/firebase_storage.dart';
import 'package:mgs_app2/widgets/button.dart';

import '../models/image_model.dart';

class ParticipantBubbles extends StatefulWidget {
  final List<String> participants;
  final bool showText;
  
  const ParticipantBubbles({super.key, this.participants = const [], this.showText = true});

  @override
  State<ParticipantBubbles> createState() => _ParticipantBubblesState();
}

class _ParticipantBubblesState extends State<ParticipantBubbles> {
  
  late List<Future<ImageModel?>> usersImages;
  
  @override
  void initState() {
    super.initState();
    final FirebaseStorageService storage = FirebaseStorageService();

    usersImages = [];

    for (String uid in widget.participants) {
      usersImages.add(storage.getUserProfileImage(uid));
      
      if (usersImages.length >= 2) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.participants.isEmpty ? SizedBox() : SizedBox(
          height: 25,
          width: min(widget.participants.length, 3) * 25 -
              (min(widget.participants.length - 1, 3)) * 6,
          child: Stack(
            children: getImages(widget.participants),
          ),
        ),
        !widget.showText ? SizedBox() : Padding(
          padding: EdgeInsets.only(
            left: widget.participants.length == 0 ? 0 : 10,
          ),
          child: Text(
            widget.participants.isEmpty
                ? 'Nessun partecipante'
                : '${widget.participants.length} partecipant${widget.participants.length == 1 ? 'e' : 'i'}',
            style: textStyleEventCardSubtitle(context),
          ),
        ),
      ],
    );
  }

  List<Widget> getImages(List<String> uids) {
    final FirebaseStorageService storage = FirebaseStorageService();

    List<Widget> images = [];

    for (int i = 0; i < min(uids.length, 3); i++) {
      String? uid = uids.elementAt(i);

      images.add(
        Positioned(
          left: i * 14,
          child: FutureBuilder(
            future: usersImages.length - 1 < i ? null : usersImages.elementAt(i),
            builder: (BuildContext context, AsyncSnapshot<ImageModel?> snap) {
              if (snap.connectionState != ConnectionState.done ||
                  snap.data == null ||
                  snap.data!.downloadUrl == null) {
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/male.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }

              return Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    snap.data!.downloadUrl!,
                    fit: BoxFit.cover,
                    cacheHeight: 50,
                    cacheWidth: 50,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return images;
  }
}
