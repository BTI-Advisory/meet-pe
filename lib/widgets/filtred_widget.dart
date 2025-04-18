import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../models/step_list_response.dart';
import '../resources/resources.dart';
import '../services/app_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FiltredWidget extends StatefulWidget {
  final Map<String, String>? initialFilters;

  const FiltredWidget({super.key, this.initialFilters});

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
  double _currentMin = 15;
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

  Map<String, String> formatMyMap(Map<String, Set<Object>> map) {
    return map.map((key, value) {
      return MapEntry(key, value.map((e) => e.toString()).join(', '));
    });
  }

  void _onFilterAdded(Map<String, String> formattedMap) {
    Navigator.pop(context, formattedMap);
  }

  @override
  void initState() {
    super.initState();
    _choicesFuture = AppService.api.fetchChoices('voyageur_experiences');
    _choicesLanguageFuture = AppService.api.fetchChoices('languages_fr');
    _loadChoices();
    _loadChoicesLanguage();
    if (widget.initialFilters != null) {
      final map = widget.initialFilters!;

      _counter = int.tryParse(map['filtre_nb_adultes'] ?? '3') ?? 3;
      _counterChild = int.tryParse(map['filtre_nb_enfants'] ?? '0') ?? 0;
      _counterBaby = int.tryParse(map['filtre_nb_bebes'] ?? '0') ?? 0;
      _currentMin = double.tryParse(map['filtre_prix_min'] ?? '15') ?? 15;
      _currentMax = double.tryParse(map['filtre_prix_max'] ?? '1500') ?? 1500;

      _minController.text = _currentMin.toStringAsFixed(0);
      _maxController.text = _currentMax.toStringAsFixed(0);

      // Categorie
      if (map['filtre_categorie'] != null && map['filtre_categorie']!.isNotEmpty) {
        myMap['filtre_categorie'] = map['filtre_categorie']!
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toSet();
      }

      // Langue
      if (map['filtre_langue'] != null && map['filtre_langue']!.isNotEmpty) {
        myMap['filtre_langue'] = map['filtre_langue']!
            .split(',')
            .map((e) => int.tryParse(e.trim()))
            .whereType<int>()
            .toSet();
      }
    }

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

  void _onItemTap(int itemId) {
    setState(() {
      if (myMap['filtre_categorie'] == null) {
        myMap['filtre_categorie'] = {};
      }

      // Check if the tapped item is already selected
      final bool isSelected = myMap['filtre_categorie']!.contains(itemId);

      // If it's the last item and it's already selected, deselect it
      if (itemId == myCategory.last.id && isSelected) {
        myMap['filtre_categorie']!.remove(itemId);
      } else {
        // If it's the last item, deselect all other items
        if (itemId == myCategory.last.id) {
          myMap['filtre_categorie'] = {itemId};
        } else {
          // Deselect the last item if it's currently selected
          if (myMap['filtre_categorie']!.contains(myCategory.last.id)) {
            myMap['filtre_categorie']!.remove(myCategory.last.id);
          }
          // Toggle selection for the tapped item
          if (isSelected) {
            myMap['filtre_categorie']!.remove(itemId);
          } else {
            myMap['filtre_categorie']!.add(itemId);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight
                ),
                child: IntrinsicHeight(
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
                              AppLocalizations.of(context)!.filter_text,
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
                              AppLocalizations.of(context)!.number_traveler_text,
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
                                      AppLocalizations.of(context)!.adult_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.age_adult_text,
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
                                      AppLocalizations.of(context)!.kids_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.age_kids_text,
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
                                      AppLocalizations.of(context)!.baby_text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(color: AppResources.colorDark),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.age_baby_text,
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
                              AppLocalizations.of(context)!.price_text,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppResources.colorDark),
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
                                      labelText: AppLocalizations.of(context)!.minimum_text,
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
                                      labelText: AppLocalizations.of(context)!.maximum_text,
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.what_category_text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.what_category_desc_text,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    ],
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
                                          isSelected: myMap['filtre_categorie'] != null
                                              ? myMap['filtre_categorie']!.contains(item.id)
                                              : false,
                                          onTap: () => _onItemTap(item.id),
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
                                    AppLocalizations.of(context)!.what_language_text,
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
                                          isSelected: myMap['filtre_langue'] != null
                                              ? myMap['filtre_langue']!.contains(item.id)
                                              : false,
                                          onTap: () {
                                            setState(() {
                                              if (myMap['filtre_langue'] == null) {
                                                myMap['filtre_langue'] =
                                                    Set<int>(); // Initialize if null
                                              }

                                              if (myMap['filtre_langue']!
                                                  .contains(item.id)) {
                                                myMap['filtre_langue']!.remove(item.id);
                                              } else {
                                                myMap['filtre_langue']!.add(item.id);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
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
                                      AppLocalizations.of(context)!.more_filter_text,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppResources.colorVitamine,
                                        fontSize: ResponsiveSize.calculateTextSize(14, context),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: ResponsiveSize.calculateWidth(29, context),
                                ),
                                Expanded(
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
                                        myMap['filtre_nb_adultes'] = {_counter};
                                        myMap['filtre_nb_enfants'] = {_counterChild};
                                        myMap['filtre_nb_bebes'] = {_counterBaby};
                                        myMap['filtre_prix_min'] = {_currentMin};
                                        myMap['filtre_prix_max'] = {_currentMax};
                                        //Navigator.pop(context, true);
                                        _onFilterAdded(formatMyMap(myMap));
                                      });
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.enregister_text,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppResources.colorWhite,
                                        fontSize: ResponsiveSize.calculateTextSize(14, context),
                                      ),
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
                                    myMap['filtre_nb_adultes'] = {_counter};
                                    myMap['filtre_nb_enfants'] = {_counterChild};
                                    myMap['filtre_nb_bebes'] = {_counterBaby};
                                    myMap['filtre_prix_min'] = {_currentMin};
                                    myMap['filtre_prix_max'] = {_currentMax};

                                  });
                                  //Navigator.pop(context, true);
                                  _onFilterAdded(formatMyMap(myMap));
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.enregister_text,
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
                ),
              ),
            );
          }
        ),
      ),
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
