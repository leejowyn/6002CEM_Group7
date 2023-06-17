import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/user_pages/destination_detail.dart';
import 'package:trip_planner/view_model/category_view_model.dart';
import 'package:trip_planner/view_model/destination_view_model.dart';
import 'package:trip_planner/view_model/timezone_view_model.dart';
import 'package:trip_planner/view_model/weather_view_model.dart';

class DestinationCard extends StatefulWidget {
  final Map destination;
  const DestinationCard({Key? key, required this.destination})
      : super(key: key);

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  final CategoryViewModel viewModel = CategoryViewModel();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DestinationViewModel destinationViewModel = Provider.of<DestinationViewModel>(context, listen: false);
        destinationViewModel.fetchDestination(widget.destination['key']);

        WeatherViewModel weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
        weatherViewModel.fetchWeather('${widget.destination['state']} ${widget.destination['country']}');

        TimezoneViewModel timezoneViewModel = Provider.of<TimezoneViewModel>(context, listen: false);
        timezoneViewModel.fetchTimezone(widget.destination['country']);

        Navigator.of(context).pushNamed(
          DestinationDetail.routeName,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        widget.destination['thumbnail'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            heightFactor: 6,
                            child: Container(
                              child: const CircularProgressIndicator(
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: Text(widget.destination['name'], style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),),
                        Row(
                          children: [
                            Text(widget.destination['avg_rating']),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
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
                          size: 18,
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, top: 5, right: 10, bottom: 5),
                          child: Text(
                              widget.destination['state'] +
                                  ", " +
                                  widget.destination['country'],
                              style: TextStyle(color: Colors.grey.shade600)),
                        )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 22.0, right: 10.0, bottom: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Transform(
                      transform: new Matrix4.identity()..scale(0.8),
                      child: Chip(
                        avatar: Icon(viewModel.getIconByCategory(widget.destination['category'])),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        label: Text(widget.destination['category']),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                        labelStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
