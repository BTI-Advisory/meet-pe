import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../models/step_list_response.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';

class FiltredWidget extends StatefulWidget {
  const FiltredWidget({super.key});

  @override
  State<FiltredWidget> createState() => _FiltredWidgetState();
}

class _FiltredWidgetState extends State<FiltredWidget>
    with BlocProvider<FiltredWidget, FiltredWidgetBloc> {
  int _counter = 3;
  int _counterChild = 0;
  int _counterBaby = 0;

  double _minPrice = 15;
  double _maxPrice = 2000;
  double _currentMin = 300;
  double _currentMax = 1500;

  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  late Future<List<StepListResponse>> _choicesFuture;
  late Future<List<StepListResponse>> _choicesLanguageFuture;
  late List<Voyages> myCategory = [];
  late List<Voyages> myLanguage = [];
  Map<String, Set<Object>> myMap = {};
  bool openFilter = false;

  bool _showButton = false;

  @override
  initBloc() => FiltredWidgetBloc();

  void _onFilterAdded() {
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('voyageur_experiences');
    _choicesLanguageFuture = AppService.api.fetchChoices('languages_fr');
    _loadChoices();
    _loadChoicesLanguage();
    _minController.text = _currentMin.toStringAsFixed(0);
    _maxController.text = _currentMax.toStringAsFixed(0);

    _minController.addListener(() {
      double? min = double.tryParse(_minController.text);
      if (min != null && min >= _minPrice && min <= _maxPrice) {
        setState(() {
          _currentMin = min;
        });
      }
    });

    _maxController.addListener(() {
      double? max = double.tryParse(_maxController.text);
      if (max != null && max >= _currentMin && max <= _maxPrice) {
        setState(() {
          _currentMax = max;
        });
      }
    });
  }

  Future<void> _loadChoices() async {
    try {
      final choices = await _choicesFuture;
      for (var choice in choices) {
        var newVoyage = Voyages(id: choice.id, title: choice.choiceTxt);
        if (!myCategory.contains(newVoyage)) {
          setState(() {
            myCategory.add(newVoyage);
          });
        }
      }
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  Future<void> _loadChoicesLanguage() async {
    try {
      final choices = await _choicesLanguageFuture;
      for (var choice in choices) {
        var newVoyage = Voyages(id: choice.id, title: choice.choiceTxt);
        if (!myLanguage.contains(newVoyage)) {
          setState(() {
            myLanguage.add(newVoyage);
          });
        }
      }
    } catch (error) {
      // Handle error if fetching data fails
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AsyncForm(
          //onValidated: bloc.sendScheduleAbsence,
          onSuccess: () async {
            _onFilterAdded();
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
                          'Filtres',
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
                          'Nombre de voyageurs',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Adultes',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                Text(
                                  '12 ans et plus',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _decrementCounter,
                                    icon: Icon(Icons.remove,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Text(
                                  '$_counter',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _incrementCounter,
                                    icon: Icon(Icons.add,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enfants',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                Text(
                                  'De 2 ans à 10 ans',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _decrementCounterChild,
                                    icon: Icon(Icons.remove,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Text(
                                  '$_counterChild',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _incrementCounterChild,
                                    icon: Icon(Icons.add,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 16,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bébés (Gratuit)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(color: AppResources.colorDark),
                                ),
                                Text(
                                  'Moins de 2 ans',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _decrementCounterBaby,
                                    icon: Icon(Icons.remove,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Text(
                                  '$_counterBaby',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 16),
                                ),
                                SizedBox(
                                    width: ResponsiveSize.calculateWidth(
                                        8, context)),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppResources.colorGray45,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: _incrementCounterBaby,
                                    icon: Icon(Icons.add,
                                        color: AppResources.colorGray75),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Prix',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                        Text(
                          'Le prix moyen d’une expérience est de 55 €',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Minimum',
                                  suffixText: '€',
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: _maxController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Maximum',
                                  suffixText: '€',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        RangeSlider(
                          values: RangeValues(_currentMin, _currentMax),
                          min: _minPrice,
                          max: _maxPrice,
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentMin = values.start;
                              _currentMax = values.end;
                              _minController.text = _currentMin.toStringAsFixed(0);
                              _maxController.text = _currentMax.toStringAsFixed(0);
                            });
                          },
                        ),
                        Visibility(
                          visible: openFilter,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: AppResources.colorGray15,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Quelles catégories d’expériences ?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: ResponsiveSize.calculateWidth(319, context),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                                  runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                                  children: myCategory.map((item) {
                                    return ItemWidget(
                                      id: item.id,
                                      text: item.title,
                                      isSelected: myMap['voyageur_experiences'] != null
                                          ? myMap['voyageur_experiences']!.contains(item.id)
                                          : false,
                                      onTap: () {
                                        setState(() {
                                          if (myMap['voyageur_experiences'] == null) {
                                            myMap['voyageur_experiences'] =
                                                Set<int>(); // Initialize if null
                                          }

                                          if (myMap['voyageur_experiences']!
                                              .contains(item.id)) {
                                            myMap['voyageur_experiences']!.remove(item.id);
                                          } else {
                                            myMap['voyageur_experiences']!.add(item.id);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 1,
                                width: MediaQuery.of(context).size.width,
                                color: AppResources.colorGray15,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Quelles langues pour les expériences ?',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: ResponsiveSize.calculateWidth(319, context),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                                  runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                                  children: myLanguage.map((item) {
                                    return ItemWidget(
                                      id: item.id,
                                      text: item.title,
                                      isSelected: myMap['languages_fr'] != null
                                          ? myMap['languages_fr']!.contains(item.id)
                                          : false,
                                      onTap: () {
                                        setState(() {
                                          if (myMap['languages_fr'] == null) {
                                            myMap['languages_fr'] =
                                                Set<int>(); // Initialize if null
                                          }

                                          if (myMap['languages_fr']!
                                              .contains(item.id)) {
                                            myMap['languages_fr']!.remove(item.id);
                                          } else {
                                            myMap['languages_fr']!.add(item.id);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      !openFilter
                          ? Row(
                        children: [
                          Container(
                            width: ResponsiveSize.calculateWidth(145, context),
                            height: 44,
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      color: AppResources.colorVitamine,
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  openFilter = !openFilter;
                                });
                              },
                              child: Text(
                                'PLUS DE FILTRES',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppResources.colorVitamine),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ResponsiveSize.calculateWidth(29, context),
                          ),
                          Container(
                            width: ResponsiveSize.calculateWidth(145, context),
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
                              onPressed: () {
                                //validate();
                                setState(() {
                                  myMap['adults'] = {_counter};
                                  myMap['children'] = {_counterChild};
                                  myMap['babies'] = {_counterBaby};
                                  myMap['minPrice'] = {_currentMin};
                                  myMap['maxPrice'] = {_currentMax};
                                  Navigator.pop(context, true);
                                });
                              },
                              child: Text(
                                'ENREGISTRER',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppResources.colorWhite),
                              ),
                            ),
                          ),
                        ],
                      )
                          : Container(
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
                          onPressed: () {
                            setState(() {
                              myMap['adults'] = {_counter};
                              myMap['children'] = {_counterChild};
                              myMap['babies'] = {_counterBaby};
                              myMap['minPrice'] = {_currentMin};
                              myMap['maxPrice'] = {_currentMax};

                            });
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            'ENREGISTRER',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  void _incrementCounter() {
    setState(() {
      if (_counter < 10) {
        _counter++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  void _incrementCounterChild() {
    setState(() {
      if (_counterChild < 10) {
        _counterChild++;
      }
    });
  }

  void _decrementCounterChild() {
    setState(() {
      if (_counterChild > 0) {
        _counterChild--;
      }
    });
  }

  void _incrementCounterBaby() {
    setState(() {
      if (_counterBaby < 10) {
        _counterBaby++;
      }
    });
  }

  void _decrementCounterBaby() {
    setState(() {
      if (_counterBaby > 0) {
        _counterBaby--;
      }
    });
  }
}

class FiltredWidgetBloc with Disposable {

  @override
  void dispose() {
    super.dispose();
  }
}

class Voyages {
  final int id;
  final String title;

  Voyages({
    required this.id,
    required this.title,
  });
}
