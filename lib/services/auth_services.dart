import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

String meUid;

class AuthService {

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
    List<dynamic> followers = [];
    List<dynamic> following = [];
    List<dynamic> musicGenre = [];
    Map<String, dynamic> map = {
      "pseudo" : "",
      "imageUrl" : "",
      "followers" : followers,
      "following" : following,
      "musicGenre" : musicGenre,
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

  Future resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email.trim());
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
      List<dynamic> followers = [];
      List<dynamic> following = [];
      List<dynamic> musicGenre = [];
      Map<String, dynamic> map = {
        "pseudo" : "",
        "imageUrl" : "",
        "followers" : followers,
        "following" : following,
        "musicGenre" : musicGenre,
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
          List<dynamic> followers = [];
          List<dynamic> following = [];
          List<dynamic> musicGenre = [];
          Map<String, dynamic> map = {
            "pseudo" : "",
            "imageUrl" : "",
            "followers" : followers,
            "following" : following,
            "musicGenre" : musicGenre,
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

  Future<String> addImage(File file, StorageReference reference) async{
    StorageUploadTask task = reference.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    String urlString = await snapshot.ref.getDownloadURL();
    return urlString;
  }
}
