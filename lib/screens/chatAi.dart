import 'dart:async';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/screens/chatMessage.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatGPT extends StatefulWidget {
  const ChatGPT({super.key});

  @override
  State<ChatGPT> createState() => _ChatGPTState();
}
class _ChatGPTState extends State<ChatGPT> {
  SpeechToText speechToText = SpeechToText();
  var isListening = false;
  final TextEditingController msgController = TextEditingController();
  final List<ChatMessage> msges = [];

  void sendMessage() async{
    ChatMessage message = ChatMessage(text: msgController.text, sender: "You"); 
    msgController.clear();

    setState(() {
      msges.insert(0, message);
    });

    String response = await sendMessageToGPT(message.text);
    ChatMessage gpt = ChatMessage(text: response, sender: "Agent");
    print(response);
    setState(() {
      msges.insert(0, gpt);
    });
  }

  Future<String> sendMessageToGPT(String message) async{
    Uri uri = Uri.parse("https://api.openai.com/v1/chat/completions");

    Map<String, dynamic> body = {
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
        "max_tokens": 500,
    };

    final response = await http.post(
      uri, 
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer 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",
      },
      body: json.encode(body)
    );
    print(response.body);

    Map<String, dynamic> parsedRespose = json.decode(response.body);
    String reply = parsedRespose['choices'][0]['message']['content'];
    return reply;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  Padding(
        padding: const EdgeInsets.only(right: 25.0),
        child: AvatarGlow(
          endRadius: 20, 
          animate: isListening,
          duration: const Duration(milliseconds: 5000),
          glowColor: Colors.black,
          showTwoGlows: true,
          child: GestureDetector(
            onTapDown: (details) async {
              if(!isListening){
                var available = await speechToText.initialize();
                if(available){
                  setState(() {
                    isListening = true;
                    speechToText.listen(
                      onResult: (result) {
                        setState(() {
                          msgController.text = result.recognizedWords;
                        });
                      },
                    );
                  });
                }
              }
            },
            onTapUp: (details) {
              setState(() {
                isListening = false;
              });
              speechToText.stop();
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 14,
              child: const Icon(Icons.mic,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Agent'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Container(
                height: context.screenHeight,
                child: ListView.builder(
                  reverse: true,
                  itemCount: msges.length,
                  itemBuilder:(context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: msges[index]
                    );
                  },
                ),
              )
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      onSubmitted: (value) => sendMessage(),
                      controller: msgController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Send Message",
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed:() {
                    sendMessage();
                  }, 
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}