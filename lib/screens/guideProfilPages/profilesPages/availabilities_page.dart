import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../../../utils/responsive_size.dart';
import '../../../utils/utils.dart';
import '../../../widgets/_widgets.dart';

class AvailabilitiesPage extends StatefulWidget {
  const AvailabilitiesPage({super.key});

  @override
  State<AvailabilitiesPage> createState() => _AvailabilitiesPageState();
}

class _AvailabilitiesPageState extends State<AvailabilitiesPage> {
  bool isAvailable = false;
  List<Map<String, String>> absencesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mes disponibilités',
      ),
      body: SingleChildScrollView(
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
                  const SizedBox(height: 17),
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
            SizedBox(
              height: isAvailable
                  ? ResponsiveSize.calculateHeight(0, context)
                  : ResponsiveSize.calculateHeight(23, context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Absences exceptionnelles',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et par defaut toutes nos expériences sont disponibles en français',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppResources.colorGray30),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return ExceptionalAbsences(
                            absences: [],
                            onCallBack: (absence) {
                              setState(() {
                                absencesList = absence;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Text(
                      'Ajouter une abscence',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppResources.colorVitamine),
                    ),
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
            Column(
              children: absencesList.map((absence) {
                final startDate = absence["startDate"];
                final formattedStartDate = yearsFrenchFormat(startDate!);
                final endDate = absence["endDate"];
                final formattedEndDate = yearsFrenchFormat(endDate!);
                return listExceptionalAbsences(formattedStartDate, formattedEndDate);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget listExceptionalAbsences(String startDate, String endDate) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Du $startDate au $endDate',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: const Color(0xFF797979)),
              ),
              Image.asset('images/chevron_right.png',
                  width: 27, height: 27, fit: BoxFit.fill),
            ],
          ),
        ),
        const SizedBox(height: 19),
        Container(
          width: 390,
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: AppResources.colorImputStroke,
              ),
            ),
          ),
        )
      ],
    );
  }
}

