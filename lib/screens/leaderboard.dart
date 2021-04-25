import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:trashgram/utils/consts.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              height: 250,
              color: Color(0xFFF191720),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Global Leaderboard',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TopLeaderBoard(
                            name: 'Anna',
                            img: firstimg,
                            size: 45,
                            color: Color(0xFFFBEDED),
                            points: '130',
                            position: '3'),
                        TopLeaderBoard(
                            name: 'Jason',
                            img: secondimg,
                            size: 53,
                            color: Color(0xFFFFD700),
                            points: '190',
                            position: '1'),
                        TopLeaderBoard(
                            name: 'Gigi',
                            img: thirdimg,
                            size: 47,
                            color: Color(0xFFC0C0C0),
                            points: '160',
                            position: '2'),
                      ],
                    ),
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: (index == 0) ? 70 : 50,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        radius: 35,
                                        foregroundImage:
                                            NetworkImage(leaderList[index]),
                                      ),
                                    ),
                                    Text(index == 0
                                        ? 'You'
                                        : Faker().person.firstName() +
                                            ' ' +
                                            faker.person.lastName()),
                                  ],
                                )),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey),
                                  child: Center(
                                      child: Text(
                                    (index + 4).toString(),
                                    style: TextStyle(color: Colors.black),
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

class TopLeaderBoard extends StatelessWidget {
  const TopLeaderBoard({
    @required this.color,
    @required this.size,
    @required this.img,
    @required this.points,
    @required this.position,
    @required this.name,
    Key key,
  }) : super(key: key);
  final Color color;
  final double size;
  final String img;
  final String points;
  final String position;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          CircleAvatar(
            radius: size,
            foregroundImage: NetworkImage(img, scale: 20),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                  child: Center(child: Text(position)))),
        ]),
        SizedBox(height: 10),
        Text(name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text('$points Eco-Points', style: TextStyle(color: Colors.white))
      ],
    );
  }
}
