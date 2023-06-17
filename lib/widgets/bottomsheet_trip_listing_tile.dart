import 'package:flutter/material.dart';
import 'package:trip_planner/widgets/alert_dialog_schedule_form.dart';

class BottomSheetTripListingTile extends StatelessWidget {
  final Map trip;
  final String destinationId;
  final String? thumbnail;
  const BottomSheetTripListingTile(
      {Key? key,
      required this.trip,
      required this.destinationId, this.thumbnail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialogScheduleForm(
                trip: trip,
                destinationId: destinationId,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Divider(
            height: 25,
            color: Colors.grey.shade300,
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: thumbnail == null
                  ? Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                      child: const Icon(Icons.airplane_ticket),
                    )
                  : Image.network(
                      thumbnail!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
            ),
            title: Text(trip['name']),
          ),
        ],
      ),
    );
  }
}
