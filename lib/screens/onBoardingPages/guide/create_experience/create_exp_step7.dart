import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';
import '../../../../utils/utils.dart';
import 'create_exp_step8.dart';

class CreateExpStep7 extends StatefulWidget {
  const CreateExpStep7({super.key});

  @override
  State<CreateExpStep7> createState() => _CreateExpStep7State();
}

class _CreateExpStep7State extends State<CreateExpStep7> {
  double valueSlider = 0;

  void updateDuration(double value) {
    setState(() {
      valueSlider = value;
      //bloc.updateDuration(value); // Call the method to update duration in bloc
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: [
                Image.asset('images/backgroundExp5.png'),
                Positioned(
                  top: 48,
                  left: 28,
                  child: Container(
                    width: ResponsiveSize.calculateWidth(24, context),
                    height: ResponsiveSize.calculateHeight(24, context),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            ResponsiveSize.calculateCornerRadius(40, context)),
                      ),
                    ),
                    child: FloatingActionButton(
                        heroTag: "btn1",
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
                      'Étape 5 sur 8',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(8, context)),
                    Text(
                      'Ça coûte combien ?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(16, context)),
                    Text(
                      'Renseigne le prix de ton expérience par personne.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(40, context)),
                    Slider(
                      value: valueSlider,
                      max: 100,
                      divisions: 10,
                      label: '${valueSlider.round().toString()} €',
                      onChanged: (double value) {
                        setState(() {
                          valueSlider = value;
                          updateDuration(value);
                        });
                      },
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(33, context)),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Prix conseillé dans cette catégorie',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                          ),
                          Text(
                            ' 30 €',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorDark),
                          ),
                        ],
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
                          navigateTo(context, (_) => CreateExpStep8());
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
