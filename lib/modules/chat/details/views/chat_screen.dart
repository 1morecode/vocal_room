import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocal/modules/chat/database/database.dart';
import 'package:vocal/modules/chat/widget/full_photo.dart';
import 'package:vocal/modules/chat/widget/loading.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ChatScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  String peerId;
  String peerAvatar;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    FirebaseFirestore.instance
        .collection('allUsers')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    var storageTaskSnapshot = await uploadTask.then((res) async {
      res.ref.getDownloadURL();
      imageUrl = await res.ref.getDownloadURL();
      setState(() {
        onSendMessage(imageUrl, 1);

      });
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('messages').doc(groupChatId);

      documentReference.set(<String, dynamic>{
        'lastMessage': <String, dynamic>{
          'idFrom': id,
          'idTo': peerId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'read': false,
          'type': type
        },
        'users': <String>[id, peerId]
      }).then((dynamic success) {
        final DocumentReference messageDoc = FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId)
            .doc(DateTime.now().millisecondsSinceEpoch.toString());

        FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.set(
            messageDoc,
            {
              'idFrom': id,
              'idTo': peerId,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'read': false,
              'type': type
            },
          );
        });
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Nothing to send!");
    }
    isLoading = false;
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (document.data()['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()['type'] == 0
              // Text
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        document.data()['content'],
                        style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(0))),

                    ),
                    new Container(
                      child: new Row(
                        children: [
                          getTime(document.data()['timestamp']),
                          new SizedBox(width: 5,),
                          document.data()['read'] ? new Icon(Icons.check_circle, color: colorScheme.primary, size: 10,) : new Icon(Icons.check_circle_outline, color: colorScheme.secondaryVariant, size: 10,)
                        ],
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                          right: 0.0, top: 5.0),
                    ),

                  ],
                )
              : document.data()['type'] == 1
                  // Image
                  ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: FlatButton(
                  child: Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurface),
                        ),
                        width: 200.0,
                        height: 200.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(0)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          'assets/images/img_not_available.jpeg',
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: document.data()['content'],
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPhoto(
                                url: document.data()['content'])));
                  },
                  padding: EdgeInsets.all(0),
                ),
              ),
              new Container(
                child: new Row(
                  children: [
                    getTime(document.data()['timestamp']),
                    new SizedBox(width: 5,),
                    document.data()['read'] ? new Icon(Icons.check_circle, color: colorScheme.primary, size: 10,) : new Icon(Icons.check_circle_outline, color: colorScheme.secondaryVariant, size: 10,)
                  ],
                ),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                    right: 0.0, top: 5.0),
              ),

            ],
          )
                  // Sticker
                  : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/${document.data()['content']}.gif',
                  width: 100.0,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              new Container(
                child: new Row(
                  children: [
                    getTime(document.data()['timestamp']),
                    new SizedBox(width: 5,),
                    document.data()['read'] ? new Icon(Icons.check_circle, color: colorScheme.primary, size: 10,) : new Icon(Icons.check_circle_outline, color: colorScheme.secondaryVariant, size: 10,)
                  ],
                ),
                margin: EdgeInsets.only(
                    bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                    right: 0.0, top: 5.0),
              ),

            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      Database.updateMessageRead(document, groupChatId);
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document.data()['type'] == 0
                    // Text
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        document.data()['content'],
                        style: TextStyle(
                            color: colorScheme.onSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                    ),
                    new Container(
                      child: getTime(document.data()['timestamp']),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                          right: 0.0, top: 5.0),
                    ),

                  ],
                )
                    : document.data()['type'] == 1
                        // Image
                        ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.onSurface),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                  color: colorScheme.primary
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                            ),
                            errorWidget: (context, url, error) =>
                                Material(
                                  child: Image.asset(
                                    'assets/images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(0),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                            imageUrl: document.data()['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(
                                      url: document.data()['content'])));
                        },
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                    new Container(
                      child: getTime(document.data()['timestamp']),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                          right: 0.0, top: 5.0),
                    ),

                  ],
                )
                        // Sticker
                        : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/${document.data()['content']}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    new Container(
                      child: getTime(document.data()['timestamp']),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                          right: 0.0, top: 5.0),
                    ),

                  ],
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  getTime(time) {
    return Text(
      DateFormat('dd MMM h:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(time)),
      ),
      style: TextStyle(fontSize: 8, color: Theme.of(context).colorScheme.secondaryVariant),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('allUsers')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Column(
        children: <Widget>[
          // List of messages
          buildListMessage(),

          // Sticker
          (isShowSticker ? buildSticker() : Container()),
          new Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10
            ),
            child: isLoading ? _buildUploadingImage() : Container(),
          ),
          // Input content
          buildInput(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  _buildUploadingImage(){
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Material(
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  colorScheme.onSurface),
            ),
            width: 200.0,
            height: 200.0,
            padding: EdgeInsets.all(70.0),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(0)),
            ),
          ),
          errorWidget: (context, url, error) => Material(
            child: Image.asset(
              'assets/images/img_not_available.jpeg',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(0)),
            clipBehavior: Clip.hardEdge,
          ),
          imageUrl: "https://www.splitshire.com/wp-content/uploads/2015/03/SplitShire-8098-1800x1200-uai-258x172.jpg",
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(0)),
        clipBehavior: Clip.hardEdge,
      ),
    );
  }

  Widget buildSticker() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'assets/images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'assets/images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'assets/images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'assets/images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'assets/images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'assets/images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'assets/images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'assets/images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'assets/images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  width: 0.5)),
          color: colorScheme.onPrimary),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildInput() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(minHeight: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Button send image
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 1.0),
          //   child: IconButton(
          //     icon: Icon(Icons.image),
          //     onPressed: getImage,
          //     color: colorScheme.primary,
          //   ),
          // ),
          CupertinoButton(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.face),
            onPressed: getSticker,
          ),
          Expanded(
            child: Scrollbar(
              child: TextField(
                autocorrect: true,
                maxLines: 4,
                minLines: 1,
                showCursor: true,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                cursorColor: colorScheme.onSecondary,
                controller: textEditingController,
                // onSubmitted: (value) {
                //   onSendMessage(textEditingController.text, 0);
                // },
                focusNode: focusNode,
                style: TextStyle(fontSize: 16, color: colorScheme.onSecondary),
                decoration: InputDecoration(
                  isDense: true,
                  // suffixIcon: Icon(Icons.add),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Enter message...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: colorScheme.secondaryVariant,
                  ),
                  labelStyle:
                      TextStyle(fontSize: 16, color: colorScheme.onSecondary),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // Edit text
          // Flexible(
          //   child: Container(
          //     color: colorScheme.onSecondary,
          //     child: TextField(
          //       onSubmitted: (value) {
          //         onSendMessage(textEditingController.text, 0);
          //       },
          //       style: TextStyle(color: colorScheme.primary, fontSize: 15.0),
          //       controller: textEditingController,
          //       decoration: InputDecoration.collapsed(
          //         hintText: 'Type your message...',
          //         hintStyle: TextStyle(color: colorScheme.secondaryVariant),
          //       ),
          //       focusNode: focusNode,
          //     ),
          //   ),
          // ),
          CupertinoButton(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.attach_file_rounded),
            onPressed: getImage,
          ),
          new SizedBox(
            width: 5,
          ),
          // Button send message
          CupertinoButton(
            child: Icon(
              Icons.send,
              color: colorScheme.onSecondary,
            ),
            onPressed: () => onSendMessage(textEditingController.text, 0),
            color: colorScheme.onSurface,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: colorScheme.secondaryVariant.withOpacity(0.5),
                  width: 0.5),
              bottom: BorderSide(
                  color: colorScheme.secondaryVariant.withOpacity(0.3),
                  width: 0.5)),
          color: colorScheme.onPrimary),
    );
  }

  Widget buildListMessage() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.onSurface)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurface)));
                } else {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.docs[index]),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
