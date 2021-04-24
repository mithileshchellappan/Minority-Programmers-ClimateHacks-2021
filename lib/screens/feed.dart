import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:trashgram/screens/createPost.dart';
import 'package:trashgram/utils/consts.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

bool _showPreview = false;

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CreatePost()));
          },
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.docs.length > 0
                        ? snapshot.data.docs.length
                        : 0,
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 50,
                                  left: 10.0,
                                  right: 10.0,
                                  top: 20.0),
                              child: Container(
                                child: Column(children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        foregroundImage: NetworkImage(firstimg),
                                        radius: 30,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  snapshot.data.docs[index]
                                                      ['name'],
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.more_vert)
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  CarouselSlider(
                                      items: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: AspectRatio(
                                              aspectRatio: 1.0,
                                              child: Image.network(
                                                  snapshot.data.docs[index]
                                                      ['after-pic'],
                                                  fit: BoxFit.cover),
                                            )),
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: AspectRatio(
                                              aspectRatio: 0.6,
                                              child: Image.network(
                                                  snapshot.data.docs[index]
                                                      ['before-pic'],
                                                  fit: BoxFit.cover),
                                            )),
                                      ],
                                      options: CarouselOptions(
                                          autoPlay: false,
                                          height: 400,
                                          enableInfiniteScroll: false)),
                                  SizedBox(height: 10),
                                  Text(''),
                                  Row(children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    Text('110', style: TextStyle(fontSize: 14)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Icon(Icons.chat_bubble_outline),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 200),
                                      child:
                                          Icon(Icons.bookmark_border_outlined),
                                    )
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        height: 2,
                                        child: Container(
                                            color: Colors.blueGrey.shade100)),
                                  ),
                                ]),
                              ),
                            )
                          ],
                        ),
                      ]);
                    });
              }else{
                return Center(child: CircularProgressIndicator(value: 20,),);
              }
            }),
      ),
    );
  }
}
