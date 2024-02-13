import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../widgets/_widgets.dart';

class AvailabilitiesPage extends StatefulWidget {
  const AvailabilitiesPage({super.key});

  @override
  State<AvailabilitiesPage> createState() => _AvailabilitiesPageState();
}

class _AvailabilitiesPageState extends State<AvailabilitiesPage> {
  bool isAvailable = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mes disponibilités',
      ),
      body: SingleChildScrollView(
        child: Container(
          width: deviceSize.width,
          height: deviceSize.height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.calculateWidth(31, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rencontre avec les voyageurs',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(17, context)),
                    Text(
                      'Merci beaucoup de nous donner un coup de main en partageant tes dispos de façon super précise, c’est ultra important pour notre communauté ! Merci d’avance, tu es le meilleur 😎 !',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppResources.colorGray30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isAvailable
                              ? 'Disponible 24h / 7j sur 7'
                              : 'Toujours disponible',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff797979)),
                        ),
                        Switch.adaptive(
                          value: isAvailable,
                          activeColor: AppResources.colorVitamine,
                          onChanged: (bool value) {
                            setState(() {
                              isAvailable = value;
                            });
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: isAvailable
                          ? ResponsiveSize.calculateHeight(0, context)
                          : ResponsiveSize.calculateHeight(15, context),
                    ),
                    Visibility(
                      visible: !isAvailable,
                      child: Container(
                        width: 321,
                        height: 60,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.12999999523162842),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: AppResources.colorVitamine),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Image.asset('images/info_icon.png'),
                              const Icon(Icons.info_outline,
                                  size: 24, color: AppResources.colorVitamine),
                              SizedBox(
                                  width: ResponsiveSize.calculateWidth(
                                      10, context)),
                              Text(
                                'Tes disponibilités s’appliquent à toutes tes \nexpériences.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: AppResources.colorVitamine),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                        height: ResponsiveSize.calculateHeight(25, context)),
                  ],
                ),
              ),
              Visibility(
                visible: !isAvailable,
                child: Column(
                  children: [
                    DayAvailable(dayName: 'Lundi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Mardi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Mercredi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Jeudi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Vendredi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Samedi', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                    DayAvailable(dayName: 'Dimanche', onCallBack: (date) {
                      setState(() {
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

