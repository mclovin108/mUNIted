import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    _backend = widget.backend;
    _client = widget.client;
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
          VerticalCardList(),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 65,
              height: 65,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create');
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail');
          },
          child: VerticalCard(),
        );
      },
    );
  }
}

class VerticalCard extends StatelessWidget {
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
                        '🏀',
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
                      'Title',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryDarkColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Subtitle',
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
                      '14',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: kPrimaryLightColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Mai',
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
