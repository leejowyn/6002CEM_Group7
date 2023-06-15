import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //final ref = FirebaseDatabase.instance.ref().child('Destination');
  int destCount = 0;
  int scheduleCount = 0;
  int userCount = 0;

  Future<void> getDestinationCount() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Destination');
    databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            destCount = data.length;
          });

          // print('Number of items in Destinations table: $destCount');
        } else {
          // print('Destinations table is empty');
        }
      } else {
        // print('Destinations table does not exist');
      }
    });
  }

  Future<void> getScheduledCount() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Trip').child('cauxsG2L8DSLuhSIMlQcIw2CEYn2');
    databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            scheduleCount = data.length;
          });
          // print('Number of items in Schedule table: $scheduleCount');
        } else {
          // print('Schedule table is empty');
        }
      } else {
        // print('Schedule table does not exist');
      }
    });
  }

  Future<void> getUserCount() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('User');
    databaseReference.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic>? data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          setState(() {
            userCount = data.length;
          });
          // print('Number of Users is: $userCount');
        } else {
          // print('User table is empty');
        }
      } else {
        // print('User table does not exist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Call the destination count function
    getDestinationCount();
    //Call the scheduled count function
    getScheduledCount();
    //Call the user count function
    getUserCount();

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 32,
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Dashboard',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Times New Roman'),
              ),

            ),
            const SizedBox(
              height: 10,
            ),

            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 25, fontFamily: 'Times New Roman'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Divider(
                height: 6,
                thickness: 1.5,
                color: Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 160.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 160,
                              width: 160,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/map.png'),
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Total Destinations',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black54),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Container(
                                        width: 80,
                                        child: Text(
                                          '$destCount',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 160.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 160,
                              width: 160,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/user.png'),
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Text(
                                      'Total Users',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black54),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Container(
                                        width: 80,
                                        child: Text(
                                          '$userCount',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 160.0,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 160,
                              width: 160,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/schedule.png'),
                                ),
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 2, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 170),
                                      child: const Text(
                                        'Scheduled Trips',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black54),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 2),
                                      child: Container(
                                        width: 50,
                                        child: Text(
                                          '$scheduleCount',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 36),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
