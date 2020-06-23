class User {
  String uid;
  String pseudo;
  String imageUrl;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> musicGenre;

  User(Map<String, dynamic> map){
    uid = map["uid"];
    pseudo = map["pseudo"];
    imageUrl = map["imageUrl"];
    followers = map["followers"];
    following = map["following"];
    musicGenre = map["musicGenre"];
  }
}