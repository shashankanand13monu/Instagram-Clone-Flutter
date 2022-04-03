import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

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
          onFieldSubmitted: (String _ )
          {setState(() => isShowUsers = true);
          },
          
        ),
      ),
      body: isShowUsers? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username', isGreaterThanOrEqualTo: _searchController.text).get() ,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index){
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index].data()['photoUrl']),
                  ) ,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: (snapshot.data! as dynamic).docs[index].data()['username'] + ' ',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        WidgetSpan(
                            child: const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Colors.blue,
                        )),
                        
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text('No data'),
          );
        },
      ) : FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get() ,
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return StaggeredGridView.countBuilder(
            crossAxisCount: 4,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index){
              return Container(
                child: Image.network((snapshot.data! as dynamic).docs[index]['postUrl']
                ),
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );


      })
    );
  }
}