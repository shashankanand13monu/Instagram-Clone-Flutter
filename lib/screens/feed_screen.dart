import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_flutter/responsive/global_variables.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: width>webScreenSize?webBackgroundColor:mobileBackgroundColor,
      appBar: width>webScreenSize? null :AppBar(
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        centerTitle: false,
        backgroundColor:  mobileBackgroundColor,
        actions: [
          Transform.rotate(
            angle: (360 - 35) * 3.14 / 180,
            child: IconButton(
              icon: Icon(Icons.send_rounded),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
        
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasError){
            return Center(
              child: Text('Error'),
            );
          }
         
          return ListView.builder(
            
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(horizontal: width>webScreenSize? width*0.3:0,
              vertical: width>webScreenSize? 10:0),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
            
            itemCount: snapshot.data!.docs.length,);
            
          
        },

        
      ),
    );
  }
}
