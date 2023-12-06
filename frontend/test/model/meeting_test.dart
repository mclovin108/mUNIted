import 'dart:convert';

import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';
import 'package:test/test.dart';

void main() {
  group('Test serialization of meetings', () {
    test(
      'Test fromJson',
      () {
        String testJson = """
    {
      "id": 1,
      "title": "Party bei Daniel2",
      "icon": "balloon",
      "start": "2007-03-01T13:00:00",
      "description": "Big Boss Party",
      "maxVisitors": 0,
      "costs": 15.0,
      "labels": [
        "U18",
        "U16"
      ],
      "visitors": [{
        "id": 1,
        "username": "Nico",
        "email": "harbig.nico@protonmail.com",
        "password": "1234",
        "createdEvents": [
          1
        ]
      }],
      "creator": {
        "id": 1,
        "username": "Nico",
        "email": "harbig.nico@protonmail.com",
        "password": "1234",
        "createdEvents": [
          1
        ]
      }
    }
    """;
        Meeting meeting = Meeting.fromJson(jsonDecode(testJson));
        expect(meeting.id, 1);
        expect(meeting.title, "Party bei Daniel2");
        expect(meeting.icon, "balloon");
        expect(meeting.start.year, 2007);
        expect(meeting.start.month, 03);
        expect(meeting.start.day, 01);
        expect(meeting.start.hour, 13);
        expect(meeting.start.minute, 0);
        expect(meeting.start.second, 0);
        expect(meeting.description, "Big Boss Party");
        expect(meeting.maxVisitors, 0);
        expect(meeting.costs, 15.0);
        expect(meeting.labels?.length, 2);
        expect(meeting.labels![0], "U18");
        expect(meeting.labels![1], "U16");
        expect(meeting.visitors?.length, 1);
        expect(meeting.visitors![0].id, 1);
        expect(meeting.visitors![0].username, "Nico");
        expect(meeting.visitors![0].email, "harbig.nico@protonmail.com");
        expect(meeting.visitors![0].password, "1234");
        expect(meeting.creator.id, 1);
        expect(meeting.creator.username, "Nico");
        expect(meeting.creator.email, "harbig.nico@protonmail.com");
        expect(meeting.creator.password, "1234");
      },
    );
    test('Test toJson', () {
      Meeting meeting = Meeting(
        id: 1,
        title: "Party bei Daniel2",
        icon: "balloon",
        start: DateTime.utc(2007, 03, 01, 13),
        description: "Big Boss Party",
        creator: User(
          id: 1,
          email: "harbig.nico@protonmail.com",
          username: "Nico",
          password: "1234",
        ),
        costs: 15,
        labels: List.from(["U18", "U16"]),
        visitors: List.from(
          [
            User(
              id: 1,
              email: "harbig.nico@protonmail.com",
              username: "Nico",
              password: "1234",
            ),
          ],
        ),
      );
      Map<String, dynamic> json = meeting.toJson();
      expect(json["title"], "Party bei Daniel2");
      expect(json["icon"], "balloon");
      expect(json["start"], "2007-03-01T13:00:00.000Z");
      expect(json["description"], "Big Boss Party");
      expect(json["costs"], "15.0");
      expect(json["creatorId"], "1");
      expect(json["labels"], "[\"U18\",\"U16\"]");
    });
  });
}
