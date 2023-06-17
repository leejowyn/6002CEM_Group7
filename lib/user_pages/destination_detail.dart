import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:trip_planner/model/destination_model.dart';
import 'package:trip_planner/model/timezone.dart';
import 'package:trip_planner/model/weather.dart';
import 'package:trip_planner/service/timezone_service.dart';
import 'package:trip_planner/user_pages/trip_form.dart';
import 'package:trip_planner/view_model/category_view_model.dart';
import 'package:trip_planner/view_model/destination_view_model.dart';
import 'package:trip_planner/service/weather_service.dart';
import 'package:trip_planner/view_model/timezone_view_model.dart';
import 'package:trip_planner/view_model/weather_view_model.dart';
import 'package:trip_planner/widgets/alert_dialog_error.dart';
import 'package:trip_planner/widgets/bottomsheet_trip_listing_tile.dart';
import 'package:provider/provider.dart';

class DestinationDetail extends StatefulWidget {
  static String routeName = '/destinationDetail';
  const DestinationDetail({Key? key}) : super(key: key);

  @override
  State<DestinationDetail> createState() => _DestinationDetailState();
}

class _DestinationDetailState extends State<DestinationDetail> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final CategoryViewModel viewModel = CategoryViewModel();

  DestinationModel destination = DestinationModel();

  WeatherService weatherService = WeatherService();
  Weather weather = Weather();

  TimezoneService timezoneService = TimezoneService();
  Timezone timezone = Timezone();


  getDestinationDetail(String destinationId) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('Destination/$destinationId').get();
    return snapshot.value;
  }

  getReviewUser(String userId) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child('User/$userId/name').get();
    return snapshot.value;
  }

  getAverageRating(String destinationId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    final event = await databaseReference
        .child('Destination')
        .child(destinationId)
        .child('review')
        .once();

    double totalRating = 0;
    int reviewCount = 0;

    if (event.snapshot.value != null) {
      Map reviews = event.snapshot.value as Map;

      reviews.forEach((reviewId, reviewData) {
        final rating = double.parse(reviewData['rating']);

        totalRating += rating;
        reviewCount++;
      });
    }

    if (reviewCount > 0) {
      return totalRating / reviewCount;
    } else {
      return 0.0; // No reviews found, return default rating
    }
  }

  @override
  Widget build(BuildContext context) {

    DestinationViewModel destinationViewModel = Provider.of<DestinationViewModel>(context);
    destination = destinationViewModel.destination!;

    WeatherViewModel weatherViewModel = Provider.of<WeatherViewModel>(context);
    weather = weatherViewModel.weather;

    TimezoneViewModel timezoneViewModel = Provider.of<TimezoneViewModel>(context);
    timezone = timezoneViewModel.timezone;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 45,
                            spreadRadius: -10,
                            offset: Offset(5, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Stack(
                          children: [
                            Image.network(
                              destination.thumbnail,
                              height: 600,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              height: 600,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black12, Colors.black]),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Text(
                                  destination.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    size: 18,
                                    color: Colors.grey.shade600
                                  ),
                                  const SizedBox(width: 5),
                                  Text(destination.state +
                                      ", " +
                                      destination.country, style: TextStyle(color: Colors.grey.shade600),),
                                ]
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow.shade600,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 3),
                                  FutureBuilder(
                                      future: getAverageRating(destination.id),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        return Text(snapshot.data.toString());
                                      }),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Transform(
                            transform: new Matrix4.identity()..scale(0.8),
                            child: Chip(
                              avatar: Icon(viewModel.getIconByCategory(destination.category)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              label: Text(destination.category),
                              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.08),
                            ),
                            child: Column(
                              children: [
                              Text(
                                        timezone.timezone,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Theme.of(context).primaryColor,
                                          // fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                Divider(height: 40, indent: 10, endIndent: 10, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 70,
                                      child: Column(
                                          children: [
                                            Image.network(
                                              'https:${weather.iconUrl}',
                                              height: 40,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(weather.condition.toString(), style: TextStyle(color: Theme.of(context).primaryColor)),
                                          ]
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      child: Column(
                                          children: [
                                            Icon(Icons.thermostat, color: Theme.of(context).primaryColor.withOpacity(0.25), size: 40,),
                                            const SizedBox(height: 10),
                                            Text(weather.temperatureC.toString(), style: TextStyle(color: Theme.of(context).primaryColor)),
                                          ]
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      child: Column(
                                          children: [
                                            Icon(Icons.water_drop, color: Theme.of(context).primaryColor.withOpacity(0.25), size: 40,),
                                            const SizedBox(height: 10),
                                            Text(weather.humidity.toString(), style: TextStyle(color: Theme.of(context).primaryColor)),
                                          ]
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Overview",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            destination.description,
                            style: TextStyle(color: Colors.grey.shade600, height: 1.8),
                            textAlign: TextAlign.justify,

                          ),
                          Divider(height: 60, color: Colors.grey.shade300,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_city, color: Colors.grey.shade600),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(child: Text(destination.address, maxLines: 5))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.access_time_filled, color: Colors.grey.shade600),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  '${destination.startTime} - ${destination.endTime}')
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey.shade600),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(destination.contact)
                            ],
                          ),
                          Divider(
                            height: 60,
                            color: Colors.grey.shade300,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Ratings and Reviews",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) => RatingDialog(
                                        starSize: 30,
                                        initialRating: 1.0,
                                        title: const Text(
                                          'Rate your experience',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        submitButtonText: 'Submit',
                                        commentHint: 'Comment ...',
                                        onSubmitted: (response) {
                                          // insert new review to database
                                          DatabaseReference dbRef =
                                              FirebaseDatabase.instance.ref(
                                                  'Destination/${destination.id}/review');

                                          Map<String, String> review = {
                                            'user_id': currentUser.uid,
                                            'rating':
                                                response.rating.toString(),
                                            'comment': response.comment,
                                            'datetime':
                                                DateFormat('dd MMM yyyy kk:mm')
                                                    .format(DateTime.now()),
                                          };

                                          dbRef
                                              .push()
                                              .set(review)
                                              // .then((value) {})
                                              .catchError((error) {
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialogError(
                                                    errDesc: error);
                                              },
                                            );
                                          });
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.rate_review, color: Theme.of(context).primaryColor)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FirebaseAnimatedList(
                              shrinkWrap: true,
                              // query: dbRef,
                              query: FirebaseDatabase.instance
                                  .ref()
                                  .child('Destination/${destination.id}/review')
                                  .orderByChild('datetime'),
                              itemBuilder: (BuildContext context,
                                  DataSnapshot snapshot,
                                  Animation<double> animation,
                                  int index) {
                                Map review = snapshot.value as Map;
                                // review['key'] = snapshot.key;

                                return FutureBuilder<void>(
                                    future: getReviewUser(review['user_id']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<dynamic> snapshot2) {
                                      if (snapshot2.hasData) {
                                        return Column(
                                          children: [
                                            ListTile(
                                              leading: CircleAvatar(
                                                  child: const Icon(Icons.person),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.08)),
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                      snapshot2.data.toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: List.generate(
                                                      5,
                                                          (index) => Icon(
                                                        Icons.star,
                                                        color: index <
                                                            double.parse(review[
                                                            'rating'])
                                                            ? Colors.yellow.shade600
                                                            : Colors.grey.shade400,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0,
                                                            bottom: 13),
                                                    child:
                                                        Text(review['comment']),
                                                  ),
                                                  Text(review['datetime'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade500))
                                                ],
                                              ),
                                              isThreeLine: true,
                                            ),
                                            Divider(
                                              // height: 0,
                                              color: Colors.grey.shade300,
                                            ),
                                          ],
                                        );
                                      } else if (snapshot2.hasError) {
                                        return AlertDialogError(
                                            errDesc:
                                                snapshot2.error.toString());
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    blurRadius: 20.0,
                    offset: Offset(0, -20),
                  ),
                ],
              ),
              child: Container(
                height: 80,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  child: FilledButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            // height: 400,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text(
                                  'Add to trip ...',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Divider(
                                  height: 25,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Column(
                                        children: [
                                          ListTile(
                                              leading: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  color: Colors.grey,
                                                  child: const Icon(Icons.add),
                                                ),
                                              ),
                                              title: const Text('Create new trip'),
                                              onTap: () {
                                                Navigator.of(context).pushNamed(
                                                  TripForm.routeName,
                                                );
                                              }),
                                          FirebaseAnimatedList(
                                              shrinkWrap: true,
                                              query: FirebaseDatabase.instance
                                                  .ref()
                                                  .child('Trip/${currentUser.uid}'),
                                              itemBuilder: (BuildContext
                                                      context,
                                                  DataSnapshot snapshot,
                                                  Animation<double> animation,
                                                  int index) {
                                                Map trip =
                                                    snapshot.value as Map;
                                                trip['key'] = snapshot.key;

                                                // if user scheduled destination to this trip before, get the thumbnail of destination from first key
                                                if (trip.containsKey(
                                                        'destination') &&
                                                    !trip['destination']
                                                        .isEmpty) {
                                                  var destinationIdForThumbnail =
                                                      trip['destination'][trip[
                                                                  'destination']
                                                              .keys
                                                              .first]
                                                          ['destination_id'];

                                                  return FutureBuilder<void>(
                                                      future: getDestinationDetail(
                                                          destinationIdForThumbnail),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<dynamic>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          return BottomSheetTripListingTile(
                                                              trip: trip,
                                                              destinationId:
                                                                destination.id,
                                                              thumbnail: snapshot
                                                                      .data[
                                                                  'thumbnail']);
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return AlertDialogError(
                                                              errDesc: snapshot
                                                                  .error
                                                                  .toString());
                                                        } else {
                                                          return BottomSheetTripListingTile(
                                                              trip: trip,
                                                              destinationId:
                                                                destination.id);
                                                        }
                                                      });
                                                }

                                                return BottomSheetTripListingTile(
                                                    trip: trip,
                                                    destinationId:
                                                      destination.id);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Schedule'),
                  ),
                ),
              ),
            )
    );
  }
}
