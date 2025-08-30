
import 'package:flutter/material.dart';

class ParticipantBubbles extends StatelessWidget {
  final List<dynamic> participants;

  const ParticipantBubbles({
    super.key,
    required this.participants,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // 1. Se non ci sono ancora utenti iscritti: un pallino con un'icona del profilo e label '0 partecipanti'
    if (participants.isEmpty) {
      return Row(
        children: [
          Container(
            width: width * 0.08,
            height: width * 0.08,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              borderRadius: const BorderRadius.all(
                Radius.circular(50.0),
              ),
              border: Border.all(
                color: Colors.white,
                width: width * 0.005,
              ),
            ),
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
              size: width * 0.05,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.02),
            child: const Text("0 partecipanti"),
          ),
        ],
      );
    }

    final int displayCount = participants.length > 2 ? 3 : participants.length;

    return SizedBox(
      height: width * 0.08,
      width: width * 0.08 + (displayCount - 1) * (width * 0.06),
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(displayCount, (index) {
          // 3. Se ce ne sono 3 o più: prendo i primi due della lista e poi il pallino grigio
          if (index == 2) {
            return Positioned(
              left: index * (width * 0.06),
              child: Container(
                width: width * 0.08,
                height: width * 0.08,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: width * 0.005,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${participants.length - 2}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.03,
                    ),
                  ),
                ),
              ),
            );
          }

          // 2. Se ce ne sono 2 .... i due pallini senza il terzo
          return Positioned(
            left: index * (width * 0.06),
            child: _PersonBubble(
              width: width,
              // Use different placeholders for visual distinction
              image: index.isEven
                  ? 'assets/images/female.jpg'
                  : 'assets/images/male.jpg',
            ),
          );
        }),
      ),
    );
  }
}

class _PersonBubble extends StatelessWidget {
  const _PersonBubble({
    required this.width,
    required this.image,
  });

  final double width;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.08,
      height: width * 0.08,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(
          color: Colors.white,
          width: width * 0.005,
        ),
      ),
    );
  }
}
