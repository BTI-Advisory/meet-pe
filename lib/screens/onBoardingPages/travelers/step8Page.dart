import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_pe/resources/_resources.dart';
import 'package:meet_pe/screens/onBoardingPages/travelers/step9Page.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Step8Page extends StatefulWidget {
  Step8Page({super.key, required this.myMap});

  Map<String, Set<Object>> myMap = {};

  @override
  State<Step8Page> createState() => _Step8PageState();
}

class _Step8PageState extends State<Step8Page> {

  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _showButton = false;
  Position? _currentPosition;
  String _currentCity = '';
  String _currentCountry = '';
  String latitude = '';
  String longitude = '';
  final GlobalKey searchCityKey = GlobalKey();

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
        latitude = "${position.latitude}";
        longitude = "${position.longitude}";
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _currentCity = place.locality ?? "Unknown City";
          _currentCountry = place.country ?? "Unknown Country";
        } else {
          _currentCity = "Unknown City";
          _currentCountry = "Unknown Country";
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _onCitySelected(String? city, String? country) {
    setState(() {
      print("CITY: $city");
      print("COUNTRY: $country");
    });
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
              AppLocalizations.of(context)!.traveler_step_8_title_text,
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
                child: NetworkSearchField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  onCitySelected: _onCitySelected,
                  searchCityKey: searchCityKey,
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
                      if (_currentCity.isNotEmpty && _currentCountry.isNotEmpty) {
                        setState(() {
                          _textEditingController.text = AppLocalizations.of(context)!.around_me;
                        });
                      }
                    },
                    label: Text(
                      AppLocalizations.of(context)!.around_me,
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
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states
                                .contains(MaterialState.disabled)) {
                              return AppResources
                                  .colorGray15; // Change to your desired grey color
                            }
                            return AppResources
                                .colorVitamine; // Your enabled color
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveSize.calculateCornerRadius(40, context)),
                          ),
                        ),
                      ),
                      onPressed: _textEditingController.text.isEmpty
                          ? null
                          : () {
                        setState(() {
                          if (widget.myMap['ville'] == null && widget.myMap['pays'] == null && widget.myMap['lat'] == null && widget.myMap['long'] == null) {
                            widget.myMap['ville'] = Set<String>(); // Initialize if null
                            widget.myMap['pays'] = Set<String>(); // Initialize if null
                            widget.myMap['lat'] = Set<String>(); // Initialize if null
                            widget.myMap['long'] = Set<String>(); // Initialize if null
                          }

                          // Insert _textEditingController.text into myMap with key 'Step8'
                          if (_textEditingController.text.isNotEmpty) {
                            if (_textEditingController.text == 'Autour de moi') {
                              widget.myMap['ville']!.add(_currentCity);
                              widget.myMap['pays']!.add(_currentCountry);
                              widget.myMap['lat']!.add(latitude);
                              widget.myMap['long']!.add(longitude);
                            } else {
                              List<String> parts = _textEditingController.text.split(', ');
                              widget.myMap['ville']!.add(parts[0]);
                              widget.myMap['pays']!.add(parts[1]);
                            }
                          }

                          // Proceed to the next step
                          navigateTo(context, (_) => Step9Page(myMap: widget.myMap));
                        });
                      },
                      child: Image.asset('images/arrowLongRight.png'),
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
