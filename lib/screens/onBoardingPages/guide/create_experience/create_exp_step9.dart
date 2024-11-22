import 'package:flutter/material.dart';
import 'package:meet_pe/utils/_utils.dart';

import '../../../../resources/resources.dart';
import '../../../../widgets/popup_view.dart';
import 'create_exp_step10.dart';

class CreateExpStep9 extends StatefulWidget {
  CreateExpStep9({super.key, required this.sendListMap});
  Map<String, dynamic> sendListMap = {};

  @override
  State<CreateExpStep9> createState() => _CreateExpStep9State();
}

class _CreateExpStep9State extends State<CreateExpStep9> {
  double valueSlider = 15;
  bool isKidsAvailable = false;
  bool isGroupeAvailable = false;
  int _counter = 3;
  late TextEditingController _textEditingControllerPrice;
  late TextEditingController _textEditingControllerPriceGroup;

  @override
  void initState() {
    super.initState();
    _textEditingControllerPrice = TextEditingController();
    _textEditingControllerPrice.addListener(_onTextChanged);
    _textEditingControllerPriceGroup = TextEditingController();
    _textEditingControllerPriceGroup.addListener(_onTextChanged);
    _textEditingControllerPrice.text = valueSlider.toInt().toString();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingControllerPrice.removeListener(_onTextChanged);
    _textEditingControllerPrice.dispose();
    _textEditingControllerPriceGroup.removeListener(_onTextChanged);
    _textEditingControllerPriceGroup.dispose();
  }

  void _onTextChanged() {
    setState(() {
      //_showButton = _textEditingControllerName.text.isEmpty;
    });
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

  void updatePrice(double value) {
    setState(() {
      valueSlider = value;
      //bloc.updateDuration(value); // Call the method to update duration in bloc
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // FocusScope.of(context).requestFocus(FocusNode()); // Alternative method
          FocusScope.of(context).unfocus(); // Unfocus any focused text input fields
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppResources.colorGray5, AppResources.colorWhite],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'images/backgroundExp6.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                    height: ResponsiveSize.calculateHeight(190, context),
                  ),
                  SizedBox(height: ResponsiveSize.calculateHeight(40, context)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Étape 8 sur 11',
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
                          'Renseigne le prix de ton expérience',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'par personne.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const PopupView(contentTitle: "Soit tu slides soit tu écris ton prix 😃")
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(30, context)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IntrinsicWidth(
                              child: TextFormField(
                                controller: _textEditingControllerPrice,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 16, color: AppResources.colorDark),
                                decoration: InputDecoration(
                                  filled: false,
                                  hintText: '350 €',
                                  hintStyle:
                                  Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: AppResources.colorGray60),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  // Adjust padding
                                  suffix: SizedBox(height: ResponsiveSize.calculateHeight(10, context)),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppResources.colorGray15),
                                  ),
                                  errorBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    double parsedValue = double.tryParse(value) ?? 15; // Default to min value if empty or not a number
                                    valueSlider = parsedValue.clamp(15, 1000); // Ensure value stays within range
                                    //_textEditingControllerPrice.text = valueSlider.toStringAsFixed(2);
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Slider(
                              value: valueSlider,
                              min: 15,
                              max: 1000,
                              //divisions: 20,
                              label: '${valueSlider.round().toString()} €',
                              onChanged: (double value) {
                                setState(() {
                                  valueSlider = value;
                                  _textEditingControllerPrice.text = value.round().toString();
                                  updatePrice(value);
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                            height: ResponsiveSize.calculateHeight(20, context)),
                        Container(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Revenus estimés ${((double.tryParse(_textEditingControllerPrice.text) ?? 0) * 0.82).toStringAsFixed(2)} €/pers',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                              ),
                              const PopupView(contentTitle: 'Revenus estimés, frais de plateforme déduits')
                            ],
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.calculateHeight(23, context)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Réduction 30% enfants 2-12ans',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14, color: AppResources.colorDark),
                                ),
                                const PopupView(contentTitle: "Si tu coches cette case il y aura directement une remise de 30% qui s’appliquera pour les enfants.")
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Prix Groupe Privé',
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14, color: AppResources.colorDark),
                                ),
                                const PopupView(contentTitle: "Ici détermine le prix minimum lié à ton expérience pour un groupe privé ou 1 personne.")
                              ],
                            ),
                            Switch.adaptive(
                              value: isGroupeAvailable,
                              activeColor: AppResources.colorVitamine,
                              onChanged: (bool value) {
                                // Update the state immediately without awaiting the async operation
                                setState(() {
                                  isGroupeAvailable = value;
                                });
                              },
                            )
                          ],
                        ),
                        Visibility(
                          visible: isGroupeAvailable,
                          child: Column(
                            children: [
                              SizedBox(height: ResponsiveSize.calculateHeight(15, context)),
                              Text(
                                'Un voyageur peut réserver l’expérience rien que pour lui et ses proches.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Nombre de personne max.',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(
                                      width: ResponsiveSize.calculateWidth(
                                          16, context)),
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
                              ),
                              SizedBox(height: ResponsiveSize.calculateHeight(9, context)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Prix Groupe Privé',
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  IntrinsicWidth(
                                    child: TextFormField(
                                      controller: _textEditingControllerPriceGroup,
                                      keyboardType: TextInputType.number,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(fontSize: 16, color: AppResources.colorDark),
                                      decoration: InputDecoration(
                                        filled: false,
                                        hintText: '350',
                                        hintStyle:
                                        Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16, color: AppResources.colorGray60),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        // Adjust padding
                                        suffix: SizedBox(height: ResponsiveSize.calculateHeight(10, context)),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppResources.colorGray15),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppResources.colorGray15),
                                        ),
                                        errorBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.red),
                                        ),
                                      ),
                                      textInputAction: TextInputAction.done,
                                      //onFieldSubmitted: (value) => validate(),
                                      validator: AppResources.validatorNotEmpty,
                                      /*onSaved: (value) => bloc.name = value,
                                  onChanged: (value) {
                                    setState(() {
                                      validationMessageName =
                                          AppResources.validatorNotEmpty(value);
                                      updateFormValidity();
                                    });
                                  },*/
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Revenus estimés ${((double.tryParse(_textEditingControllerPriceGroup.text) ?? 0) * 0.82).toStringAsFixed(2)} €/pers',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                                  ),
                                  const PopupView(contentTitle: 'Revenus estimés, frais de plateforme déduits')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
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
                            if(valueSlider<15 || (int.tryParse(_textEditingControllerPrice.text) ?? 15)<15) {
                              showMessage(context, 'Le prix doit minimum 15€');
                            } else {
                              widget.sendListMap['prix_par_voyageur'] = valueSlider.toInt();
                              widget.sendListMap['discount_kids_between_2_and_12'] = isKidsAvailable.toString();
                              widget.sendListMap['support_group_prive'] = isGroupeAvailable.toString();
                              widget.sendListMap['max_number_of_persons'] = _counter.toInt();
                              widget.sendListMap['price_group_prive'] = _textEditingControllerPriceGroup.text;

                              navigateTo(context, (_) => CreateExpStep10(sendListMap: widget.sendListMap));
                            }
                          },
                          child: Image.asset('images/arrowLongRight.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
