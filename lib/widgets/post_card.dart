import 'package:flutter/material.dart';
import 'package:instagram_flutter/utils/colors.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage(
                      'https://learnenglish.britishcouncil.org/sites/podcasts/files/2021-10/RS6715_492969113-hig.jpg'),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "  username ",
                            ),
                            WidgetSpan(
                              child: Icon(
                                Icons.verified_rounded,
                                size: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('  caption'),
                    ],
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
                                  onTap: () {
                                    Navigator.pop(context);
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
                'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80',
                fit: BoxFit.cover),
          ),
          //Like and Comment
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    ),
                    Text('0'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.insert_comment),
                      onPressed: () {},
                    ),
                    Text('0'),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ],
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
                Text('1,23 Likes',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 16),
                  child: RichText(
                    text: TextSpan(
                      text: 'username',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                              '  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
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
                    child: Text('View all 466 comments',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('1 day ago',
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
