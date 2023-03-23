class Message {
  String? messageid;
  String? sender;
  String? text;
  DateTime? sentTime;
  bool? seen;

  Message({this.messageid, this.sender, this.text, this.sentTime, this.seen});

  Message.fromMap(Map<String, dynamic> map){
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    sentTime = map["sentTime"].toDate();
    seen = map["seen"];
  }

  Map<String, dynamic> toMap(){
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "sentTime": sentTime,
      "seen": seen,
    };
  }
}