import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/audio_player.dart';
import '../../../../utils/audio_recorder.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step4.dart';

class CreateExpStep3 extends StatefulWidget {
  CreateExpStep3({super.key, required this.myMap, required this.name, required this.description});

  final String name;
  final String description;

  Map<String, Set<Object>> myMap = {};

  @override
  State<CreateExpStep3> createState() => _CreateExpStep3State();
}

class _CreateExpStep3State extends State<CreateExpStep3> {
  bool showPlayer = false;
  String? audioPath;
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];

  @override
  void initState() {
    super.initState();
    showPlayer = false;
    _choicesFuture = AppService.api.fetchChoices('languages_fr');
    _loadChoices();
  }

  Future<void> _loadChoices() async {
    try {
      final choices = await _choicesFuture;
      for (var choice in choices) {
        var newVoyage = Voyage(id: choice.id, title: choice.choiceTxt);
        if (!myList.contains(newVoyage)) {
          setState(() {
            myList.add(newVoyage);
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
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          height: deviceSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppResources.colorGray5, AppResources.colorWhite],
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'images/backgroundExp2.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: ResponsiveSize.calculateHeight(190, context),
                ),
                SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Étape 2 sur 9',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(8, context)),
                      Text(
                        'Langue de ton expérience',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(16, context)),
                      Text(
                        "C'est le moment idéal pour donner une touche",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(40, context)),
                      ///Todo add Audio Feature
                      /*Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                ResponsiveSize.calculateWidth(22, context)),
                        width: double.infinity,
                        height: ResponsiveSize.calculateHeight(90, context),
                        decoration: ShapeDecoration(
                          color: AppResources.colorBeige,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(
                                    45, context)),
                          ),
                        ),
                        child: showPlayer
                            ? Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                                child: AudioPlayer(
                                  source: audioPath!,
                                  onDelete: () {
                                    setState(() => showPlayer = false);
                                  },
                                ),
                              )
                            : Recorder(
                                onStop: (path) {
                                  if (kDebugMode)
                                    print('Recorded file path: $path');
                                  setState(() {
                                    audioPath = path;
                                    showPlayer = true;
                                  });
                                },
                              ),
                      ),*/
                      Container(
                        width: ResponsiveSize.calculateWidth(319, context),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: ResponsiveSize.calculateWidth(8, context), // Horizontal spacing between items
                          runSpacing: ResponsiveSize.calculateHeight(12, context), // Vertical spacing between lines
                          children: myList.map((item) {
                            return Item(
                              id: item.id,
                              text: item.title,
                              isSelected: widget.myMap['languages_fr'] != null
                                  ? widget.myMap['languages_fr']!.contains(item.id)
                                  : false,
                              onTap: () {
                                setState(() {
                                  if (widget.myMap['languages_fr'] == null) {
                                    widget.myMap['languages_fr'] =
                                        Set<int>(); // Initialize if null
                                  }

                                  if (widget.myMap['languages_fr']!
                                      .contains(item.id)) {
                                    widget.myMap['languages_fr']!.remove(item.id);
                                  } else {
                                    widget.myMap['languages_fr']!.add(item.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: ResponsiveSize.calculateHeight(44, context),
                          right: ResponsiveSize.calculateWidth(28, context),
                      ),
                      child: Container(
                        width: ResponsiveSize.calculateWidth(151, context),
                        height: ResponsiveSize.calculateHeight(44, context),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateHeight(
                                        24, context),
                                    vertical: ResponsiveSize.calculateHeight(
                                        10, context))),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
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
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          onPressed: widget.myMap['languages_fr'] != null &&
                              widget.myMap['languages_fr']!.isNotEmpty
                              ? () {
                            ///Todo: Remove this when API is modified
                            widget.myMap.remove('languages_fr');
                            setState(() {
                              // Proceed to the next step
                              navigateTo(context, (_) => CreateExpStep4(myMap: widget.myMap, name: widget.name, description: widget.description, about: 'about me text', audioPath: audioPath ?? '',));
                            });
                          }
                              : null,
                          child: Image.asset('images/arrowLongRight.png'),
                        ),
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

class Item extends StatefulWidget {
  final int id;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const Item({
    required this.id,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: IntrinsicWidth(
        child: Container(
          height: ResponsiveSize.calculateHeight(40, context),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(16, context), vertical: ResponsiveSize.calculateHeight(10, context)-3),
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(ResponsiveSize.calculateCornerRadius(24, context))),
            border: Border.all(color: AppResources.colorGray100),
          ),
          child: Center(
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: widget.isSelected
                    ? Colors.white
                    : AppResources.colorGray100,
                fontWeight:
                widget.isSelected ? FontWeight.w500 : FontWeight.w300,
              ),
            ),
          ),
        ),
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
