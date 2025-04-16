import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/_utils.dart';
import '../../../resources/resources.dart';
import '../../../widgets/popup_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditPricePage extends StatefulWidget {
  const EditPricePage({super.key});

  @override
  State<EditPricePage> createState() => _EditPricePageState();
}

class _EditPricePageState extends State<EditPricePage> {
  late TextEditingController _textEditingControllerPrice;
  late TextEditingController _textEditingControllerPriceGroup;
  String? validationMessagePrice = '';
  double valueSlider = 15;
  bool isKidsAvailable = false;
  bool isGroupeAvailable = false;
  int _counter = 3;

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
    _textEditingControllerPrice.removeListener(_onTextChanged);
    _textEditingControllerPrice.dispose();
    _textEditingControllerPriceGroup.removeListener(_onTextChanged);
    _textEditingControllerPriceGroup.dispose();
    super.dispose();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF3F3F3), Colors.white],
              stops: [0.0, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 48),
                  SizedBox(
                    width: ResponsiveSize.calculateWidth(24, context),
                    height: ResponsiveSize.calculateHeight(24, context),
                    child: FloatingActionButton(
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
                          fontFamily: CupertinoIcons.exclamationmark_circle.fontFamily,
                          package: CupertinoIcons.exclamationmark_circle.fontPackage,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  Text(
                    AppLocalizations.of(context)!.step_8_title_text,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.step_8_desc_text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
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
                          onChanged: (value) {
                            setState(() {
                              double parsedValue = double.tryParse(value) ?? 15; // Default to min value if empty or not a number
                              valueSlider = parsedValue.clamp(15, 1000); // Ensure value stays within range
                              //_textEditingControllerPrice.text = valueSlider.toStringAsFixed(2);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.enter_value_text;
                            }
                            return null;
                          },
                        ),
                      ),
                      Slider(
                        value: valueSlider,
                        min: 15,
                        max: 1000,
                        //divisions: 10,
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
                          '${AppLocalizations.of(context)!.estimate_income_text} ${((double.tryParse(_textEditingControllerPrice.text) ?? 0) * 0.80).toStringAsFixed(2)} €/pers',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                        ),
                        PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_estimate_income_text)
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
                            AppLocalizations.of(context)!.discount_kids_text,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14, color: AppResources.colorDark),
                          ),
                          PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_discount_text)
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
                            AppLocalizations.of(context)!.price_group_text,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 14, color: AppResources.colorDark),
                          ),
                          PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_price_group_text)
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
                          AppLocalizations.of(context)!.price_group_desc_text,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorGray60),
                        ),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.max_person_text,
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
                              AppLocalizations.of(context)!.price_group_text,
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
                              '${AppLocalizations.of(context)!.estimate_income_text} ${((double.tryParse(_textEditingControllerPriceGroup.text) ?? 0) * 0.80).toStringAsFixed(2)} €/pers',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: AppResources.colorGray60),
                            ),
                            PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_estimate_income_text)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40), // Additional space to account for button
                  // Bottom button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20), // Add some bottom margin for padding
                      child: SizedBox(
                        width: ResponsiveSize.calculateWidth(319, context),
                        height: ResponsiveSize.calculateHeight(44, context),
                        child: TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    horizontal: ResponsiveSize.calculateWidth(24, context),
                                    vertical: ResponsiveSize.calculateHeight(12, context))),
                            backgroundColor: MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: BorderSide(width: 1, color: AppResources.colorDark),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.enregister_text,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorDark),
                          ),
                          onPressed: () {
                            if(!isGroupeAvailable) {
                              if(isKidsAvailable) {
                                Navigator.pop(context, {
                                  'prix_par_voyageur': int.parse(_textEditingControllerPrice.text),
                                  'discount_kids_between_2_and_12': 1,
                                });
                              } else {
                                Navigator.pop(context, {
                                  'prix_par_voyageur': int.parse(_textEditingControllerPrice.text),
                                  'discount_kids_between_2_and_12': 0,
                                });
                              }
                            } else {
                              if(isKidsAvailable) {
                                Navigator.pop(context, {
                                  'prix_par_voyageur': int.parse(_textEditingControllerPrice.text),
                                  'discount_kids_between_2_and_12': 1,
                                  'support_group_prive': 1,
                                  'max_group_size': _counter,
                                  'price_group_prive': int.parse(_textEditingControllerPriceGroup.text)
                                });
                              } else {
                                Navigator.pop(context, {
                                  'prix_par_voyageur': int.parse(_textEditingControllerPrice.text),
                                  'discount_kids_between_2_and_12': 0,
                                  'support_group_prive': 1,
                                  'max_group_size': _counter,
                                  'price_group_prive': int.parse(_textEditingControllerPriceGroup.text)
                                });
                              }
                            }
                          },
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