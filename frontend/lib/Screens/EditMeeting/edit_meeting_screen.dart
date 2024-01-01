import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:munited/Backend/backend.dart';
import 'package:munited/constants.dart';
import 'package:munited/model/meeting.dart';
import 'package:munited/model/user.dart';
import 'package:munited/model/user_provider.dart';
import 'package:provider/provider.dart';

class EditMeetingPage extends StatefulWidget {
  final Backend _backend;
  final http.Client _client;
  final Meeting _meeting;

  const EditMeetingPage(this._backend, this._client, this._meeting);

  @override
  State<EditMeetingPage> createState() => _EditMeetingPageState();
}

class _EditMeetingPageState extends State<EditMeetingPage> {
  // necessary for mocking (unit and widget tests)
  late Backend _backend; // library with functions to access backend
  late http.Client _client; // REST client proxy
  late Meeting _meeting;

  @override
  void initState() {
    super.initState();
    _backend = widget._backend;
    _client = widget._client;
    _meeting = widget._meeting;
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
    _titleController.text = _meeting.title;
    _iconController.text = _meeting.icon;
    _startDateTime = _meeting.start;
    _startController.text =
        DateFormat('dd.MM.yy, HH:mm').format(_startDateTime);
    _descriptionController.text = _meeting.description;
    _maxVisitorsController.text = _meeting.maxVisitors.toString();
    _costsController.text = _meeting.costs.toString();
    _labelsController.text = '';
    if (!(_meeting.labels == null || _meeting.labels!.isEmpty)) {
      _labelsController.text = _meeting.labels.toString();
    }
    ;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryDarkColor,
        title: const Text(
          'Meeting bearbeiten',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: 'Righteous',
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        foregroundColor: kPrimaryLightColor,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              TextFormField(
                key: Key("title"),
                keyboardType: TextInputType.text,
                controller: _titleController,
                decoration: InputDecoration(
                    hintText: "Titel",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryLightColor,
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
                key: Key("icon"),
                controller: _iconController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Icon",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                  fillColor: kPrimaryLightColor,
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
                      _startController.text =
                          DateFormat('dd.MM.yy, HH:mm').format(_startDateTime);
                    }
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    key: Key("start"),
                    controller: _startController,
                    decoration: InputDecoration(
                        hintText: "Startzeit",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        fillColor: kPrimaryLightColor,
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
                key: Key("description"),
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                decoration: InputDecoration(
                    hintText: "Beschreibung",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryLightColor,
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
                key: Key("maxVisitors"),
                controller: _maxVisitorsController,
                decoration: InputDecoration(
                    hintText: "Maximale Besucher",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryLightColor,
                    filled: true,
                    prefixIcon: const Icon(Icons.people)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: Key("costs"),
                controller: _costsController,
                decoration: InputDecoration(
                    hintText: "Kosten",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryLightColor,
                    filled: true,
                    prefixIcon: const Icon(Icons.euro)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: Key("labels"),
                controller: _labelsController,
                decoration: InputDecoration(
                    hintText: "Label",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                    fillColor: kPrimaryLightColor,
                    filled: true,
                    prefixIcon: const Icon(Icons.add_circle)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  editMeeting(_meeting.id);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text("Meeting erfolgreich bearbeitet"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                },
                child: Text('Meeting bearbeiten'),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  backgroundColor: kPrimaryDarkColor,
                  foregroundColor: kPrimaryLightColor,
                ),
              ),
            ],
          ),
        ),
      )),
      backgroundColor: kPrimaryColor,
    );
  }

  Future<void> editMeeting(int id) async {
    int? creatorId = context.read<UserProvider>().getUserId();
    // Überprüfen, ob der Benutzer eingeloggt ist
    if (creatorId != null) {
      User? creator = await _backend.getUserById(http.Client(), creatorId);
      if (creator != null) {
        try {
          await _backend.updateEvent(
              http.Client(),
              id,
              _titleController.text,
              _iconController.text,
              DateTime.parse(_startDateTime.toString()),
              _descriptionController.text,
              int.tryParse(_maxVisitorsController.text),
              double.tryParse(_costsController.text),
              _labelsController.text.isNotEmpty
                  ? _labelsController.text.split(',')
                  : null,
              creator,
              _meeting.visitors);
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
