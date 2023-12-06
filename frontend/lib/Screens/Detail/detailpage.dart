import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../Backend/backend.dart';
import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  final Backend backend;
  final http.Client client;

  const Detail(this.backend, this.client);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<Detail> {
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
                            'Event Title',
                            style: TextStyle(
                              fontSize: 26,
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
                                    '🏀',
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
                                    'Ersteller: John Doe',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryDarkColor,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Kategorie: Sport',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimaryDarkColor,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Teilnehmeranzahl: 18 / 50',
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
                      SizedBox(height: 16),
                      Text(
                        'Ort: Lothstraße 34, 80335 München',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Beschreibung:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Hier steht eine ausführliche Beschreibung des Events. Zum Beispiel Informationen über den Ort, die Zeit und weitere Details.',
                        style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryDarkColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implementiere die Anmeldung
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
                          child: Text('Anmelden'),
                        ),
                      ),
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
}
