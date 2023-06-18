import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trip_planner/admin_pages/list_destination.dart';
import 'package:http/http.dart' as http;
import 'package:trip_planner/model/timezone.dart';
import 'package:trip_planner/service/timezone_service.dart';

class ListDetailPage extends StatefulWidget {
  static const String routeName = '/listDetailPage';

  const ListDetailPage({super.key});

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  //The time zone api is from https://app.abstractapi.com/api/timezone/tester
  TimezoneService timezoneService = TimezoneService();
  Timezone timezone = Timezone();

  void getTimezone(String country) async {
    timezone = await timezoneService.getTimezoneData(country);
    setState(() {});
  }

  final List<String> categories = [
    'Natural',
    'Cultural',
    'Food and Drink',
    'Shopping',
    'Entertainment',
    'Accommodation',
    'Wellness and Spa'
  ];

  String? selectedCategory = '';

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.isNotEmpty ? categories[0] : null;

    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as ListDetailArguments;
      getTimezone(args.country);
    });
  }

  Future<void> selectTime(
      TimeOfDay initialTime, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: initialTime,
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
      controller.text = selectedTime.format(context);
    }
  }

  void _showEditDialog(BuildContext context, ListDetailArguments args) {
    TextEditingController nameController =
        TextEditingController(text: args.name);
    TextEditingController addressController =
        TextEditingController(text: args.address);
    String? countryValue = "";
    String? stateValue = "";
    String? cityValue = "";
    TextEditingController contactController =
        TextEditingController(text: args.contact);
    TextEditingController descriptionController =
        TextEditingController(text: args.description);
    TextEditingController startTime =
        TextEditingController(text: args.startTime);
    TextEditingController endTime = TextEditingController(text: args.endTime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //resizeToAvoidBottomInset: false, // Prevents resizing when keyboard appears
          title: const Text('Edit Destination'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Select Category:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 18, right: 18),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.6), width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      }
                    },
                    items: categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Pick Location:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                CSCPicker(
                  //Country Picker
                  layout: Layout.vertical,
                  flagState: CountryFlag.DISABLE,
                  showCities: false,
                  onCountryChanged: (country) {
                    setState(() {
                      countryValue = country;
                    });
                  },
                  onStateChanged: (state) {
                    setState(() {
                      stateValue = state;
                    });
                  },
                  onCityChanged: (value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 13,
                ),
                TextFormField(
                  readOnly: true,
                  controller: startTime,
                  onTap: () async {
                    await selectTime(TimeOfDay.now(), startTime);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Start Time',
                    suffixIcon: Icon(Icons.access_time_filled),
                  ),
                ),
                const SizedBox(
                  height: 13,
                ),
                TextFormField(
                  readOnly: true,
                  controller: endTime,
                  onTap: () async {
                    await selectTime(TimeOfDay.now(), endTime);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'End Time',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      updateData(
                        args.key, // Pass the key of the item to update
                        nameController.text,
                        selectedCategory.toString(),
                        addressController.text,
                        countryValue.toString(),
                        stateValue.toString(),
                        args.thumbnail,
                        contactController.text,
                        descriptionController.text,
                        startTime.text,
                        endTime.text,
                      );
                      Fluttertoast.showToast(
                        msg: "Details Updated",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.green,
                      );
                      // Close dialog after clicking save
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

//Function to update data in firebase
  void updateData(
    String key,
    String name,
    String category,
    String address,
    String country,
    String state,
    String thumbnail,
    String contact,
    String description,
    String startTime,
    String endTime,
  ) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('Destination').child(key);
    dbRef.update({
      'name': name,
      'category': category,
      'address': address,
      'country': country,
      'state': state,
      'thumbnail': thumbnail,
      'contact': contact,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
    });
  }

//Function to delete data from firebase
  void deleteData(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete?'),
          content:
              const Text('Are you sure you want to delete this destination?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseReference dbRef = FirebaseDatabase.instance
                    .ref()
                    .child('Destination')
                    .child(key);
                dbRef.remove().then((_) {
                  Fluttertoast.showToast(
                    msg: "Deleted Successful",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.red,
                  );
                  Navigator.of(context).pop();
                });

                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //Get the data from previous page
    final args =
        ModalRoute.of(context)!.settings.arguments as ListDetailArguments;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 100,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.6),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(args.thumbnail),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, -4),
                          blurRadius: 8)
                    ]),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 25, right: 20),
                            child: Text(args.name,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 25, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[200],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                "Category: " + args.category,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            const SizedBox(width: 5),
                            Text(
                              args.country + ", " + args.state,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Divider(
                          height: 6,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Address       : " + args.address,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Hours            : " +
                                        args.startTime +
                                        " - " +
                                        args.endTime,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Contact         : " + args.contact,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Description   : " + args.description,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  //TIME DETAILS
                                  const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Divider(
                                      height: 6,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Time Details',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Current Date Time : " + timezone.timezone,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Time Location : " + timezone.timeLocation,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "GMT : " + timezone.gmt,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 4),
                            ElevatedButton.icon(
                              onPressed: () {
                                _showEditDialog(context, args);
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text('Edit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteData(context, args.key);
                              },
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              label: const Text('Delete',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
