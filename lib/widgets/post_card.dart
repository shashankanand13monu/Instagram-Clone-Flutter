import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/firestore_method.dart';
import '../screens/comment_screen.dart';

//post screen
class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int comentLen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    // var = QuerySnapshot type
    try {
      var snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        comentLen = snap.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Icon(
                                    Icons.verified_rounded,
                                    size: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('  caption'),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                                child: ListView(
                              padding: const EdgeInsets.all(
                                20.0,
                              ),
                              shrinkWrap: true,
                              children: [
                                ListTile(
                                  title: Center(child: Text('Report')),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Divider(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Center(child: Text('Delete')),
                                  onTap: () async {
                                    FirestoreMethods()
                                        .deletePost(widget.snap['postId']);
                                    showSnackBar('Post Deleted !', context);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Divider(
                                  height: 10,
                                ),
                                ListTile(
                                  title: Center(
                                    child: Text('Block User',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )));
                  },
                  icon: const Icon(Icons.more_vert_rounded),
                  color: secondaryColor,
                ),
              ],
            ),
          ),
          //Image Header
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user.uid, widget.snap['likes']);
              setState(() {
                isLiked = true;
              });
            },
            child: Stack(
              alignment: Alignment(-0.35, -0.35),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child:
                      Image.network(widget.snap['postUrl'], fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLiked ? 1 : 0,
                  child: LikeAnimation(
                    child: IconButton(
                      // alignment: Alignment.bottomCenter ,
                      onPressed: () async {
                        await FirestoreMethods().likePost(widget.snap['postId'],
                            user.uid, widget.snap['likes']);
                      },
                      icon: Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 150,
                      ),
                    ),
                    isAnimating: isLiked,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    onEnd: () {
                      setState(() {
                        isLiked = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          //Like and Comment
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(widget.snap['postId'],
                          user.uid, widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border_rounded,
                          ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.insert_comment),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        snap: widget.snap,
                      ),
                    ),
                  ),
                ),
                Text('0'),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {},
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                            icon: Icon(Icons.bookmark_sharp),
                            onPressed: () {}))),
              ],
            ),
          ),
          //Description and Comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.snap['likes'].length.toString() + ' likes',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  child: RichText(
                    text: TextSpan(
                      text: widget.snap['username'],
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '  ' + widget.snap['description'].toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => print('Comment'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text('View all ' + comentLen.toString() + ' comments',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
