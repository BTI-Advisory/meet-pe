import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../resources/resources.dart';
import '../../../utils/_utils.dart';
import '../../../widgets/themed/ep_app_bar.dart';

class EditExperiencePage extends StatefulWidget {
  const EditExperiencePage({super.key});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  bool onLine = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EpAppBar(
        title: 'Mode Edition',
        actions: [
          Text('En ligne',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 12, color: AppResources.colorDark)),
          Switch.adaptive(
            value: onLine,
            activeColor: AppResources.colorVitamine,
            onChanged: (bool value) {
              setState(() {
                onLine = value;
              });
            },
          )
        ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.00, -1.00),
                end: Alignment(0, 1),
                colors: [Color(0x00F8F3EC), AppResources.colorBeigeLight],
              ),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: Stack(
                      children: [
                        Container(
                          width: ResponsiveSize.calculateWidth(375, context),
                          height: 576,
                          child: Stack(
                            children: [
                              /// Image principal
                              Positioned(
                                left: -36,
                                top: 0,
                                child: Container(
                                  width: ResponsiveSize.calculateWidth(
                                      427, context),
                                  height: 592,
                                  child: Image.asset(
                                    'images/imageTest.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              /// Shadow bottom
                              Positioned(
                                left: 0,
                                top: 60,
                                child: Container(
                                  width: ResponsiveSize.calculateWidth(
                                      375, context),
                                  height: 532,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment(-0.00, -1.00),
                                      end: Alignment(0, 1),
                                      colors: [
                                        Colors.black.withOpacity(0),
                                        Colors.black
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// Edit picture button
                              Positioned(
                                top: 280,
                                right: 28,
                                child: editButton(onTap: () {
                                  print('Edit image');
                                }),
                              ),
                            ],
                          ),
                        ),

                        ///bloc info in the bottom
                        Positioned(
                          top: 425,
                          left: 28,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommandé à',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppResources.colorBeigeLight),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '88 %',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            fontSize: 32,
                                            color:
                                                AppResources.colorBeigeLight),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          11, context)),
                                  Container(
                                    width: ResponsiveSize.calculateWidth(
                                        85, context),
                                    height: 28,
                                    decoration: ShapeDecoration(
                                      color: AppResources.colorVitamine,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            ResponsiveSize
                                                .calculateCornerRadius(
                                                    20, context)),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Aventurier',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontSize: 12,
                                                color: AppResources.colorWhite),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          11, context)),
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: ResponsiveSize.calculateWidth(
                                            85, context),
                                        height: 28,
                                        decoration: ShapeDecoration(
                                          color: AppResources.colorWhite,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                ResponsiveSize
                                                    .calculateCornerRadius(
                                                        20, context)),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '100€/pers',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    color:
                                                        AppResources.colorDark),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -18,
                                        right: 10,
                                        child: editButton(onTap: () {
                                          print('Edit price');
                                        }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  IntrinsicWidth(
                                    child: Container(
                                      height: 28,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateWidth(
                                                  12, context)),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color:
                                                AppResources.colorBeigeLight),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'images/icon_verified.png'),
                                            SizedBox(
                                                width: ResponsiveSize
                                                    .calculateWidth(
                                                        4, context)),
                                            Text(
                                              'Vérifié',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: AppResources
                                                        .colorBeigeLight,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          8, context)),
                                  IntrinsicWidth(
                                    child: Container(
                                      height: 28,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateWidth(
                                                  12, context)),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color:
                                                AppResources.colorBeigeLight),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'images/icon_badge.png'),
                                            SizedBox(
                                                width: ResponsiveSize
                                                    .calculateWidth(
                                                        4, context)),
                                            Text(
                                              'Pro',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: AppResources
                                                        .colorBeigeLight,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          8, context)),
                                  IntrinsicWidth(
                                    child: Container(
                                      height: 28,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSize.calculateWidth(
                                                  12, context)),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        border: Border.all(
                                            color:
                                                AppResources.colorBeigeLight),
                                      ),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Image.asset('images/icon_star.png'),
                                            SizedBox(
                                                width: ResponsiveSize
                                                    .calculateWidth(
                                                        4, context)),
                                            Text(
                                              '4,75/5 (120)',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: AppResources
                                                        .colorBeigeLight,
                                                    fontSize: 12,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'images/background_mask.png',
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    child: Text(
                      'Le Paris de Maria \nen deux lignes ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 32, color: AppResources.colorDark),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: ResponsiveSize.calculateWidth(319, context),
                        child: Opacity(
                          opacity: 0.50,
                          child: Text(
                            'Je te réserve une balade inattendue et pleine de surprises à travers le seizième arrondissement de Paris. Prépare-toi à découvrir des coins secrets, à déguster des délices locaux et à vivre des moments mémorables.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: AppResources.colorDark),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: editButton(onTap: () {
                          print('Edit description');
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 27),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.calculateWidth(22, context)),
                    width: double.infinity,
                    child: Image.asset('images/play-wave.png'),
                  ),
                  const SizedBox(height: 34),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(319, context),
                    child: Text(
                      'Gallery',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppResources.colorDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 13.0),
            color: Colors.white,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: ResponsiveSize.calculateWidth(160, context),
                    height: 44,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                    ResponsiveSize.calculateWidth(24, context),
                                vertical: 12)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return AppResources.colorWhite;
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'SUPPRIMER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorVitamine),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    width: ResponsiveSize.calculateWidth(160, context),
                    height: 44,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                                horizontal:
                                    ResponsiveSize.calculateWidth(24, context),
                                vertical: 12)),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return AppResources.colorVitamine;
                          },
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'ENREGISTRER',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: AppResources.colorWhite),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class editButton extends StatelessWidget {
  const editButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: AppResources.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19FF4D00),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x16FF4D00),
              blurRadius: 5,
              offset: Offset(0, 5),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x0CFF4D00),
              blurRadius: 6,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x02FF4D00),
              blurRadius: 7,
              offset: Offset(0, 18),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color(0x00FF4D00),
              blurRadius: 8,
              offset: Offset(0, 29),
              spreadRadius: 0,
            )
          ],
        ),
        child: Image.asset('images/pen_icon.png'),
      ),
    );
  }
}
