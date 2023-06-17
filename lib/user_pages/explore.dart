import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:trip_planner/user_pages/destination_listing.dart';
import 'package:trip_planner/widgets/title.dart';

class Explore extends StatefulWidget {
  static String routeName = '/explore';
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController searchController = TextEditingController();
  String? keyword;
  String? country;
  String countryFilterLabel = "Country";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          const TitleHeading(title: "Explore"),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: 100,
                        child: CSCPicker(
                          showStates: false,
                          showCities: false,
                          flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                          onCountryChanged: (value) {
                            setState(() {
                              country = value;
                              countryFilterLabel = value;
                            });
                          },
                          countryDropdownLabel: countryFilterLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 220,
                      height: 50,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.center,
                        onSubmitted: (String value) {
                          setState(() {
                            keyword = value.toLowerCase();
                          });
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText: 'Search ...',
                          hintStyle:
                              const TextStyle(fontSize: 16, color: Colors.grey,),
                          suffixIcon: IconButton(
                            icon:
                                const Icon(Icons.clear, color: Colors.grey, size: 16,),
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 30.0),
                  child: Row(
                    children: [
                      country != null || (keyword != null && keyword != "")
                          ? Text(
                              "Filters: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            )
                          : const SizedBox(),
                      const SizedBox(width: 5),
                      country != null
                          ? Chip(
                              onDeleted: () {
                                setState(() {
                                  country = null;
                                  countryFilterLabel = "Country";
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              label: Text(countryFilterLabel),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.15),
                              labelStyle: const TextStyle(fontSize: 12),
                            )
                          : const SizedBox(),
                      const SizedBox(width: 10),
                      keyword != null && keyword != ""
                          ? Chip(
                              onDeleted: () {
                                setState(() {
                                  keyword = null;
                                });
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              label: Text(keyword.toString()),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.15),
                              labelStyle: const TextStyle(fontSize: 12),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: DestinationListing(keyword: keyword, country: country),
          ),
        ],
      ),
    );
  }
}
