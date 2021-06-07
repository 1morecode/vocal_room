import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vocal/modules/chat/model/chet_user.dart';
import 'package:vocal/modules/chat/model/conver.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // static Future<void> addUser(User user) async {
  //   await _db.collection('users').doc(user.uid).set(
  //       {'id': user.uid, 'name': user.displayName, 'email': user.email});
  // }

  static Stream<List<ChatUser>> streamUsers() {
    return _db
        .collection('allUsers')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
        .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()))
        .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  static Stream<List<ChatUser>> getUsersByList(List<String> userIds) {
    final List<Stream<ChatUser>> streams = [];
    for (String id in userIds) {
      streams.add(_db
          .collection('allUsers')
          .doc(id)
          .snapshots()
          .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data())));
    }
    return StreamZip<ChatUser>(streams).asBroadcastStream();
  }

  static Stream<List<Convo>> streamConversations(String uid) {
    return _db
        .collection('messages')
        .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
        .map((DocumentSnapshot doc) => Convo.fromFireStore(doc))
        .toList());
  }

  // static void sendMessage(
  //     String convoID,
  //     String id,
  //     String pid,
  //     String content,
  //     String timestamp,
  //     ) {
  //   final DocumentReference convoDoc =
  //   Firestore.instance.collection('messages').document(convoID);
  //
  //   convoDoc.setData(<String, dynamic>{
  //     'lastMessage': <String, dynamic>{
  //       'idFrom': id,
  //       'idTo': pid,
  //       'timestamp': timestamp,
  //       'content': content,
  //       'read': false
  //     },
  //     'users': <String>[id, pid]
  //   }).then((dynamic success) {
  //     final DocumentReference messageDoc = Firestore.instance
  //         .collection('messages')
  //         .document(convoID)
  //         .collection(convoID)
  //         .document(timestamp);
  //
  //     Firestore.instance.runTransaction((Transaction transaction) async {
  //       await transaction.set(
  //         messageDoc,
  //         <String, dynamic>{
  //           'idFrom': id,
  //           'idTo': pid,
  //           'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
  //           'content': content,
  //           'read': false
  //         },
  //       );
  //     });
  //   });
  // }

  static Future<Map<dynamic, dynamic>> getLastMessage(String convoID) async{
    print("GET LAST Start $convoID");
    DocumentSnapshot documentReference = await _db.collection('messages').doc(
        convoID).get();
    print("GET LAST MESSAGE ${documentReference.data()}");
    // var snap;
    // documentReference.data().then((snapshot) {
    //   // print("GET LAST MESSAGE RR ${snapshot");
    //   print("GET LAST MESSAGE ${documentReference.data()}");
    //   snap = snapshot.data()['lastMessage'];
    //   return snap;
    // });
    return documentReference.data()['lastMessage'];
  }

  static void updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference.update(<String, dynamic>{'read': true});

  }

  static void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
    FirebaseFirestore.instance.collection('messages').doc(convoID);

    documentReference
        .set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'idFrom': doc['idFrom'],
        'idTo': doc['idTo'],
        'timestamp': doc['timestamp'],
        'content': doc['content'],
        'read': doc['read'],
        'type': doc['type']
      },
      'users': <String>[uid, pid]
    })
        .then((dynamic success) {})
        .catchError((dynamic error) {
      print(error);
    });
  }
}
