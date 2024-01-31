import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/responsive_size.dart';

class CreateExpStep6 extends StatefulWidget {
  const CreateExpStep6({super.key, required this.photo});
  final String photo;

  @override
  State<CreateExpStep6> createState() => _CreateExpStep6State();
}

class _CreateExpStep6State extends State<CreateExpStep6> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
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
                      height: ResponsiveSize.calculateHeight(576, context),
                      child: Stack(
                        children: [
                          Positioned(
                            left: -36,
                            top: 0,
                            child: Container(
                              width:
                                  ResponsiveSize.calculateWidth(427, context),
                              height:
                                  ResponsiveSize.calculateHeight(592, context),
                              child: Image.asset(
                                widget.photo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 60,
                            child: Container(
                              width:
                                  ResponsiveSize.calculateWidth(375, context),
                              height:
                                  ResponsiveSize.calculateHeight(532, context),
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
                        ],
                      ),
                    ),
                    //back button
                    Positioned(
                      top: 48,
                      left: 28,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ResponsiveSize.calculateCornerRadius(
                                    40, context)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: ResponsiveSize.calculateWidth(24, context),
                              height:
                                  ResponsiveSize.calculateHeight(24, context),
                              child: FloatingActionButton(
                                backgroundColor: AppResources.colorWhite,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  String.fromCharCode(
                                      CupertinoIcons.back.codePoint),
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
                            SizedBox(
                                width:
                                    ResponsiveSize.calculateWidth(8, context)),
                            Text(
                              'Mode visualisation',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppResources.colorWhite),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //bloc info in the bottom
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
                                        color: AppResources.colorBeigeLight),
                              ),
                              SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      5, context)),
                              Container(
                                width:
                                    ResponsiveSize.calculateWidth(85, context),
                                height:
                                    ResponsiveSize.calculateHeight(28, context),
                                //padding: EdgeInsets.only(top: ResponsiveSize.calculateHeight(6, context), left: ResponsiveSize.calculateWidth(12, context), right: ResponsiveSize.calculateWidth(16, context), bottom: ResponsiveSize.calculateHeight(6, context)),
                                decoration: ShapeDecoration(
                                  color: Color(0xFFA9246D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ResponsiveSize.calculateCornerRadius(
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
                            ],
                          ),
                          SizedBox(
                              height:
                                  ResponsiveSize.calculateHeight(12, context)),
                          Row(
                            children: [
                              IntrinsicWidth(
                                child: Container(
                                  height: ResponsiveSize.calculateHeight(
                                      28, context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(
                                          12, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ResponsiveSize
                                            .calculateCornerRadius(
                                                20, context))),
                                    border: Border.all(
                                        color: AppResources.colorBeigeLight),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Image.asset('images/icon_verified.png'),
                                        SizedBox(
                                            width:
                                                ResponsiveSize.calculateWidth(
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
                                  height: ResponsiveSize.calculateHeight(
                                      28, context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(
                                          12, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ResponsiveSize
                                            .calculateCornerRadius(
                                                20, context))),
                                    border: Border.all(
                                        color: AppResources.colorBeigeLight),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Image.asset('images/icon_badge.png'),
                                        SizedBox(
                                            width:
                                                ResponsiveSize.calculateWidth(
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
                                  height: ResponsiveSize.calculateHeight(
                                      28, context),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveSize.calculateWidth(
                                          12, context)),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ResponsiveSize
                                            .calculateCornerRadius(
                                                20, context))),
                                    border: Border.all(
                                        color: AppResources.colorBeigeLight),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Image.asset('images/icon_star.png'),
                                        SizedBox(
                                            width:
                                                ResponsiveSize.calculateWidth(
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
              SizedBox(height: ResponsiveSize.calculateHeight(32, context)),
              SizedBox(
                width: ResponsiveSize.calculateWidth(319, context),
                child: Text(
                  'Le Paris de Maria \nen deux lignes ',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                ),
              ),
              SizedBox(height: ResponsiveSize.calculateHeight(20, context)),
              SizedBox(
                width: ResponsiveSize.calculateWidth(319, context),
                child: const Opacity(
                  opacity: 0.50,
                  child: Text(
                    'Je te réserve une balade inattendue et pleine de surprises à travers le seizième arrondissement de Paris. Prépare-toi à découvrir des coins secrets, à déguster des délices locaux et à vivre des moments mémorables.',
                    style: TextStyle(
                      color: Color(0xFF1D1D1D),
                      fontSize: 14,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w400,
                      height: 0,
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
