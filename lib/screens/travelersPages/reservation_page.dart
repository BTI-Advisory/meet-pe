import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/experience_model.dart';
import '../../models/reservation_request.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../utils/_utils.dart';
import '../../widgets/themed/ep_app_bar.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key, required this.experienceData, required this.date, required this.time}) : super(key: key);
  final Experience experienceData;
  final String date;
  final String time;

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isKidsAvailable = false;
  bool isGroupeAvailable = false;
  int _counter = 3;
  int _counterChild = 0;
  int _counterBaby = 0;
  late TextEditingController _textEditingControllerName;
  late TextEditingController _textEditingControllerComment;
  String? validationMessageName = '';
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _textEditingControllerName = TextEditingController();
    _textEditingControllerName.addListener(_onTextChanged);
    _textEditingControllerComment = TextEditingController();
    _textEditingControllerComment.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingControllerName.removeListener(_onTextChanged);
    _textEditingControllerName.dispose();
    _textEditingControllerComment.removeListener(_onTextChanged);
    _textEditingControllerComment.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerName.text.isEmpty;
    });
  }

  void updateFormValidity() {
    setState(() {
      isFormValid =
          validationMessageName == null;
    });
  }

  String calculPrice(int numberAdult, int numberKids) {
    // Retrieve prices
    final prixParVoyageur = widget.experienceData.prixParVoyageur;
    final prixParEnfant = widget.experienceData.prixParEnfant;

    // Check if prixParVoyageur is null
    if (prixParVoyageur == null) {
      return "0"; // Default value if prixParVoyageur is null
    }

    if (widget.experienceData.discountKids == "1") {
      // Check if prixParEnfant is null
      if (prixParEnfant == null) {
        return "0"; // Default value if prixParEnfant is null
      }

      // Parse prices as double and calculate the total
      final total = (double.parse(prixParVoyageur) * numberAdult) +
          (double.parse(prixParEnfant) * numberKids);
      return total.toStringAsFixed(2); // Return the total as a string with two decimal places
    } else {
      // Parse prices as double and calculate the total
      final total = double.parse(prixParVoyageur) * (numberAdult + numberKids);
      return total.toStringAsFixed(2); // Return the total as a string with two decimal places
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Réservation',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(31, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.experienceData.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        fontSize: 20, color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 31,),
                  Text(
                    'Le rendez-vous à lieu au coeur du 7eme arrondissement à proximité du métro Champs de Mars - Tour Eiffel. Le lieu exact sera communiqué après la réservation.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppResources.colorGray),
                  ),
                  const SizedBox(height: 42,),
                  Text(
                    'Nombre de voyageurs',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 24,),
                  if (widget.experienceData.supportGroupPrive == "1")
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groupe Privé',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          Text(
                            'Tu réserves l’expérience pour toi\net ton groupe uniquement.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: isKidsAvailable,
                        activeColor: AppResources.colorVitamine,
                        onChanged: (bool value) {
                          // Update the state immediately without awaiting the async operation
                          setState(() {
                            isKidsAvailable = value;
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adultes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          Text(
                            '12 ans et plus',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _decrementCounter,
                              icon: Icon(Icons.remove,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Text(
                            '$_counter',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _incrementCounter,
                              icon: Icon(Icons.add,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enfants',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          Text(
                            'De 2 ans à 12 ans',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _decrementCounterChild,
                              icon: Icon(Icons.remove,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Text(
                            '$_counterChild',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _incrementCounterChild,
                              icon: Icon(Icons.add,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bébés (Gratuit)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          Text(
                            'Moins de 2 ans',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _decrementCounterBaby,
                              icon: Icon(Icons.remove,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Text(
                            '$_counterBaby',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                              width: ResponsiveSize.calculateWidth(
                                  8, context)),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppResources.colorGray45,
                                width: 1.0,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _incrementCounterBaby,
                              icon: Icon(Icons.add,
                                  color: AppResources.colorGray75),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 46,),
                  Text(
                    'Informations (celui qui réserve)',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppResources.colorDark),
                  ),
                  TextFormField(
                    controller: _textEditingControllerName,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3000),
                    ],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppResources.colorDark),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: 'Ton prénom',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      contentPadding: EdgeInsets.only(
                        top: ResponsiveSize.calculateHeight(20, context),
                        bottom: ResponsiveSize.calculateHeight(10, context),
                      ),
                      // Adjust padding
                      suffix: SizedBox(
                          height:
                          ResponsiveSize.calculateHeight(10, context)),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppResources.colorGray15),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: AppResources.colorGray15),
                      ),
                      errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    //onFieldSubmitted: (value) => validate(),
                    validator: AppResources.validatorNotEmpty,
                    //onSaved: (value) => bloc.name = value,
                    onChanged: (value) {
                      setState(() {
                        validationMessageName =
                            AppResources.validatorNotEmpty(value);
                        updateFormValidity();
                      });
                    },
                  ),
                  const SizedBox(height: 48,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Horaire réservé',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: const Color(0xFF797979)),
                      ),
                      Text(
                        '${dateReservationFormat(widget.date)} ${widget.time.split(" - ")[0].substring(0, 5)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontSize: 14, color: AppResources.colorDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                          Text(
                            calculPrice(_counter, _counterChild),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppResources.colorDark),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final _makeReservation = AppService.api.makeReservation(
                            ReservationRequest(
                              experienceId: int.parse(widget.experienceData.id),
                              dateTime: "${yearsReservationFormat(widget.date)} ${widget.time.split(" - ")[0].substring(0, 5)}",
                              voyageursAdultes: _counter,
                              voyageursEnfants: _counterChild,
                              voyageursBebes: _counterBaby,
                              messageAuGuide: _textEditingControllerComment.text,
                              nom: _textEditingControllerName.text,
                              prenom: _textEditingControllerName.text,
                              phone: "2332342343"
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppResources.colorVitamine,
                        ),
                        child: Text(
                          'Payer et réserver',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorWhite, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 19,),
                  Text(
                    'en cas de modification de la réservation',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 40,),
                  Text(
                    'john.doe@gmail.com',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                        color: AppResources.colorGray30),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width -
                        96,
                    color: AppResources.colorGray15,
                  ),
                  const SizedBox(height: 29,),
                  Text(
                    'Message au guide',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: AppResources.colorDark),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    'Si vous souhaitez adresser une demande particulière au guide, c’est ici !',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 12, color: AppResources.colorGray),
                  ),
                  const SizedBox(height: 22,),
                  Container(
                    width: 309,
                    height: 216,
                    child: TextField(
                      controller: _textEditingControllerComment,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppResources.colorDeactivate,
                            width: 1.0, // Set the border width
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppResources.colorDeactivate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppResources.colorDeactivate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppResources.colorDeactivate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppResources.colorDeactivate,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                      ),
                      maxLines: null, // Allows the TextField to expand vertically
                      expands: true, // Makes the TextField fill the height of its parent Container
                    ),
                  ),
                  const SizedBox(height: 60,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      if (_counter < 10) {
        _counter++;
      }
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 1) {
        _counter--;
      }
    });
  }

  void _incrementCounterChild() {
    setState(() {
      if (_counterChild < 10) {
        _counterChild++;
      }
    });
  }

  void _decrementCounterChild() {
    setState(() {
      if (_counterChild > 0) {
        _counterChild--;
      }
    });
  }

  void _incrementCounterBaby() {
    setState(() {
      if (_counterBaby < 10) {
        _counterBaby++;
      }
    });
  }

  void _decrementCounterBaby() {
    setState(() {
      if (_counterBaby > 0) {
        _counterBaby--;
      }
    });
  }
}
