import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_template_app/model/room/room.dart';
import 'package:firebase_template_app/service/firestore/base/firestore_base.dart';



class RoomRepository extends FirebaseFirestoreBase {
  RoomRepository();



  Query<Room> joindRoomQuery(String uid) => firestore
      .collection('rooms')
      .where('entrant', arrayContains: uid)
      .withConverter<Room>(
        fromFirestore: (snapshot, _) => Room.fromJson(snapshot.data()!),
        toFirestore: (room, _) => room.copyWith().toJson(),
      );

  // Query<Map<String, dynamic>> _fetchFirendRoom(
  //         {required String myUID, required String firendUID}) =>
  //     _firestore.collection('rooms').where('entrant',
  //         whereIn: [myUID]);


  Future<bool> addFriend(
      {required String friendUID, required String myUID}) async {
    final _path = firestore.collection('rooms').doc();

    final _joindRoom = await joindRoomQuery(myUID).get();
    // List<Room>に変換
    final _rooms = _joindRoom.docs.map((e) => e.data()).toList();
    //  List<Room>にfriendがいるか確認
    final _friendCheck = _isFriendIncluded(_rooms, friendUID);

    // なかったら作る
    if (_friendCheck) {
      final room = Room(
        name: 'name',
        entrant: [myUID, friendUID],
      ).toJson()
        ..['createdAT'] = serverTimeStamp;

      await _path.set(room);
      //フレンド登録完了
      return true;
    } else {
      //フレンド登録済み
      return false;
    }
  }

  bool _isFriendIncluded(List<Room> _joindRoom, String friendUID) {
    final _uidList = _joindRoom.map((room) {
      final where = room.entrant.where((uid) => uid != friendUID);
      return where.toList();
    }).toList();

    return _uidList.isEmpty;
  }
}