import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';

class AlertDialogScheduleForm extends StatefulWidget {
  final Map trip;
  final String destinationId;
  final String editKey;
  const AlertDialogScheduleForm(
      {Key? key,
      required this.trip,
      required this.destinationId,
      this.editKey = ""})
      : super(key: key);

  @override
  State<AlertDialogScheduleForm> createState() =>
      _AlertDialogScheduleFormState();
}

class _AlertDialogScheduleFormState extends State<AlertDialogScheduleForm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool dateValid = true;
  bool timeValid = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editKey == "" ? 'Schedule': 'Edit Schedule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            readOnly: true,
            controller: dateController,
            onTap: () async {
              var selectedDate = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                    firstDate: DateTime.parse(widget.trip['start_date']),
                    lastDate: widget.trip['end_date'].isNotEmpty
                        ? DateTime.parse(widget.trip['end_date'])
                        : DateTime.parse(widget.trip['start_date'])),
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(30),
              );

              if (selectedDate != null) {
                String date = selectedDate[0].toString().substring(0, 10);
                dateController.text = date;
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Date',
              errorText: dateValid ? null : "This field is required",
              suffixIcon: const Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            readOnly: true,
            controller: timeController,
            onTap: () async {
              var selectedTime = await showTimePicker(
                initialEntryMode: TimePickerEntryMode.inputOnly,
                initialTime: TimeOfDay.now(),
                context: context,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1,
                    ),
                    child: child!,
                  );
                },
              );

              if (selectedTime != null) {
                timeController.text = selectedTime.format(context);
              }
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Time',
              errorText: timeValid ? null : "This field is required",
              suffixIcon: const Icon(Icons.access_time_filled),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              dateValid = dateController.text.isEmpty ? false : true;
              timeValid = timeController.text.isEmpty ? false : true;
            });

            if (dateValid && timeValid) {
              Navigator.pop(context, 'OK'); // close the alert dialog form

              DatabaseReference dbRef = FirebaseDatabase.instance.ref(
                  'Trip/${currentUser.uid}/${widget.trip["key"]}/destination/${widget.editKey}');

              Map<String, String> destination = {
                'destination_id': widget.destinationId,
                'date': dateController.text,
                'time': timeController.text
              };

              if (widget.editKey == "") {
                // insert new destination in trip
                dbRef.push().set(destination).then((value) {
                  Navigator.of(context).pop(); // close the bottom sheet
                }).catchError((error) {
                  // show error message
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogError(errDesc: error.toString());
                    },
                  );
                });
              } else {
                // edit old destination in trip
                dbRef.update(destination).then((value) {
                  // setState(() {});
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
          child: Text(widget.editKey == null ? 'OK' : 'Save'),
        ),
      ],
    );
  }
}
