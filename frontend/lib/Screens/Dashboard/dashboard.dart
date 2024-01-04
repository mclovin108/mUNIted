import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munited/Screens/Detail/detailpage.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';

class Dashboard extends StatefulWidget {
  final Backend backend;
  final http.Client client;

  const Dashboard(this.backend, this.client);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Backend _backend;
  late http.Client _client;
  List<Meeting> events = [];

  @override
  void initState() {
    super.initState();
    _backend = widget.backend;
    _client = widget.client;

    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final List<Meeting> fetchedEvents = await _backend.fetchEvents(_client);

      setState(() {
        events = fetchedEvents;
      });
    } catch (e) {
      // Handle the error
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text(
          'mUNIted',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Righteous',
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        foregroundColor: kPrimaryLightColor,
      ),
      body: Stack(
        children: [
          VerticalCardList(events: events, onFetchEvents: _fetchEvents),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 65,
              height: 65,
              child: FloatingActionButton(
                onPressed: () async {
                  var result = await Navigator.pushNamed(context, '/create');
                  if (result != null && result is bool) {
                    await _fetchEvents();
                  }
                },
                backgroundColor: kPrimaryDarkColor,
                elevation: 0,
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: kPrimaryLightColor,
                ),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
    );
  }
}

class VerticalCardList extends StatelessWidget {
  final List<Meeting> events;
  final VoidCallback onFetchEvents;

  VerticalCardList({required this.events, required this.onFetchEvents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return GestureDetector(
onTap: () {
  var result = Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Detail(
        Backend(),
        http.Client(),
        events[index],
      ),
    ),
  ).then((_) {
    onFetchEvents();
  });
},
          child: VerticalCard(event: events[index]),
        );
      },
    );
  }
}

class VerticalCard extends StatelessWidget {
  final Meeting event;

  VerticalCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
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
                        event.icon,
                        style: TextStyle(fontSize: 35),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      event.creator.username,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      event.start.day.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryLightColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat.MMMM().format(event.start),
                      style: TextStyle(
                        fontSize: 16,
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
      ),
    );
  }
}
