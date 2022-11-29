import 'dart:typed_data';
import 'package:boomify_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../models/user_model.dart';

class FireStoreUtils {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Reference storage = FirebaseStorage.instance.ref();

  static Future<User?> getCurrentUser(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await firestore.collection(usersCollection).doc(uid).get();
      if (userDoc.exists) {
        return User.fromJson(userDoc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<User?> updateCurrentUser(User user) async {
    try {
      await firestore
          .collection(usersCollection)
          .doc(user.userID)
          .set(user.toJson())
          .then((document) => user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> uploadImage(String uid, Uint8List imageBytes) async {
    try {
      final UploadTask uploadTask = storage
          .child('images/$uid.png')
          .putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = (await downloadUrl.ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e);
      return '';
    }
  }

  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot<Map<String, dynamic>> userDoc = await firestore
          .collection(usersCollection)
          .doc(userCredential.user!.uid)
          .get();
      User? user;
      if (userDoc.exists) {
        user = User.fromJson(userDoc.data()!);
        return user;
      }
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email.';
      } else if (e.code == 'user-disabled') {
        return 'User disabled.';
      } else if (e.code == 'operation-not-allowed') {
        return 'Operation not allowed.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many requests.';
      } else if (e.code == 'email-already-in-use') {
        return 'Email already in use.';
      } else if (e.code == 'weak-password') {
        return 'Weak password.';
      } else {
        return 'An undefined Error happened.';
      }
    }catch (e) {
      print(e);
      return 'Login failed, Please try again.';
    }
  }
  static Future<String?> createNewUser(User user) async => await firestore
      .collection(usersCollection)
      .doc(user.userID)
      .set(user.toJson())
      .then((value) => null)
      .catchError((error) => error);
  static signUpWithEmailAndPassword({required String emailAddress,
  required String password,
  Uint8List? imageData,
      firstName = 'Anonymous',
      lastName = 'User'}) async {
    try {
       final auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        String? profilePictureURL;
        if (imageData != null) {
          profilePictureURL = await uploadImage(userCredential.user!.uid ?? '', imageData);
        }
        User user = User(
            email: emailAddress,
            firstName: firstName,
            lastName: lastName,
            userID: userCredential.user!.uid ?? '',
            profilePictureURL: profilePictureURL ?? '');
        if (await createNewUser(user) == null) {
          return user;
        } else {
          return 'Failed to create user.';
        }

      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-email') {
          return 'Invalid email.';
        } else if (e.code == 'user-disabled') {
          return 'User disabled.';
        } else if (e.code == 'operation-not-allowed') {
          return 'Operation not allowed.';
        } else if (e.code == 'too-many-requests') {
          return 'Too many requests.';
        } else if (e.code == 'email-already-in-use') {
          return 'Email already in use.';
        } else if (e.code == 'weak-password') {
          return 'Weak password.';
        } else {
          return e.toString();
        }
    }
  }
  static Future<void> signOut() async {
    await auth.FirebaseAuth.instance.signOut();
  }
  static Future<User?> geAuthUser() async {
    final auth.User? user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      return getCurrentUser(user.uid);
    } else {
      return null;
    }
  }
  static resetPassword(String email) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email.';
      } else if (e.code == 'operation-not-allowed') {
        return 'Operation not allowed.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many requests.';
      } else {
        return 'An undefined Error happened.';
      }
    }
  }
}
