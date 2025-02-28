import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:provider/provider.dart';

import '../providers/filter_provider.dart';
import '../resources/resources.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PositionFiltred extends StatefulWidget {
  const PositionFiltred({super.key});

  @override
  State<PositionFiltred> createState() => _PositionFiltredState();
}

class _PositionFiltredState extends State<PositionFiltred>
    with BlocProvider<PositionFiltred, PositionFiltredBloc> {
  double valueSlider = 30;
  Position? _currentPosition;
  String _currentCity = '';

  @override
  initBloc() => PositionFiltredBloc();

  @override
  void initState() {
    super.initState();
    final filterProvider = Provider.of<FilterProvider>(context, listen: false);
    valueSlider = filterProvider.radius?.toDouble() ?? 30;
  }

  void _onLocationAdded(double latitude, double longitude, int radius) {
    Navigator.pop(context, {
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
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
    return Container(
      color: Colors.white,
      child: AsyncForm(
          onValidated: bloc.sendPosition,
          onSuccess: () async {
            if (_currentPosition != null) {
              _onLocationAdded(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                valueSlider.toInt(),
              );
            }
          },
          builder: (context, validate) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)!.position_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          AppLocalizations.of(context)!.around_me,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 42),
                        Text(
                          '${valueSlider.toInt()} KM',
                        ),
                        const SizedBox(height: 20),
                        Slider(
                          value: valueSlider,
                          min: 1,
                          max: 100,
                          divisions: 100,
                          label: '${valueSlider.round().toString()} KM',
                          onChanged: (double value) {
                            setState(() {
                              valueSlider = value;
                            });
                          },
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: ResponsiveSize.calculateWidth(319, context),
                          height: 44,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(AppResources.colorVitamine),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await _getCurrentLocation();
                              if (_currentPosition != null) {
                                _onLocationAdded(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                  valueSlider.toInt(),
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.enregister_text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: AppResources.colorWhite),
                            ),
                          ),
                        ),
                        const SizedBox(height: 33),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class PositionFiltredBloc with Disposable {

  Future<bool> sendPosition() async {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
