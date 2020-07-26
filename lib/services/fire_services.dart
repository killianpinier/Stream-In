import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:streamin/model/post.dart';
import 'package:streamin/model/user.dart';

String meUid;

class FireServices {

  final _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookSignIn = new FacebookLogin();

  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
  );

  Future<FirebaseUser> signIn(String mail, String password) async {
    final FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: mail.trim(), password: password)).user;
    return user;
  }

  Future<FirebaseUser> createAccount(String mail, String password) async {
    final FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: mail.trim(), password: password)).user;
    //Create user to add in db
    String uid = user.uid;
    List<dynamic> followers = [uid];
    List<dynamic> following = [];
    List<dynamic> musicGenre = [];
    Map<String, dynamic> map = {
      "pseudo" : "",
      "description" : "",
      "imageUrl" : "",
      "followers" : followers,
      "following" : following,
      "musicGenre" : musicGenre,
      "totalViews" : 0,
      "uid" : uid,
    };
    addUser(uid, map);
    meUid = uid;
    return user;
  }

  static final dataInstance = Firestore.instance;
  final fireUser = dataInstance.collection("users");

  addUser(String uid, Map<String, dynamic> map) {
    fireUser.document(uid).setData(map);
  }

  addPost(File musicFile, String title, File coverImage, String description, bool isAudio){
    int date = DateTime.now().millisecondsSinceEpoch.toInt();
    List<dynamic> likes = [];
    List<dynamic> comments = [];
    int views = 0;
    Map<String, dynamic> map = {
      "uid" : meUid,
      "likes" : likes,
      "comments" : comments,
      "views" : views,
      "date" : date,
      "description" : description,
      "title" : title,
      "isAudio" : isAudio,
    };
    if(musicFile!=null && coverImage != null){
      StorageReference coverRef = storagePosts.child(meUid).child(date.toString()).child("coverImage");
      StorageReference musicRef = storagePosts.child(meUid).child(date.toString()).child("musicFile");
      addImage(coverImage, coverRef).then((finalized){
        String coverImageUrl = finalized;
        map["coverImageUrl"] = coverImageUrl;
      });
      addVideo(musicFile, musicRef).then((finalized){
        String musicFileUrl = finalized;
        map["musicFileUrl"] = musicFileUrl;
        fireUser.document(meUid).collection("posts").document().setData(map);
      });
    }else{
      StorageReference musicRef = storagePosts.child(meUid).child(date.toString()).child("musicFile");
      addVideo(musicFile, musicRef).then((finalized){
        String musicFileUrl = finalized;
        map["musicFileUrl"] = musicFileUrl;
        fireUser.document(meUid).collection("posts").document().setData(map);
      });
    }
  }

  Future resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  addLike(Post post){
    if(post.likes.contains(meUid)){
      post.ref.updateData({"likes" : FieldValue.arrayRemove([meUid])});
    }else{
      post.ref.updateData({"likes": FieldValue.arrayUnion([meUid])});
    }
  }

  addFollow(User me, User other){
    if(me.following.contains(other.uid)){
      me.ref.updateData({"following": FieldValue.arrayRemove([other.uid])});
      other.ref.updateData({"followers" : FieldValue.arrayRemove([me.uid])});
    }else{
      me.ref.updateData({"following": FieldValue.arrayUnion([other.uid])});
      other.ref.updateData({"followers" : FieldValue.arrayUnion([me.uid])});
    }
  }

  addView(User user, Post post){
    user.ref.updateData({"totalViews" : user.totalViews+1});
    post.ref.updateData({"views" : post.views+1});
  }

  logOut() {
    meUid = null;
    return _firebaseAuth.signOut();
  }

  modifyUser(Map<String, dynamic> data) {
    fireUser.document(meUid).updateData(data);
  }

  modifyPicture(File file){
    StorageReference ref = storageUser.child(meUid);
    addImage(file, ref).then((finalised) {
      Map<String, dynamic> data = {"imageUrl": finalised};
      modifyUser(data);
    });
  }

  // Google
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    final snapShot = await Firestore.instance.collection("users").document(user.uid).get();

    if(snapShot == null || !snapShot.exists){
      String uid = user.uid;
      List<dynamic> followers = [uid];
      List<dynamic> following = [];
      List<dynamic> musicGenre = [];
      Map<String, dynamic> map = {
        "pseudo" : "",
        "imageUrl" : "",
        "description" : "",
        "followers" : followers,
        "following" : following,
        "musicGenre" : musicGenre,
        "totalViews" : 0,
        "uid" : uid,
      };
      addUser(uid, map);
      meUid = uid;
    }
    return 'signInWithGoogle succeeded: $user';
  }

  //facebook
  Future<Null> facebookLogin() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    final token = result.accessToken.token;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final credential = FacebookAuthProvider.getCredential(
            accessToken: token,
        );
        final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        print("Logged in! \n Token: ${accessToken.token} \n uid: ${user.uid} \n User id: ${accessToken.userId}");

        final snapShot = await Firestore.instance.collection("users").document(user.uid).get();

        if(snapShot == null || !snapShot.exists){
          String uid = user.uid;
          List<dynamic> followers = [uid];
          List<dynamic> following = [];
          List<dynamic> musicGenre = [];
          Map<String, dynamic> map = {
            "pseudo" : "",
            "imageUrl" : "",
            "description" : "",
            "followers" : followers,
            "following" : following,
            "musicGenre" : musicGenre,
            "totalViews" : 0,
            "uid" : uid,
          };
          addUser(uid, map);
          meUid = uid;
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  //storage
  static final storageInstance = FirebaseStorage.instance.ref();
  final storageUser = storageInstance.child("users");
  final storagePosts = storageInstance.child("posts");

  Future<String> addVideo(File file, StorageReference reference) async{
    StorageUploadTask task = reference.putFile(file, StorageMetadata(contentType: 'video/mp4'));
    StorageTaskSnapshot snapshot = await task.onComplete;
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }

  Future<String> addImage(File file, StorageReference reference) async{
    StorageUploadTask task = reference.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }
}
