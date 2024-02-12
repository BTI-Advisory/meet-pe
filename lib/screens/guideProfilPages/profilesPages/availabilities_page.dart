import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:meet_pe/utils/_utils.dart';

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
  bool isAvailableHour = false;
  String hourAvailableStart = '00:00';
  String hourAvailableEnd = '23:59';

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
              dayAvailable('Lundi'),
              dayAvailable('Mardi')
            ],
          ),
        ),
      ),
    );
  }

  Widget dayAvailable(String dayName) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 31),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    height: 452,
                    //color: Colors.amber,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 39),
                          Text(
                            'Horaires',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Le prix moyen d’une expérience est de 55 €',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppResources.colorGray60),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Disponible de 9:00 à 18:00',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff797979)),
                              ),
                              StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Switch.adaptive(
                                    value: isAvailableHour,
                                    activeColor: AppResources.colorVitamine,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isAvailableHour = value;
                                      });
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 155.50,
                                height: 52,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1,
                                        color: AppResources.colorGray15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: GestureDetector(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'De',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontSize: 12),
                                      ),
                                      StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Text(
                                            hourAvailableStart,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                color: Color(0x3F1D1D1D)),
                                          );
                                        },
                                      ),
                                      /*Text(
                                        hourAvailableStart,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Color(0x3F1D1D1D)),
                                      ),*/
                                    ],
                                  ),
                                  onTap: () {
                                    DatePicker.showTimePicker(context,
                                        showTitleActions: true,
                                        showSecondsColumn: false,
                                        onChanged: (date) {
                                          print('change $date');
                                        }, onConfirm: (date) {
                                          print('confirm $date');
                                          setState(() {
                                            hourAvailableStart = '${date.hour}:${date.minute}';
                                            print('hourAvailableStart: $hourAvailableStart');
                                          });
                                        }, locale: LocaleType.fr);
                                  },
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            child: Text(
                              'ENREGISTRER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppResources.colorDark),
                            ),
                            //onPressed: () => Navigator.pop(context),
                            onPressed: () {
                              showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(hour: 12, minute: 00));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF797979)),
                ),
                Row(
                  children: [
                    Text(
                      'Non disponible',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppResources.colorDark),
                    ),
                    Image.asset('images/chevron_right.png',
                        width: 27, height: 27, fit: BoxFit.fill),
                  ],
                ),
              ],
            ),
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
