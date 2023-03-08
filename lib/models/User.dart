class User{
  String? uid;
  String? name;
  String? email;
  String? profilePic;

  User ({this.uid, this.name, this.email, this.profilePic});

  User.fromMap(Map<String, dynamic> map){
    uid = map[uid];
    name = map[name];
    email = map[email];
    profilePic = map[profilePic];
  }

  Map<String, dynamic> toMap(){
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "profilePic": profilePic,
    };
  }
}