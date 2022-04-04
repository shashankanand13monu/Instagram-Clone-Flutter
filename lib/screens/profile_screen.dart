import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/resources/firestore_method.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';

import '../responsive/global_variables.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followerLength = 0;
  int followingLength = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() => isLoading = true);
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //Get Post
      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
          postLength = postsnap.docs.length;
      userData = usersnap.data()!;
      followerLength = userData['followers'].length;
      followingLength = userData['following'].length;
      isFollowing = userData['followers'].contains(
          FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return isLoading? const Center(child: CircularProgressIndicator(),) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: RichText(
                    text: TextSpan(
                      children: [
                        
                        TextSpan(
                            text: userData['username']+ ' ',
                            style:
                                const TextStyle(color: Colors.white ,fontSize: 19,fontWeight: FontWeight.bold)),
                        WidgetSpan(
                            child: const Icon(
                          Icons.verified_rounded,
                          size: 20,
                          color: Colors.blue,
                        )),
                        
                      ],
                    ),
                  ),
        centerTitle: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.3:0,
              vertical: width>webScreenSize? 10:0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData['photoUrl'] ??
                            'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50'),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                buildStatColumn(postLength, 'posts'),
                                buildStatColumn(followerLength, 'followers'),
                                buildStatColumn(followingLength, 'following'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid==widget.uid?
                                FollowButton(
                                  function: () async{
                                    await AuthMethods().signOut();
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
                                  },
                                  backgroundColor: mobileBackgroundColor,
                                  borderColor: Colors.grey,
                                  text: 'Sign Out',
                                  textColor: primaryColor,
                                ): isFollowing? FollowButton(
                                  function: () async{
                                    await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);

                                    setState(() {
                                      isFollowing = false;
                                      followerLength--;
                                    
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  borderColor: Colors.grey,
                                  text: 'Unfollow',
                                  textColor: Colors.black,
                                ): FollowButton(
                                  function: () async{
                                    await FirestoreMethods().followUser(FirebaseAuth.instance.currentUser!.uid, userData['uid']);

                                    setState(() {
                                      isFollowing = true;
                                      followerLength++;
                                    
                                    });
                                  },
                                  backgroundColor: Colors.blue,
                                  borderColor: Colors.blue,
                                  text: 'Follow',
                                  textColor: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      userData['username'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      userData['bio'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('uid',isEqualTo: widget.uid).get(),
          
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return GridView.builder(
                  
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic).docs.length ,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 1.5,
                    childAspectRatio: 1
                  ),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                    return GridTile(
                      child: Image.network(
                        snap['postUrl'],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
              
              );
              }
              ),
                
          
              ), 
          ],
        ),
      ),
    );
  }

  Column buildStatColumn(int n, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          n.toString(),
          style: TextStyle(
              fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ],
    );
  }
}
