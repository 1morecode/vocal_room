
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vocal/channel/models/room.dart';

class LobbyUtil{
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<Room>> streamRooms() {
    Stream<List<Room>> list;
    try{
       list = _db
          .collection('rooms')
          .snapshots()
          .map((QuerySnapshot list) => list.docs
          .map((DocumentSnapshot snap) => Room.fromJson(snap.data()))
          .toList())
          .handleError((dynamic e) {
        print(e);
      });
    }catch(e){
      print("Exception $e");
    }
    return list;
  }
}