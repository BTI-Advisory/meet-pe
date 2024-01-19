import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:http/http.dart' as http;
import 'package:meet_pe/screens/onBoardingPages/voyageur/step9Page.dart';
import 'dart:convert';
import '../../../utils/responsive_size.dart';
import '../../../utils/utils.dart';

class Step8Page extends StatefulWidget {
  Step8Page({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

  @override
  State<Step8Page> createState() => _Step8PageState();
}

class _Step8PageState extends State<Step8Page> {
  late List<Voyage> myList = [
    Voyage(id: 1, title: "Des Guides Professionnels"),
  ];

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _showButton = false;
  Position? _currentPosition;
  String _currentCity = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textEditingController = TextEditingController();
    _textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      //_showButton = _focusNode.hasFocus && _textEditingController.text.isEmpty;
      _showButton = _focusNode.hasFocus;
    });
  }

  void _onTextChanged() {
    setState(() {
      _showButton = _focusNode.hasFocus && _textEditingController.text.isEmpty;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print("Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the city name from the position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _currentCity = placemarks.isNotEmpty
            ? placemarks[0].locality ?? "Unknown City"
            : "Unknown City";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppResources.colorGray5, AppResources.colorWhite],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ResponsiveSize.calculateHeight(158, context)),
            Text(
              'Tu pars où ?',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: AppResources.colorGray100),
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(74, context)),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(23, context)),
                child: SearchTextField(
                  focusNode: _focusNode,
                  controller: _textEditingController,
                ),
              ),
            ),
            SizedBox(height: ResponsiveSize.calculateHeight(45, context)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(23, context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.near_me_sharp, color: Colors.black),
                    onPressed: () async {
                      await _getCurrentLocation();
                      if (_currentCity.isNotEmpty) {
                        setState(() {
                          _textEditingController.text = 'Autour de moi';
                        });
                      }
                    },
                    label: Text(
                      'Autour de moi',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppResources.colorDark),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: ResponsiveSize.calculateHeight(44, context)),
                  child: Container(
                    width: ResponsiveSize.calculateWidth(183, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.calculateHeight(24, context), vertical: ResponsiveSize.calculateHeight(10, context))),
                        backgroundColor: MaterialStateProperty.all(
                            AppResources.colorVitamine),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        //navigateTo(context, (_) => Step9Page(myMap: widget.myMap,));
                        setState(() {
                          if (widget.myMap['Step8'] == null) {
                            widget.myMap['Step8'] = Set<String>(); // Initialize if null
                          }

                          // Insert _textEditingController.text into myMap with key 'Step8'
                          if (_textEditingController.text.isNotEmpty) {
                            // Assuming the value to be inserted is a String
                            if (_textEditingController.text == 'Autour de moi') {
                              widget.myMap['Step8']!.add(_currentCity);
                            } else {
                              widget.myMap['Step8']!.add(_textEditingController.text);
                            }
                          }

                          // Proceed to the next step
                          navigateTo(context, (_) => Step9Page(myMap: widget.myMap));
                        });
                      },
                      child: _textEditingController.text.isEmpty
                          ? Text(
                              'PAS D’IDEE',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorWhite),
                            )
                          : Image.asset('images/arrowLongRight.png'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  SearchTextField({Key? key, required this.focusNode, required this.controller})
      : super(key: key);

  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  List<String> _suggestions = [];

  Future<List<String>> _getSuggestions(String query) async {
    String username = 'meetpe'; // Replace with your Geonames username
    String baseUrl = 'http://api.geonames.org/searchJSON';
    var response =
        await http.get(Uri.parse('$baseUrl?q=$query&username=$username'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> cities = data['geonames'];
      return cities.map((city) => city['name']).toList().cast<String>();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 50,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.controller,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: AppResources.colorDark),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            hintText: 'Toutes les expériences',
            hintStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppResources.colorGray30),
            prefixIcon: Icon(Icons.search, color: AppResources.colorGray75),
            iconColor: AppResources.colorGray75,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color: Colors.white, // You can change the border color here
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(
                color:
                    Colors.white, // Border color when the TextField is focused
              ),
            ),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await _getSuggestions(pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion),
          );
        },
        onSuggestionSelected: (suggestion) {
          setState(() {
            widget.controller.text = suggestion; // Update the text field text
          });
          // Additional actions based on the selected suggestion
        },
      ),
    );
  }
}

class Voyage {
  final int id;
  final String title;

  Voyage({
    required this.id,
    required this.title,
  });
}
