import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              Text(
                sender,
                style: GoogleFonts.montserrat(
                  fontWeight:FontWeight.bold,
                )
              )
            ],
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            )
          )
        ],
      ),
    );
  }
}