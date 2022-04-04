import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/responsive/global_variables.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUsers = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() => isShowUsers = true);
              },
            ),
          ],
          title: TextFormField(
            controller: _searchController,
            decoration: InputDecoration(
              fillColor: mobileBackgroundColor,
              hintText: 'Search',
              border: InputBorder.none,
            ),
            onFieldSubmitted: (String _) {
              setState(() => isShowUsers = true);
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GestureDetector(
                      child: ListView.builder(
                        
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    uid: (snapshot.data! as dynamic)
                                        .docs[index]
                                        .data()['uid'],
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic)
                                        .docs[index]
                                        .data()['photoUrl']),
                              ),
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: (snapshot.data! as dynamic)
                                                .docs[index]
                                                .data()['username'] +
                                            ' ',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    WidgetSpan(
                                        child: const Icon(
                                      Icons.verified_rounded,
                                      size: 16,
                                      color: Colors.blue,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return Center(
                    child: Text('No data'),
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    
                    crossAxisCount: 4,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Image.network(
                            (snapshot.data! as dynamic).docs[index]['postUrl']),
                      );
                    },
                    staggeredTileBuilder: (index) => width>webScreenSize? StaggeredTile.count((index%7==0)?1:1, (index%7==0) ? 1 : 1):
                        StaggeredTile.count((index%7==0)?2:1, (index%7==0) ? 2 : 1),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  );
                }));
  }
}
