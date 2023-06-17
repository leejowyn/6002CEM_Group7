import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/admin_pages/list_detail_page.dart';
import 'add_destination.dart';

class ListDetailArguments {
  final String key;
  final String name;
  final String category;
  final String address;
  final String country;
  final String state;
  final String thumbnail;
  final String contact;
  final String description;
  final String startTime;
  final String endTime;

  ListDetailArguments({
    required this.key,
    required this.name,
    required this.category,
    required this.address,
    required this.country,
    required this.state,
    required this.thumbnail,
    required this.contact,
    required this.description,
    required this.startTime,
    required this.endTime,
  });
}

class ListDestination extends StatefulWidget {
  static String routeName = '/listDestination';

  const ListDestination({Key? key}) : super(key: key);

  @override
  State<ListDestination> createState() => _ListDestinationState();
}

class _ListDestinationState extends State<ListDestination> {
  final dbRef = FirebaseDatabase.instance.ref().child('Destination');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).pushNamed(
              AddDestination.routeName,
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add New"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 35,
            ),
            const Center(
              child: Text(
                "List of Destination",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: FirebaseAnimatedList(
                defaultChild: const Center(child: CircularProgressIndicator()),
                query: dbRef,
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  Map<dynamic, dynamic> data =
                      snapshot.value as Map<dynamic, dynamic>;

                  String imageURL = data['thumbnail'] as String;
                  String name = data['name'] as String;
                  String category = data['category'] as String;
                  String state = data['state'] as String;
                  String country = data['country'] as String;
                  String contact = data['contact'] as String;
                  String description = data['description'] as String;

                  return InkWell(
                    onTap: () {
                      ListDetailArguments args = ListDetailArguments(
                        key: snapshot.key!,
                        name: name,
                        category: category,
                        address: data['address'] as String,
                        country: data['country'] as String,
                        state: data['state'] as String,
                        thumbnail: imageURL,
                        contact: contact,
                        description: description,
                        startTime: data['startTime'] as String,
                        endTime: data['endTime'] as String,
                      );
                      Navigator.of(context).pushNamed(
                        ListDetailPage.routeName,
                        arguments: args,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        blurRadius: 40,
                                        spreadRadius: -25,
                                        offset: Offset(5, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      imageURL,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(name),
                                      Row(
                                        children: [Text(category)],
                                      )
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        size: 20,
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            top: 5,
                                            right: 10,
                                            bottom: 5),
                                        child: Text(state + ", " + country,
                                            style: TextStyle(
                                                color: Colors.grey.shade600)),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 10.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
