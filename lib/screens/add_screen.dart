import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_method.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  void postImage(String uid, String username, String profImage) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
      } else {
        setState(() {
          _isLoading = false;
        });

        showSnackBar(res, context);
        clearImage();
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 15,
            title: Center(
              child: const Text('Create Post',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            children: [
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              SimpleDialogOption(
                child: Center(child: const Text('Photo with Camera')),
                onPressed: () async {
                  Navigator.pop(context, 'Photo with Camera');
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              Divider(
                height: 10,
              ),
              SimpleDialogOption(
                child: Center(child: const Text('Photo from Gallery')),
                onPressed: () async {
                  Navigator.pop(context, 'Photo from Gallery');
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              Divider(
                height: 10,
              ),
              SimpleDialogOption(
                child: Center(child: const Text('Cancel')),
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: PhysicalModel(
              color: Color.fromARGB(255, 142, 142, 142),
              borderRadius: BorderRadius.circular(20),
              elevation: 13,
              shadowColor: Colors.grey,
              child: IconButton(
                iconSize: 40,
                hoverColor: Colors.blue,
                icon: Icon(Icons.upload_rounded),
                onPressed: () => _selectImage(context),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  clearImage();
                },
              ),
              title: const Text('Post to'),
              centerTitle: false, //IOS
              actions: [
                TextButton(
                    onPressed: () =>
                        postImage(user.uid, user.username, user.photoUrl),
                    child: const Text('Post',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16))),
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? LinearProgressIndicator(
                      color: Colors.blue,
                    )
                  : const Padding(padding: EdgeInsets.only(top: 0)),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'What\'s on your mind?',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      )),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
