import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meet_pe/utils/_utils.dart';

import '../../../models/user_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../widgets/_widgets.dart';

// Define the callback function type
typedef ImagePathCallback = void Function(String);

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key,});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late TextEditingController _textEditingControllerFirstName;
  late TextEditingController _textEditingControllerLastName;
  late TextEditingController _textEditingControllerPhoneNumber;
  late TextEditingController _textEditingControllerCurrentPassword;
  late TextEditingController _textEditingControllerNewPassword;
  late TextEditingController _textEditingControllerIBAN;
  late TextEditingController _textEditingControllerBIC;
  late TextEditingController _textEditingControllerNameTitulaire;
  late TextEditingController _textEditingControllerRue;
  late TextEditingController _textEditingControllerVille;
  late TextEditingController _textEditingControllerZip;
  String? validationMessageFirstName = '';
  String? validationMessageLastName = '';
  String? validationMessagePhoneNumber = '';
  String? validationMessageCurrentPassword = '';
  String? validationMessageNewPassword = '';
  String? validationMessageIBAN = '';
  String? validationMessageBIC = '';
  String? validationMessageNameTitulaire = '';
  String? validationMessageRue = '';
  String? validationMessageVille = '';
  String? validationMessageZip = '';
  bool isFormValid = false;
  String selectedImagePath = '';

  bool imageSize = false;
  late Future<UserResponse> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    _textEditingControllerFirstName = TextEditingController();
    _textEditingControllerFirstName.addListener(_onTextChanged);
    _textEditingControllerLastName = TextEditingController();
    _textEditingControllerLastName.addListener(_onTextChanged);
    _textEditingControllerPhoneNumber = TextEditingController();
    _textEditingControllerPhoneNumber.addListener(_onTextChanged);
    _textEditingControllerCurrentPassword = TextEditingController();
    _textEditingControllerCurrentPassword.addListener(_onTextChanged);
    _textEditingControllerNewPassword = TextEditingController();
    _textEditingControllerNewPassword.addListener(_onTextChanged);
    _textEditingControllerIBAN = TextEditingController();
    _textEditingControllerIBAN.addListener(_onTextChanged);
    _textEditingControllerBIC = TextEditingController();
    _textEditingControllerBIC.addListener(_onTextChanged);
    _textEditingControllerNameTitulaire = TextEditingController();
    _textEditingControllerNameTitulaire.addListener(_onTextChanged);
    _textEditingControllerRue = TextEditingController();
    _textEditingControllerRue.addListener(_onTextChanged);
    _textEditingControllerVille = TextEditingController();
    _textEditingControllerVille.addListener(_onTextChanged);
    _textEditingControllerZip = TextEditingController();
    _textEditingControllerZip.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingControllerFirstName.removeListener(_onTextChanged);
    _textEditingControllerFirstName.dispose();
    _textEditingControllerLastName.removeListener(_onTextChanged);
    _textEditingControllerLastName.dispose();
    _textEditingControllerPhoneNumber.removeListener(_onTextChanged);
    _textEditingControllerPhoneNumber.dispose();
    _textEditingControllerCurrentPassword.removeListener(_onTextChanged);
    _textEditingControllerCurrentPassword.dispose();
    _textEditingControllerNewPassword.removeListener(_onTextChanged);
    _textEditingControllerNewPassword.dispose();
    _textEditingControllerIBAN.removeListener(_onTextChanged);
    _textEditingControllerIBAN.dispose();
    _textEditingControllerBIC.removeListener(_onTextChanged);
    _textEditingControllerBIC.dispose();
    _textEditingControllerNameTitulaire.removeListener(_onTextChanged);
    _textEditingControllerNameTitulaire.dispose();
    _textEditingControllerRue.removeListener(_onTextChanged);
    _textEditingControllerRue.dispose();
    _textEditingControllerVille.removeListener(_onTextChanged);
    _textEditingControllerVille.dispose();
    _textEditingControllerZip.removeListener(_onTextChanged);
    _textEditingControllerZip.dispose();
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
          validationMessageFirstName == null && validationMessageLastName == null;
    });
  }

  Future<void> fetchUserInfo() async {
    try {
      setState(() {
        _userInfoFuture = AppService.api.getUserInfo();
      });
    } catch (e) {
      // Handle error
      print('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EpAppBar(
        title: 'Mon Compte',
      ),
      body: FutureBuilder<UserResponse>(
        future: _userInfoFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userInfo = snapshot.data!;
            String documentTitle = '';

            if (userInfo.otherDocument != null && userInfo.otherDocument!.isNotEmpty) {
              documentTitle = userInfo.otherDocument![0].documentTitle ?? 'No Title Available';
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.calculateWidth(26, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informations de connexion',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        ///Update name
                        InkWell(
                            onTap: () async {
                              final result = await showModalBottomSheet<bool>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Container(
                                            width: double.infinity,
                                            height: 357,
                                            color: AppResources.colorWhite,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 28),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
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
                                                  Text(
                                                    'Nom & Prénom',
                                                    style: Theme.of(context).textTheme.headlineMedium,
                                                  ),
                                                  Column(
                                                    children: [
                                                      TextFormField(
                                                        controller: _textEditingControllerFirstName,
                                                        keyboardType: TextInputType.name,
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
                                                              bottom:
                                                              ResponsiveSize.calculateHeight(10, context)),
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
                                                        ),
                                                        textInputAction: TextInputAction.done,
                                                        //onFieldSubmitted: (value) => validate(),
                                                        validator: AppResources.validatorNotEmpty,
                                                        //onSaved: (value) => bloc.name = value,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            validationMessageFirstName =
                                                                AppResources.validatorNotEmpty(value);
                                                            updateFormValidity();
                                                          });
                                                        },
                                                      ),
                                                      const SizedBox(height: 40),
                                                      TextFormField(
                                                        controller: _textEditingControllerLastName,
                                                        keyboardType: TextInputType.name,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(color: AppResources.colorDark),
                                                        decoration: InputDecoration(
                                                          filled: false,
                                                          hintText: 'Ton nom',
                                                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                          contentPadding: EdgeInsets.only(
                                                              top: ResponsiveSize.calculateHeight(20, context),
                                                              bottom:
                                                              ResponsiveSize.calculateHeight(10, context)),
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
                                                        ),
                                                        textInputAction: TextInputAction.done,
                                                        //onFieldSubmitted: (value) => validate(),
                                                        validator: AppResources.validatorNotEmpty,
                                                        //onSaved: (value) => bloc.name = value,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            validationMessageLastName =
                                                                AppResources.validatorNotEmpty(value);
                                                            updateFormValidity();
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 53),
                                                  Container(
                                                    width: ResponsiveSize.calculateWidth(319, context),
                                                    height: ResponsiveSize.calculateHeight(44, context),
                                                    child: TextButton(
                                                      style: ButtonStyle(
                                                        padding:
                                                        MaterialStateProperty.all<EdgeInsets>(
                                                            EdgeInsets.symmetric(
                                                                horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                        backgroundColor: MaterialStateProperty.all(
                                                            Colors.transparent),
                                                        shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            side: BorderSide(width: 1, color: AppResources.colorDark),
                                                            borderRadius: BorderRadius.circular(40),
                                                          ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'ENREGISTRER',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(color: AppResources.colorDark),
                                                      ),
                                                      onPressed: () async {
                                                        // Call the asynchronous operation and handle its completion
                                                        final result = AppService.api.updateName(_textEditingControllerFirstName.text, _textEditingControllerLastName.text);
                                                        if (await result) {
                                                          Navigator.pop(context);
                                                          showMessage(context, 'Nom ✅');
                                                          await Future.delayed(const Duration(seconds: 3));
                                                          await fetchUserInfo();
                                                        } else {
                                                          Navigator.pop(context);
                                                          showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                            child: accountRowDefault('Nom & prénom', userInfo.name, true)
                        ),
                        ///Update phone number
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          width: double.infinity,
                                          height: 301,
                                          color: AppResources.colorWhite,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 28),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
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
                                                Text(
                                                  'Numéro de téléphone',
                                                  style: Theme.of(context).textTheme.headlineMedium,
                                                ),
                                                Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: _textEditingControllerPhoneNumber,
                                                      keyboardType: TextInputType.phone,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: userInfo.phoneNumber,
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorNotEmpty,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessagePhoneNumber =
                                                              AppResources.validatorNotEmpty(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 53),
                                                Container(
                                                  width: ResponsiveSize.calculateWidth(319, context),
                                                  height: ResponsiveSize.calculateHeight(44, context),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                      MaterialStateProperty.all<EdgeInsets>(
                                                          EdgeInsets.symmetric(
                                                              horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                      backgroundColor: MaterialStateProperty.all(
                                                          Colors.transparent),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: AppResources.colorDark),
                                                          borderRadius: BorderRadius.circular(40),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'ENREGISTRER',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(color: AppResources.colorDark),
                                                    ),
                                                    onPressed: () async {
                                                      // Call the asynchronous operation and handle its completion
                                                      final result = AppService.api.updatePhone(_textEditingControllerPhoneNumber.text);
                                                      if (await result) {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Numero de téléphone ✅');
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                            );
                          },
                          child: accountRowDefault('Numéro de téléphone', formatPhoneNumber(userInfo.phoneNumber), true),
                        ),
                        accountRowDefault('e-mail', userInfo.email, false),
                        ///Update password
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          width: double.infinity,
                                          height: 357,
                                          color: AppResources.colorWhite,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 28),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
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
                                                Text(
                                                  'Mot de passe',
                                                  style: Theme.of(context).textTheme.headlineMedium,
                                                ),
                                                Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: _textEditingControllerCurrentPassword,
                                                      keyboardType: TextInputType.visiblePassword,
                                                      obscureText: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: 'Mot de passe actuel',
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorPassword,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessageCurrentPassword =
                                                              AppResources.validatorPassword(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 40),
                                                    TextFormField(
                                                      controller: _textEditingControllerNewPassword,
                                                      keyboardType: TextInputType.visiblePassword,
                                                      obscureText: true,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: 'Nouveau mot de passe',
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorPassword,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessageNewPassword =
                                                              AppResources.validatorPassword(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 53),
                                                Container(
                                                  width: ResponsiveSize.calculateWidth(319, context),
                                                  height: ResponsiveSize.calculateHeight(44, context),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                      MaterialStateProperty.all<EdgeInsets>(
                                                          EdgeInsets.symmetric(
                                                              horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                      backgroundColor: MaterialStateProperty.all(
                                                          Colors.transparent),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: AppResources.colorDark),
                                                          borderRadius: BorderRadius.circular(40),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'ENREGISTRER',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(color: AppResources.colorDark),
                                                    ),
                                                    onPressed: () async {
                                                      // Call the asynchronous operation and handle its completion
                                                      final result = AppService.api.updatePassword(_textEditingControllerCurrentPassword.text, _textEditingControllerNewPassword.text);
                                                      if (await result) {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Mot de passe ✅');
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                            );
                          },
                          child: accountRowDefault('mot de passe', '********', true),
                        ),
                        ///Update address
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Container(
                                          width: double.infinity,
                                          height: 432,
                                          color: AppResources.colorWhite,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 28),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
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
                                                Text(
                                                  'Adresse',
                                                  style: Theme.of(context).textTheme.headlineMedium,
                                                ),
                                                Column(
                                                  children: [
                                                    TextFormField(
                                                      controller: _textEditingControllerRue,
                                                      keyboardType: TextInputType.streetAddress,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: 'rue',
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorNotEmpty,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessageRue =
                                                              AppResources.validatorNotEmpty(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 40),
                                                    TextFormField(
                                                      controller: _textEditingControllerVille,
                                                      keyboardType: TextInputType.name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: 'Ville',
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorNotEmpty,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessageVille =
                                                              AppResources.validatorNotEmpty(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 40),
                                                    TextFormField(
                                                      controller: _textEditingControllerZip,
                                                      keyboardType: TextInputType.number,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(color: AppResources.colorDark),
                                                      decoration: InputDecoration(
                                                        filled: false,
                                                        hintText: 'Code Postal',
                                                        hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                        contentPadding: EdgeInsets.only(
                                                            top: ResponsiveSize.calculateHeight(20, context),
                                                            bottom:
                                                            ResponsiveSize.calculateHeight(10, context)),
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
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      //onFieldSubmitted: (value) => validate(),
                                                      validator: AppResources.validatorNotEmpty,
                                                      //onSaved: (value) => bloc.name = value,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validationMessageZip =
                                                              AppResources.validatorNotEmpty(value);
                                                          updateFormValidity();
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 53),
                                                Container(
                                                  width: ResponsiveSize.calculateWidth(319, context),
                                                  height: ResponsiveSize.calculateHeight(44, context),
                                                  child: TextButton(
                                                    style: ButtonStyle(
                                                      padding:
                                                      MaterialStateProperty.all<EdgeInsets>(
                                                          EdgeInsets.symmetric(
                                                              horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                      backgroundColor: MaterialStateProperty.all(
                                                          Colors.transparent),
                                                      shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          side: BorderSide(width: 1, color: AppResources.colorDark),
                                                          borderRadius: BorderRadius.circular(40),
                                                        ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'ENREGISTRER',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(color: AppResources.colorDark),
                                                    ),
                                                    onPressed: () async {
                                                      // Call the asynchronous operation and handle its completion
                                                      final result = AppService.api.updateAddressInfo(_textEditingControllerRue.text, _textEditingControllerVille.text, _textEditingControllerZip.text);
                                                      if (await result) {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Adresse ✅');
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                            );
                          },
                          child: accountRowDefault('adresse', userInfo.rue, true),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context, (_) => const WebViewContainer(webUrl: 'https://www.meetpe.fr/privacy/'));
                          },
                          child: accountRowDefault('sécurité & vie privée', '', true),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Informations bancaires',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    width: double.infinity,
                                    height: 452,
                                    color: AppResources.colorWhite,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 28),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(height: 39),
                                          Text(
                                            'Informations bancaires',
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.lock, size: 17, color: AppResources.colorGray30,),
                                              SizedBox(width: 4,),
                                              Flexible(
                                                child: Text(
                                                  'Pour recevoir tes paiements en toute sécurité, renseigne ici ton RIB 😃',
                                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppResources.colorGray, fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Visibility(
                                            visible: userInfo.IBAN == null,
                                            child: Container(
                                              width: 73,
                                              height: 21,
                                              alignment: Alignment.center,
                                              decoration: ShapeDecoration(
                                                color: Color(0xFFFFECAB),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Text(
                                                'à compléter',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xFFC89C00)),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                controller: _textEditingControllerIBAN,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: userInfo.IBAN ?? 'IBAN',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
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
                                                ),
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageIBAN =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              TextFormField(
                                                controller: _textEditingControllerBIC,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: userInfo.BIC ?? 'BIC',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
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
                                                ),
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageBIC =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 20),
                                              TextFormField(
                                                controller: _textEditingControllerNameTitulaire,
                                                keyboardType: TextInputType.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(color: AppResources.colorDark),
                                                decoration: InputDecoration(
                                                  filled: false,
                                                  hintText: userInfo.nomDuTitulaire ?? 'Nom du titulaire du compte',
                                                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                                                  contentPadding: EdgeInsets.only(
                                                      top: ResponsiveSize.calculateHeight(20, context),
                                                      bottom:
                                                      ResponsiveSize.calculateHeight(10, context)),
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
                                                ),
                                                textInputAction: TextInputAction.done,
                                                //onFieldSubmitted: (value) => validate(),
                                                validator: AppResources.validatorNotEmpty,
                                                //onSaved: (value) => bloc.name = value,
                                                onChanged: (value) {
                                                  setState(() {
                                                    validationMessageNameTitulaire =
                                                        AppResources.validatorNotEmpty(value);
                                                    updateFormValidity();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 24),
                                          Container(
                                            width: ResponsiveSize.calculateWidth(319, context),
                                            height: ResponsiveSize.calculateHeight(44, context),
                                            child: TextButton(
                                              style: ButtonStyle(
                                                padding:
                                                MaterialStateProperty.all<EdgeInsets>(
                                                    EdgeInsets.symmetric(
                                                        horizontal: ResponsiveSize.calculateWidth(24, context), vertical: ResponsiveSize.calculateHeight(12, context))),
                                                backgroundColor: MaterialStateProperty.all(
                                                    Colors.transparent),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    side: BorderSide(width: 1, color: AppResources.colorDark),
                                                    borderRadius: BorderRadius.circular(40),
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                'ENREGISTRER',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(color: AppResources.colorDark),
                                              ),
                                              onPressed: () async {
                                                // Call the asynchronous operation and handle its completion
                                                final result = AppService.api.updateBankInfo(_textEditingControllerIBAN.text, _textEditingControllerBIC.text, _textEditingControllerNameTitulaire.text);
                                                if (await result) {
                                                  Navigator.pop(context);
                                                  showMessage(context, 'Informations bancaires ✅');
                                                  await Future.delayed(const Duration(seconds: 3));
                                                  await fetchUserInfo();
                                                } else {
                                                  Navigator.pop(context);
                                                  showMessage(context, 'Problème de connexion avec le serveur, veuillez réessayer ultérieurement');
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(25, context)),
                          child: accountRowToComplete('Informations de compte bancaire', userInfo.IBAN, false),
                        ),
                        const SizedBox(height: 19),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(30, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mes documents',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          'Renseigne ici les documents qui sont nécessaires au bon fonctionnement de ton activité.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppResources.colorGray30),
                        ),
                        const SizedBox(height: 17),
                        InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return IdCardWidget(onFetchUserInfo: fetchUserInfo);
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                            child: accountRowToComplete('Ma pièce d’identité', userInfo.pieceIdentite, false)
                        ),
                        const SizedBox(height: 17),
                        if (userInfo.sirenNumber != null) ...[
                          InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context, StateSetter setState) {
                                          return KbisWidget(onFetchUserInfo: fetchUserInfo);
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                            child: accountRowToComplete('Mon KBIS', userInfo.kbisFile, false),
                          ),
                          const SizedBox(height: 17),
                        ],
                        InkWell(
                            onTap: () {
                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return OtherDocumentWidget(onFetchUserInfo: fetchUserInfo);
                                        },
                                      ),
                                    );
                                  }
                              );
                            },
                            child: accountRowToComplete('Autres documents', documentTitle, true)
                        ),
                        const SizedBox(height: 17),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await AppService.api.deleteUser();
                      AppService.instance.logOut;
                    },
                    child: Text(
                        'Supprimer mon compte',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500, color: AppResources.colorGray30)
                    ),
                  ),
                  const SizedBox(height: 65),
                ],
              ),
            );
          }
        }
      ),
    );
  }

  Widget accountRowDefault(String name, String? info, bool modify) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark),
            ),
            Row(
              children: [
                Text(
                  info ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400, color: modify ? AppResources.colorDark : Color(0xFFBBBBBB)),
                ),
                Visibility(
                  visible: modify,
                  child: Image.asset('images/chevron_right.png',
                      width: 27, height: 27, fit: BoxFit.fill),
                ),
              ],
            ),
          ],
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

  Widget accountRowToComplete(String name, String? info, bool tooltip) {
    return Column(
      children: [
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppResources.colorDark, fontSize: 12),
                ),
                Visibility(
                  visible: tooltip,
                  child: const PopupView(contentTitle: "Ici tu vas pouvoir nous transmettre tous les documents spécifiques liés à la pratique de ton expérience: \nPermis bateaux, moto, voitures, ou d’avion de chasse 😜 🚀\nTes licences \nTes assurances")
                ),
              ]
            ),
            Row(
              children: [
                Visibility(
                  visible: info == null || info == '',
                  child: Container(
                    width: 73,
                    height: 21,
                    alignment: Alignment.center,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFECAB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'à compléter',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 10, fontWeight: FontWeight.w400, color: const Color(0xFFC89C00)),
                    ),
                  ),
                ),
                if (info != null && info != '')
                  Row(
                    children: [
                      SvgPicture.asset('images/icon_done.svg'),
                      const SizedBox(width: 20,)
                    ],
                  ),

                Image.asset('images/chevron_right.png',
                    width: 27, height: 27, fit: BoxFit.fill),
              ],
            ),
          ],
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
