import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';

import '../../../../resources/resources.dart';
import '../../../../services/app_service.dart';
import '../../../../utils/abstracts/bloc_provider.dart';
import '../../../../utils/abstracts/disposable.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step5.dart';

class CreateExpStep4 extends StatefulWidget {
  CreateExpStep4({super.key, required this.myMap, required this.name, required this.description, required this.audioPath});

  Map<String, Set<Object>> myMap = {};
  final String name;
  final String description;
  final String audioPath;

  @override
  State<CreateExpStep4> createState() => _CreateExpStep4State();
}

class _CreateExpStep4State extends State<CreateExpStep4> with BlocProvider<CreateExpStep4, CreateExpStep4Bloc> {
  double valueSlider = 0;
  final idExperience = 0;

  @override
  initBloc() => CreateExpStep4Bloc(widget.myMap, widget.name, widget.description, valueSlider, widget.audioPath, idExperience);

  void updateDuration(double value) {
    setState(() {
      valueSlider = value;
      bloc.updateDuration(value); // Call the method to update duration in bloc
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncForm(
        onValidated: bloc.makeExperienceGuide1,
        onSuccess: () {
          return navigateTo(context, (_) => CreateExpStep5(name: widget.name, description: widget.description, idExperience: bloc.idExperience!));
        },
        builder: (BuildContext context, void Function() validate) {
          return Container(
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
                  Stack(children: [
                    Image.asset(
                      'images/backgroundExp3.png',
                      width: double.infinity,
                      fit: BoxFit.fill,
                      height: ResponsiveSize.calculateHeight(190, context),
                    ),
                    Positioned(
                      top: 48,
                      left: 28,
                      child: Container(
                        width: ResponsiveSize.calculateWidth(32, context),
                        height: ResponsiveSize.calculateHeight(32, context),
                        //padding: const EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(40, context)),
                          ),
                        ),
                        child: FloatingActionButton(
                            backgroundColor: AppResources.colorWhite,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              String.fromCharCode(CupertinoIcons.back.codePoint),
                              style: TextStyle(
                                inherit: false,
                                color: AppResources.colorVitamine,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: CupertinoIcons
                                    .exclamationmark_circle.fontFamily,
                                package: CupertinoIcons
                                    .exclamationmark_circle.fontPackage,
                              ),
                            )),
                      ),
                    ),
                  ]),
                  SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Étape 3 sur 9',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(8, context)),
                        Text(
                          'Durée de l’expérience',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(16, context)),
                        Text(
                          'Donnes-nous une estimation pour que tes hôtes soient prêts !',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(40, context)),
                        Slider(
                          value: valueSlider,
                          max: 8,
                          divisions: 8,
                          label: '${valueSlider.round().toString()} heure'.plural(valueSlider.round()),
                          onChanged: (double value) {
                            setState(() {
                              valueSlider = value;
                              updateDuration(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: ResponsiveSize.calculateHeight(44, context),
                            right: ResponsiveSize.calculateWidth(28, context)),
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
                            onPressed: (){
                              setState(() {
                                // Proceed to the next step
                                //navigateTo(context, (_) => CreateExpStep5(myMap: widget.myMap,));
                                validate();
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
      ),
    );
  }
}

class CreateExpStep4Bloc with Disposable {
  String? name;
  String? description;
  double duration;
  String? audioPath;
  int? idExperience;
  Map<String, Set<Object>> myMap;

  // Create a new map with lists instead of sets
  Map<String, dynamic> modifiedMap = {};

  CreateExpStep4Bloc(this.myMap, this.name, this.description, this.duration, this.audioPath, this.idExperience);

  Future<void> makeExperienceGuide1() async {
    try {
      modifiedMap['nom'] = name!;
      modifiedMap['description'] = description!;
      modifiedMap['dure'] = duration.toInt();

      // Convert sets to lists
      myMap.forEach((key, value) {
        modifiedMap[key] = value.toList();
      });

      // Perform the API call
      final response = await AppService.api.makeExperienceGuide1(modifiedMap, audioFilePath: audioPath);
      idExperience = response.experience.id;

    } catch (error) {
      // Handle the error appropriately
      print("Error in make Experience Guide 1: $error");
    }
  }

  void updateDuration(double value) {
    duration = value;
  }

  @override
  void dispose() {
    // Dispose of any resources if needed
    super.dispose();
  }
}
