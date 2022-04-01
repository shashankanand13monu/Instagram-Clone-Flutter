import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Upload Post

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occured";
    try {
      String photoUrl =
          await StorageMethods().uploadUserToStorage('posts', file, true);
      String postId = Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    String res = "Some error occured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'text': text,
          'uid': uid,
          'name': name,
          'profilePic': profilePic,
          'datePublished': DateTime.now(),
          'commentId': commentId,
        });
      } else {
        print('Empty Text');
      }
      res = "success";
    } catch (e) {
      res = e.toString();
      print(res);
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
