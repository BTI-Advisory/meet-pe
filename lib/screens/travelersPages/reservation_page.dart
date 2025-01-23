import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../models/experience_model.dart';
import '../../models/reservation_request.dart';
import '../../models/user_response.dart';
import '../../resources/resources.dart';
import '../../services/app_service.dart';
import '../../services/stripe_payment_handle.dart';
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
  UserResponse? _userInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _controller = AnimationController(vsync: this);
    _textEditingControllerName = TextEditingController();
    _textEditingControllerName.addListener(_onTextChanged);
    _textEditingControllerComment = TextEditingController();
    _textEditingControllerComment.addListener(_onTextChanged);
  }

  Future<void> _loadUserInfo() async {
    try {
      _userInfo = await AppService.api.getUserInfo();
      // Populate the TextEditingController with the user's name
      if (_userInfo?.name != null) {
        _textEditingControllerName.text = _userInfo!.name;
      }

      setState(() {}); // Update the UI if needed
      // Use userInfo data as needed
    } catch (error) {
      print('Error: $error');
    }
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      'Le rendez-vous à lieu au ${widget.experienceData.ville}-${widget.experienceData.codePostal}. Le lieu exact sera communiqué après la réservation.',
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
                              'Tu réserves l’expérience pour toi\net ton groupe uniquement (${widget.experienceData.maxNbVoyageur} personnes).',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: isGroupeAvailable,
                          activeColor: AppResources.colorVitamine,
                          onChanged: (bool value) {
                            // Update the state immediately without awaiting the async operation
                            setState(() {
                              isGroupeAvailable = value;
                              _counter = int.parse(widget.experienceData.maxNbVoyageur!);
                              _counterChild = 0;
                              _counterBaby = 0;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    buildCounterRow(
                      title: 'Adultes',
                      subtitle: '12 ans et plus',
                      count: _counter,
                      onIncrement: () => _incrementCounter(),
                      onDecrement: () => _decrementCounter(),
                      isEnabled: !isGroupeAvailable,
                    ),
                    const SizedBox(height: 16),
                    buildCounterRow(
                      title: 'Enfants',
                      subtitle: 'De 2 ans à 12 ans',
                      count: _counterChild,
                      onIncrement: () => _incrementCounterChild(),
                      onDecrement: () => _decrementCounterChild(),
                      isEnabled: !isGroupeAvailable,
                    ),
                    const SizedBox(height: 16),
                    buildCounterRow(
                      title: 'Bébés (Gratuit)',
                      subtitle: 'Moins de 2 ans',
                      count: _counterBaby,
                      onIncrement: () => _incrementCounterBaby(),
                      onDecrement: () => _decrementCounterBaby(),
                      isEnabled: !isGroupeAvailable,
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
                              isGroupeAvailable
                                  ? '${calculPrice(_counter, _counterChild)} €'
                                  : '${calculPrice(_counter, _counterChild)} €',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(color: AppResources.colorDark),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if(_textEditingControllerName.text == '') {
                              showMessage(context, 'Il manque ton nom 😀');
                            } else {
                              final double price = isGroupeAvailable
                                  ? double.parse(widget.experienceData.prixParGroup.toString())
                                  : double.parse(calculPrice(_counter, _counterChild));

                              final reservationResponse = await AppService.api.makeReservation(
                                ReservationRequest(
                                    experienceId: int.parse(widget.experienceData.id),
                                    dateTime: "${yearsReservationFormat(widget.date)} ${widget.time.split(" - ")[0].substring(0, 5)}",
                                    voyageursAdultes: _counter,
                                    voyageursEnfants: _counterChild,
                                    voyageursBebes: _counterBaby,
                                    messageAuGuide: _textEditingControllerComment.text,
                                    prenom: _textEditingControllerName.text,
                                    isGroup: isGroupeAvailable,
                                    price: price
                                ),
                              );
                              if (reservationResponse.error != null) {
                                debugPrint('Reservation failed: ${reservationResponse.error}');
                                showMessage(context, reservationResponse.error!);
                              } else {
                                final billingDetails = BillingDetails(
                                  name: _userInfo?.name,
                                  email: _userInfo?.email,
                                  phone: _userInfo?.phoneNumber.substring(1),
                                  address: Address(
                                    city: _userInfo?.ville,
                                    country: 'FR',
                                    line1: _userInfo?.rue,
                                    line2: '',
                                    postalCode: _userInfo?.codePostal,
                                    state: _userInfo?.ville,
                                  ),
                                );
                                final stripePaymentHandle = StripePaymentHandle();
                                stripePaymentHandle.stripeMakePayment(
                                  clientSecret: reservationResponse.clientSecret!,
                                  billingDetails: billingDetails,
                                  context: context,
                                );
                                debugPrint('Reservation successful! Client Secret: ${reservationResponse.clientSecret}');
                              }
                            }
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

  Widget buildCounterRow({
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
    bool isEnabled = true,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppResources.colorDark),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
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
                onPressed: isEnabled ? onDecrement : null,
                icon: Icon(Icons.remove,
                    color: isEnabled
                        ? AppResources.colorGray75
                        : AppResources.colorGray45),
              ),
            ),
            SizedBox(width: ResponsiveSize.calculateWidth(8, context)),
            Text(
              '$count',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 16),
            ),
            SizedBox(width: ResponsiveSize.calculateWidth(8, context)),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppResources.colorGray45,
                  width: 1.0,
                ),
              ),
              child: IconButton(
                onPressed: isEnabled ? onIncrement : null,
                icon: Icon(Icons.add,
                    color: isEnabled
                        ? AppResources.colorGray75
                        : AppResources.colorGray45),
              ),
            ),
          ],
        )
      ],
    );
  }
}
