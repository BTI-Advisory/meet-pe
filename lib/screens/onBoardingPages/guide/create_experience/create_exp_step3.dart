import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
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

  @override
  void initState() {
    showPlayer = false;
    super.initState();
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.asset(
                  'images/backgroundExp2.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                  height: ResponsiveSize.calculateHeight(190, context),
                ),
                Positioned(
                  top: 48,
                  left: 28,
                  child: Container(
                    width: ResponsiveSize.calculateWidth(24, context),
                    height: ResponsiveSize.calculateHeight(24, context),
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
                      'Étape 2 sur 9',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(8, context)),
                    Text(
                      'Description de l’expérience',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(16, context)),
                    Text(
                      "Envie de te démarquer ? Appuie sur le bouton et fais-nous découvrir ton univers 🎙️ C'est une opportunité unique de partager ta passion ou quelque chose sur toi et créer une connexion avec nos voyageurs. Fais entendre ta voix et rends ton expérience encore plus mémorable ✨",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(40, context)),
                    Text(
                      widget.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppResources.colorDark),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: AppResources.colorGray15,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(40, context)),
                    Container(
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
                        onPressed: () {
                          navigateTo(context, (_) => CreateExpStep4(myMap: widget.myMap, name: widget.name, description: widget.description, audioPath: audioPath ?? '',));
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
      ),
    );
  }
}
