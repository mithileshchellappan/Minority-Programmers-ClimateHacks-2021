import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:trashgram/helpers/taskModel.dart';
import 'package:trashgram/utils/consts.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<dynamic> achievements = [
    {"file": "streak.png", "name": "Tidy Streak"},
    {"file": "diamond.png", "name": "Consistent"},
    {"file": "queen.png", "name": "Activist"},
    {"file": "star.png", "name": "Social Butterfly"}
  ];
  List<charts.Series<Task, String>> _seriesPieData =
      List<charts.Series<Task, String>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    buildChart();
  }

  void buildChart() {
    var piedata = [
      new Task(task: "Individual", taskvalue: 40, colors: Colors.greenAccent),
      new Task(task: "Team", taskvalue: 80, colors: Colors.blueAccent.shade100),
    ];
    _seriesPieData.add(charts.Series(
      data: piedata,
      domainFn: (Task task, _) => task.task,
      measureFn: (Task task, _) => task.taskvalue,
      colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colors),
      id: "India",
      labelAccessorFn: (Task row, _) => '${row.taskvalue}',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 260,
              decoration: BoxDecoration(
                  color: Color(0xFFF191720),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  FractionalTranslation(
                    translation: Offset(0, -0.2),
                    child: CircleAvatar(
                      radius: 60,
                      foregroundImage: NetworkImage(leaderList[0]
                          // scale: 10,
                          ),
                    ),
                  ),
                  Text("Bradley Stone",
                      style: TextStyle(color: Colors.white, fontSize: 30)),
                  Text("Los Angeles, USA",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 50,
                    // color: Colors.red,
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("5",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text("Posts",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Container(width: 2, color: Colors.grey),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("120",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text("Eco-Points",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Achievements",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 135,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 5,
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                  "assets/${achievements[index]["file"]}",
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Text("${achievements[index]["name"]}",
                              style: TextStyle(fontSize: 12))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: chart(_seriesPieData),
          )
        ],
      ),
    );
  }

  Widget chart(List<charts.Series<Task, String>> _seriesPieData) {
    return Container(
        padding: EdgeInsets.all(5.0),
        width: 400,
        height: 320,
        child: Padding(
            padding: EdgeInsets.all(1.0),
            child: Container(
                child: Center(
                    child: Column(
              children: <Widget>[
                Text("Trashgram Contributions",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Expanded(
                  child: charts.PieChart(
                    _seriesPieData,
                    animate: true,
                    animationDuration: Duration(milliseconds: 1500),
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 3,
                        cellPadding:
                            new EdgeInsets.only(left: 15.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.black, fontSize: 13),
                      ),
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 45,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.outside,
                          )
                        ]),
                  ),
                ),
              ],
            )))));
  }
}
