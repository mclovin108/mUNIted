/*
import 'package:flutter/material.dart';
import 'package:munited/Screens/EditMeeting/edit_meeting_screen.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/constants.dart';
import 'package:munited/Backend/backend.dart';
import 'package:http/http.dart' as http;
import 'package:munited/model/user.dart';
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';

class Detail extends StatefulWidget {
  final Backend backend;
  final http.Client client;
  Meeting meeting;

  Detail(this.backend, this.client, {required this.meeting});

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
    _isCreator = _meeting.creator.id == context.read<UserProvider>().getUserId();
  }

  @override
  Widget build(BuildContext context) {

    int AllVisitors = 0;
    if (_meeting.visitors != null) {
      AllVisitors = _meeting.visitors!.length;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryLightColor),
            alignment: Alignment.topLeft
            ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kPrimaryDarkColor,
        title: const Text(
          'Details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: kPrimaryLightColor,
      ),
      backgroundColor: kPrimaryColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: kPrimaryDarkColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    _meeting.icon,
                                    style: TextStyle(fontSize: 63),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            child: Center(
                              child: Text(
                                _meeting.title,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey[730],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            child: Center(
                              child: Text(
                                _meeting.creator.username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[730],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: kPrimaryLightColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: 160,
                            height: 28,
                            child: Center(
                              child: Text(
                                _meeting.start.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[730],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Beschreibung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[730],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _meeting.description,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[730],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    GridView.count(
                      padding: const EdgeInsets.all(16.0),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 32,
                      childAspectRatio: 1.0 / 0.38,
                      children: <Widget>[
                        if(_meeting.maxVisitors != null) ...[
                          Container(
                          height: 80,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: kPrimaryDarkColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            'Teilnehmer\n'+ AllVisitors.toString() + ' / ' + _meeting.maxVisitors.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[730],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ],
                        if(_meeting.costs != null) ...[
                          Container(
                          height: 80,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: kPrimaryDarkColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            'Kosten\n' + _meeting.costs.toString() + '€',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[730],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ],
                        if(_meeting.labels != null) ...[
                          for(String label in _meeting.labels!) ...[
                            Container(
                              height: 80,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: kPrimaryDarkColor,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[730],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ]
                        ],
                        
                      ]
                    ),
                    SizedBox(height: 16),
                    if (_isCreator) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(Colors.redAccent)
                          ),
                            onPressed: () {
                              // Logik für den "edit" Button
                              _backend.deleteEvent(_client, _meeting.id);
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.delete),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryDarkColor)
                          ),
                            onPressed: () {
                              // Logik für den "löschen" Button
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditMeetingPage(_backend, _client, _meeting)),
                              );
                            },
                            child: Icon(Icons.edit),
                          ),
                      ],)
                    ] else ...[
                      if (!_meeting.visitors!.contains(_backend.getUserById(_client, context.read<UserProvider>().getUserId()!))) ...[
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryDarkColor)
                            ),
                          onPressed: () {
                            // Logik für den "Teilnehmen"-Button
                            addVisitor(_meeting.id);
                          },
                          child: Text(
                            'Teilnehmen',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[730],
                              ),
                              textAlign: TextAlign.center,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Sie nehmen bereits am Event teil.',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[730],
                            ),
                            textAlign: TextAlign.center,
                        )
                      ]
                      
                    ]
                  ]
                ),
              )
            ),
          ],
        ),
      )
    );
  }

  Future<void> addVisitor(int id) async {
    int? userId = context.read<UserProvider>().getUserId();
    if (userId != null) {
      User? visitor = await _backend.getUserById(http.Client(), userId);
      if (visitor != null) {
          _meeting.visitors!.add(visitor);
      try{
        await _backend.updateEvent(
              http.Client(),
              _meeting.id,
              _meeting.title,
              _meeting.icon,
              _meeting.start,
              _meeting.description,
              _meeting.maxVisitors,
              _meeting.costs,
              _meeting.labels,
              _meeting.creator,
              _meeting.visitors
              );
          Navigator.pop(context, true);

          print('Meeting updated successfully');
        } catch (e) {
          print('Failed to update meeting: $e');
        }
      }
      } else {
        print('User is not logged in. Handle this case.');
    }
  }

}
*/