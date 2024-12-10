import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/step_list_response.dart';
import '../../../services/app_service.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';
import '../../../widgets/_widgets.dart';

class EditLanguagePage extends StatefulWidget {
  const EditLanguagePage({super.key});
  @override
  State<EditLanguagePage> createState() => _EditLanguagePageState();
}

class _EditLanguagePageState extends State<EditLanguagePage> {
  late Future<List<StepListResponse>> _choicesFuture;
  late List<Voyage> myList = [];
  List<int> languageList = []; // List of selected languages

  @override
  void initState() {
    super.initState();
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
      print('Error: $error'); // Handle error if fetching data fails
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F3F3), Colors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 48),
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(24, context),
                        height: ResponsiveSize.calculateHeight(24, context),
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Langue de ton expérience',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "C'est le moment idéal pour donner une touche ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: ResponsiveSize.calculateWidth(319, context),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: ResponsiveSize.calculateWidth(8, context),
                          runSpacing: ResponsiveSize.calculateHeight(12, context),
                          children: myList.map((item) {
                            final isSelected = languageList.contains(item.id);
                            return ItemWidget(
                              id: item.id,
                              text: item.title,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    languageList.remove(item.id);
                                  } else {
                                    languageList.add(item.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    height: ResponsiveSize.calculateHeight(44, context),
                    child: TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal: ResponsiveSize.calculateWidth(24, context),
                                vertical: ResponsiveSize.calculateHeight(12, context))),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1, color: AppResources.colorDark),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      child: Text(
                        'ENREGISTRER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorDark),
                      ),
                      onPressed: () {
                        final selectedLanguages =
                        languageList.join(', '); // Convert list to string
                        Navigator.pop(context, selectedLanguages);
                      },
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
