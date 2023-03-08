class ChatRoom{
  String? chatroomid;
  List<String>? participants;

  ChatRoom({this.chatroomid, this.participants});

  ChatRoom.fromMap(Map<String, dynamic> map){
    chatroomid = map[chatroomid];
    participants = map[participants];
  }

  Map<String, dynamic> toMap(){
    return {
      "chatroomid": chatroomid,
      "participants": participants,
    };
  }
}