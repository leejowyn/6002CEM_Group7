import 'dart:io';
import 'package:csc_picker/csc_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/admin_page.dart';
import 'package:trip_planner/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDestination extends StatefulWidget {
  static String routeName = '/addDestination';

  const AddDestination({Key? key}) : super(key: key);

  @override
  State<AddDestination> createState() => _AddDestinationState();
}

class _AddDestinationState extends State<AddDestination> {

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String? urlDownload;

  Future<String?> uploadFile() async {
    if (pickedFile == null) {
      return null;
    }
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      pickedFile = null;
    });
    return urlDownload.toString();
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

  final dbRef = FirebaseDatabase.instance.ref();
  var nameController = TextEditingController();
  var addressController = TextEditingController();
  var contactController = TextEditingController();
  var descriptionController = TextEditingController();
  var startTime = TextEditingController();
  var endTime = TextEditingController();

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Add Your Destination",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              if (pickedFile != null)
                Container(
                  width: 300,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(4, 8),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(pickedFile!.path!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 300,
                  height: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(4, 8),
                        blurRadius: 12,
                      ),
                    ],
                    color: Colors.grey[300],
                  ),
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.grey[500],
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(
                onPressed: selectFile,
                child: const Text('Select Image'),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              //Dropdown Menu for Category
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
              const SizedBox(height: 20),
              // DESTINATION NAME
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Destination Name',
                  hintText: 'Enter Destination Name',
                ),
              ),
              const SizedBox(height: 10),
              // ADDRESS
              TextField(
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
              const SizedBox(height: 10),
              // CONTACT
              TextField(
                controller: contactController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact Number',
                  hintText: 'Enter Contact Number',
                ),
              ),
              // DESCRIPTION
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  hintText: 'Enter a Description',
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pick Opening Hours",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Start Time Picker
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
              const SizedBox(height: 12),
              // End Time Picker
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      addressController.text.isNotEmpty) {
                    insertData(
                      nameController.text.toString(),
                      urlDownload.toString(),
                      selectedCategory.toString(),
                      countryValue.toString(),
                      stateValue.toString(),
                      addressController.text.toString(),
                      contactController.text.toString(),
                      descriptionController.text.toString(),
                      startTime.text.toString(),
                      endTime.text.toString(),
                    );
                    Fluttertoast.showToast(
                      msg: "Added Successful",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.green,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please Fill in the details",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.red,
                    );
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text("Add New Destination",
                    style: TextStyle(fontSize: 16)),
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 48),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white,),
                label: const Text('Go Back', style: TextStyle(fontSize: 16,color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size(double.infinity, 48),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //To insert into realtime database
  void insertData(String name, String thumbnail, String category,
      String country, String state, String address, String contact, String description, String startTime,
      String endTime) async {
    String? thumbnail = await uploadFile();

    if (thumbnail == null) {
      // Handle the case when an image is not selected
      Fluttertoast.showToast(
        msg: "Please select an image",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
      );
      return;
    }

    final ref = dbRef.child("Destination").push();
    await ref.set({
      'name': name,
      'thumbnail': thumbnail,
      'category': category,
      'country': country,
      'state': state,
      'address': address,
      'contact' : contact,
      'description':description,
      'startTime':startTime,
      'endTime':endTime,
    });

    //CLEAR THE FIELD AFTER DONE SUBMIT
    nameController.clear();
    addressController.clear();
    contactController.clear();
    descriptionController.clear();
    pickedFile = null;
  }
}

// Opening Time*
// Contact No*
