import 'package:flutter/material.dart';

import '../../../../models/step_list_response.dart';
import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/audio_player.dart';
import '../../../../utils/audio_recorder.dart';
import '../../../../utils/_utils.dart';
import '../../../../widgets/_widgets.dart';
import 'create_exp_step4.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                        AppLocalizations.of(context)!.step_3_text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                          height: ResponsiveSize.calculateHeight(8, context)),
                      Text(
                        AppLocalizations.of(context)!.step_3_title_text,
                        style: Theme.of(context).textTheme.headlineMedium,
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
                            return ItemWidget(
                              id: item.id,
                              text: item.title,
                              isSelected: widget.myMap['experience_languages'] != null
                                  ? widget.myMap['experience_languages']!.contains(item.id)
                                  : false,
                              onTap: () {
                                setState(() {
                                  if (widget.myMap['experience_languages'] == null) {
                                    widget.myMap['experience_languages'] =
                                        Set<int>(); // Initialize if null
                                  }

                                  if (widget.myMap['experience_languages']!
                                      .contains(item.id)) {
                                    widget.myMap['experience_languages']!.remove(item.id);
                                  } else {
                                    widget.myMap['experience_languages']!.add(item.id);
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
                          onPressed: widget.myMap['experience_languages'] != null &&
                              widget.myMap['experience_languages']!.isNotEmpty
                              ? () {
                            setState(() {
                              // Proceed to the next step
                              navigateTo(context, (_) => CreateExpStep4(myMap: widget.myMap, name: widget.name, description: widget.description, audioPath: audioPath ?? '',));
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
