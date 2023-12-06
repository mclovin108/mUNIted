import 'package:flutter/material.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user_provider.dart';
import 'package:munited/model/user.dart';
import 'package:munited/Backend/backend.dart';
import 'package:munited/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';



class CreateMeetingPage extends StatefulWidget {

  final Backend _backend;
  final http.Client _client;

  const CreateMeetingPage(this._backend, this._client);

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {

  // necessary for mocking (unit and widget tests)
  late Backend _backend;    // library with functions to access backend
  late http.Client _client; // REST client proxy

  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
  }
  
  final _formKey = GlobalKey<FormState>();

  // Controller für die Formularfelder
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  late DateTime _startDateTime;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxVisitorsController = TextEditingController();
  final TextEditingController _costsController = TextEditingController();
  final TextEditingController _labelsController = TextEditingController();


  void _showEmojiPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            // Emoji dem Textfeld hinzufügen
            _iconController.text = emoji.emoji;
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 15.0),

                    const Text(
                      "Meeting erstellen",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20,),

                  ],
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                              hintText: "Titel",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.mail)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Titel darf nicht leer sein';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _iconController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Icon",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryColor,
                    filled: true,
                    prefixIcon: IconButton(
                      icon: Icon(Icons.emoji_emotions),
                      onPressed: _showEmojiPicker,
                    ),
                  ),
                  onTap: () => _showEmojiPicker(),
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Icon darf nicht leer sein';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (selectedDate != null) {
                      TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        _startDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        _startController.text = _startDateTime.toString();
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _startController,
                      decoration: InputDecoration(
                        hintText: "Startzeit",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: kPrimaryColor,
                        filled: true,
                        prefixIcon: const Icon(Icons.event)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Startzeit darf nicht leer sein';
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Beschreibung",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryColor,
                    filled: true,
                    prefixIcon: const Icon(Icons.event_note)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Beschreibung darf nicht leer sein';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _maxVisitorsController,
                  decoration: InputDecoration(
                              hintText: "Maximale Besucher",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.people)),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _costsController,
                  decoration: InputDecoration(
                              hintText: "Kosten",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.euro)),
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _labelsController,
                  decoration: InputDecoration(
                              hintText: "Labels",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: kPrimaryColor,
                              filled: true,
                              prefixIcon: const Icon(Icons.add_circle)),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Formular ist gültig, Meeting erstellen
                      createMeeting();
                    }
                  },
                  child: Text('Meeting erstellen'),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    backgroundColor: kPrimaryDarkColor,
                  ),
                ),
              ],
            ),
          ),
        )
        
      ),
    );
  }

  Future<void> createMeeting() async {
    int? creatorId = context.watch<UserProvider>().getUserId();
    // Überprüfen, ob der Benutzer eingeloggt ist
    if (creatorId != null) {
      User? creator = await _backend.getUserById(http.Client(), creatorId);
      if (creator != null) {
        try {
          await _backend.createMeeting(http.Client(), _titleController.text, _iconController.text, DateTime.parse(_startController.text), 
          _descriptionController.text, int.tryParse(_maxVisitorsController.text), double.tryParse(_costsController.text),
          _labelsController.text.isNotEmpty
              ? _labelsController.text.split(',')
              : null, 
          creator, []);
          print('Meeting created successfully');

        } catch (e) {
          print('Failed to create meeting: $e');
        }
      }
      
    } else {
      print('User is not logged in. Handle this case.');
    }
  }
}