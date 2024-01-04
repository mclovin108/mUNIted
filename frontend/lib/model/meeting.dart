import 'dart:convert';

import 'package:munited/model/user.dart';

class Meeting {
  int id;
  String title;
  String icon;
  DateTime start;
  String description;
  int? maxVisitors;
  double? costs;
  List<String>? labels;
  User creator;
  List<User>? visitors;

  Meeting({
    required this.id,
    required this.title,
    required this.icon,
    required this.start,
    required this.description,
    this.maxVisitors,
    this.costs,
    this.labels,
    required this.creator,
    this.visitors,
  });

  // parse Meeting from JSON-data
  factory Meeting.fromJson(Map<String, dynamic> json) {
    
    var creatorJson = json["creator"] as Map<String, dynamic>;

    var meeting = Meeting(
      id: json["id"] as int,
      title: json["title"] as String,
      icon: json["icon"] as String,
      start: DateTime.parse(json["start"] as String),
      description: json["description"] as String,
      creator: User.fromJson(json["creator"] as Map<String, dynamic>),
    );
    if (json["maxVisitors"] != null) {
      meeting.maxVisitors = json["maxVisitors"];
    }
    if (json["costs"] != null) {
      meeting.costs = json["costs"];
    }
    if (json["labels"] != null) {
      meeting.labels =
          (json["labels"] as List<dynamic>).map((e) => e.toString()).toList();
    }
    if (json["visitors"] != null) {
      meeting.visitors = (json["visitors"] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return meeting;
  }

  // map meeting to JSON-data
  Map<String, dynamic> toJson() {
    var map = {
      "title": title,
      "icon": icon,
      "start": start.toIso8601String(),
      "description": description,
      "creatorId": creator.id.toString(),
    };
    if (maxVisitors != null) {
      map["maxVisitors"] = maxVisitors.toString();
    }
    if (costs != null) {
      map["costs"] = costs.toString();
    }
    if (labels != null) {
      map["labels"] = jsonEncode(labels);
    }
    return map;
  }
}