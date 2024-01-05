import 'package:flutter/material.dart';
import 'package:munited/Screens/EditMeeting/edit_meeting_screen.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  final Backend backend;
  final http.Client client;
  Meeting meeting;

  Detail(this.backend, this.client, this.meeting);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<Detail> {
  late Backend _backend;
  late http.Client _client;
  late Meeting _meeting;
  late bool _isCreator;

  @override
  void initState() {
    super.initState();
    _backend = widget.backend;
    _client = widget.client;
    _meeting = widget.meeting;
    _isCreator =
        _meeting.creator.id == context.read<UserProvider>().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    int AllVisitors = 0;
    if (_meeting.visitors != null) {
      AllVisitors = _meeting.visitors!.length;
    }

    bool isSignedUp = false;
    int id = context.read<UserProvider>().getUserId()!;

    for (User user in _meeting.visitors!) {
      if (user.id == id) isSignedUp = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: kPrimaryLightColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                color: kPrimaryLightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _meeting.title,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: kPrimaryDarkColor,
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: kSecondaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    _meeting.icon,
                                    style: TextStyle(fontSize: 35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ersteller: ${_meeting.creator.username}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryDarkColor,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Teilnehmeranzahl: ' +
                                        (_meeting.maxVisitors != 0
                                            ? '$AllVisitors / ${_meeting.maxVisitors}'
                                            : AllVisitors.toString()),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _meeting.start.day.toString(),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryLightColor,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    DateFormat('MMM').format(_meeting.start),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryLightColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Startzeit: ' +
                            DateFormat('HH:mm').format(_meeting.start) +
                            ' Uhr',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _meeting.costs != null && _meeting.costs != 0
                            ? 'Kosten: ${_meeting.costs} €'
                            : 'Kostenlos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Beschreibung:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _meeting.description,
                        style: TextStyle(
                          fontSize: 24,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      if (_meeting.visitors!.length < _meeting.maxVisitors! ||
                          _meeting.maxVisitors! == 0) ...[
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (!isSignedUp) {
                                  _backend.signUpToEvent(_client, _meeting.id,
                                      context.read<UserProvider>().userId!);
                                  _showAlertDialog("Sie haben sich angemeldet");
                                } else {
                                  _backend.signOffFromEvent(_client, _meeting.id,
                                      context.read<UserProvider>().userId!);
                                  _showAlertDialog("Sie haben sich abgemeldet");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryDarkColor,
                                foregroundColor: kPrimaryLightColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  isSignedUp ? 'Abmelden' : 'Anmelden',
                                ),
                              ),
                            ),
                            if (_isCreator) ...[
                              SizedBox(width: 8), // Add spacing between buttons
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditMeetingPage(_backend, _client, _meeting)),
                              );
                                },
                                icon: Icon(Icons.edit),
                                color:
                                    kPrimaryDarkColor,
                              ),
                              SizedBox(width: 8), // Add spacing between buttons
                              IconButton(
                                onPressed: () {
                                  _backend.deleteEvent(_client, _meeting.id);
                                  _showAlertDialog("Das Event wurde erfolgreich gelöscht");

                                },
                                icon: Icon(Icons.delete),
                                color:
                                    kPrimaryDarkColor,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: kPrimaryColor,
    );
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
