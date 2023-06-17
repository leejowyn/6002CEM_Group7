import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/trip_itinerary.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

class TripForm extends StatefulWidget {
  static String routeName = '/tripForm';
  const TripForm({Key? key}) : super(key: key);

  @override
  State<TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController nameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController dateRangeController = TextEditingController();
  String startDate = "";
  String endDate = "";
  bool nameValid = true;
  bool dateValid = true;
  String? tripId = "";

  @override
  Widget build(BuildContext context) {
    final Map? trip = ModalRoute.of(context)!.settings.arguments as Map?;

    nameController.text = trip == null ? "" : trip['name'];
    noteController.text = trip == null ? "" : trip['note'];
    startDate = trip == null ? "" : trip['start_date'];
    endDate = trip == null ? "" : trip['end_date'];
    dateRangeController.text = trip == null ? "" : startDate + " - " + endDate;
    tripId = trip == null ? "" : trip['key'];


    return Scaffold(
      appBar: AppBar(
        title: Text(trip == null? "Create a new trip" : "Edit trip"),
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Name',
                errorText: nameValid ? null : "This field is required"
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Note',
              ),
              minLines: 3,
              maxLines: 8,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              readOnly: true,
              controller: dateRangeController,
              onTap: () async {
                var results = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                    firstDate: DateTime.now(),
                  ),
                  dialogSize: const Size(325, 400),
                  borderRadius: BorderRadius.circular(30),
                );

                if (results != null) {
                  startDate = results[0].toString().substring(0, 10);

                  if (results.length == 2) {
                    endDate = results[1].toString().substring(0, 10);
                    dateRangeController.text = '${startDate} - ${endDate}';
                  } else {
                    dateRangeController.text = startDate;
                  }
                }
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Date Range',
                errorText: dateValid ? null : "This field is required",
                suffixIcon: const Icon(Icons.calendar_today),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: FilledButton(
            onPressed: () {
              setState(() {
                nameValid = nameController.text.isEmpty ? false : true;
                dateValid = dateRangeController.text.isEmpty ? false : true;
              });

              if (nameValid && dateValid) {

                DatabaseReference dbRef =
                FirebaseDatabase.instance.ref('Trip/${currentUser.uid}/$tripId');

                Map<String, String> newTrip = {
                  'name': nameController.text,
                  'note': noteController.text,
                  'start_date': startDate,
                  'end_date': endDate,
                };

                if (trip == null) {
                  newTrip['destination'] = '';

                  // insert new trip to database
                  dbRef.push().set(newTrip).then((value) {
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogError(errDesc: error);
                      },
                    );
                  });
                }
                else {
                  // update existing trip
                  dbRef.update(newTrip).then((value) {
                    Navigator.pop(context); // close the form page
                    Navigator.pop(context); // close the old itinerary page
                    Navigator.of(context).pushNamed(
                      TripItinerary.routeName,
                      arguments: tripId,
                    );
                  }).catchError((error) {
                    // show error message
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialogError(errDesc: error.toString());
                      },
                    );
                  });
                }
              }
            },
            child: Text(trip == null ? "Create" : "Save Changes"),
          ),
        ),
      ),
    );
  }
}
