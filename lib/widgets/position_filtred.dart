import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:meet_pe/utils/_utils.dart';
import 'package:meet_pe/widgets/_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../resources/resources.dart';
import '../services/app_service.dart';

class PositionFiltred extends StatefulWidget {
  const PositionFiltred({super.key});

  @override
  State<PositionFiltred> createState() => _PositionFiltredState();
}

class _PositionFiltredState extends State<PositionFiltred>
    with BlocProvider<PositionFiltred, PositionFiltredBloc> {
  double valueSlider = 30;

  @override
  initBloc() => PositionFiltredBloc();


  void _onAbsenceAdded() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AsyncForm(
          onValidated: bloc.sendScheduleAbsence,
          onSuccess: () async {
            _onAbsenceAdded();
          },
          builder: (context, validate) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Position',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontSize: 32, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Autour de moi',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 42),
                        Slider(
                          value: valueSlider,
                          min: 1,
                          max: 100,
                          divisions: 100,
                          label: '${valueSlider.round().toString()} KM',
                          onChanged: (double value) {
                            setState(() {
                              valueSlider = value;
                            });
                          },
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: AppResources.colorGray15,
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: ResponsiveSize.calculateWidth(319, context),
                          height: 44,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(
                                  Colors.transparent),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1,
                                      color: AppResources.colorDark),
                                  borderRadius:
                                  BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            onPressed: () {
                              validate();
                            },
                            child: Text(
                              'ENREGISTRER',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                  color: AppResources.colorDark),
                            ),
                          ),
                        ),
                        const SizedBox(height: 33),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class PositionFiltredBloc with Disposable {

  Future<bool> sendScheduleAbsence() async {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
