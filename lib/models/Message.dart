class Message {
  String? sender;
  String? text;
  DateTime? sentTime;
  bool? seen;

  Message({this.sender, this.text, this.sentTime, this.seen});

  Message.fromMap(Map<String, dynamic> map){
    sender = map[sender];
    text = map[text];
    sentTime = map[sentTime].toDate();
    seen = map[seen];
  }

  Map<String, dynamic> toMap(){
    return {
      "sender": sender,
      "text": text,
      "sentTime": sentTime,
      "seen": seen,
    };
  }
}