import 'package:flutter/material.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          // SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap['name'] + ' ',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        WidgetSpan(
                            child: const Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: Colors.green,
                        )),
                        TextSpan(
                          text: ' ' + widget.snap['text'],
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 4.0)),
                  Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()), style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16.0),
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
