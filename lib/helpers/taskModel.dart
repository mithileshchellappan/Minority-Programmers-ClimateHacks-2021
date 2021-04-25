import "package:flutter/material.dart";

class Task {
  String task;
  int taskvalue;
  Color colors;
  Task({this.task, this.taskvalue, this.colors});
}

class DailyCases {
  int date;
  int val;

  DailyCases({this.date, this.val});
}