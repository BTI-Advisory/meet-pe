import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meet_pe/utils/_utils.dart';

import '../../../models/user_response.dart';
import '../../../resources/resources.dart';
import '../../../services/app_service.dart';
import '../../../widgets/_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late TextEditingController _textEditingControllerRue;
  late TextEditingController _textEditingControllerVille;
  late TextEditingController _textEditingControllerZip;
  String? validationMessageFirstName = '';
  String? validationMessageLastName = '';
  String? validationMessagePhoneNumber = '';
  String? validationMessageCurrentPassword = '';
  String? validationMessageNewPassword = '';
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
      appBar: EpAppBar(
        title: AppLocalizations.of(context)!.my_account_text,
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
                          AppLocalizations.of(context)!.info_connection_text,
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
                                                    AppLocalizations.of(context)!.last_first_name_text,
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
                                                          hintText: AppLocalizations.of(context)!.your_name_text,
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
                                                          hintText: AppLocalizations.of(context)!.your_last_name_text,
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
                                                        AppLocalizations.of(context)!.enregister_text,
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
                                                          showMessage(context, AppLocalizations.of(context)!.name_ok_text);
                                                          await Future.delayed(const Duration(seconds: 3));
                                                          await fetchUserInfo();
                                                        } else {
                                                          Navigator.pop(context);
                                                          showMessage(context, AppLocalizations.of(context)!.problem_server_text);
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
                            child: accountRowDefault(AppLocalizations.of(context)!.last_first_name_text, userInfo.name, true)
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
                                                  AppLocalizations.of(context)!.phone_text,
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
                                                        AppLocalizations.of(context)!.enregister_text,
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
                                                        showMessage(context, AppLocalizations.of(context)!.phone_ok_text);
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, AppLocalizations.of(context)!.problem_server_text);
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
                          child: accountRowDefault(AppLocalizations.of(context)!.phone_text, formatPhoneNumber(userInfo.phoneNumber), true),
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
                                                  AppLocalizations.of(context)!.password_text,
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
                                                        hintText: AppLocalizations.of(context)!.actual_password_hint_text,
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
                                                        hintText: AppLocalizations.of(context)!.new_password_hint_text,
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
                                                        AppLocalizations.of(context)!.enregister_text,
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
                                                        showMessage(context, AppLocalizations.of(context)!.password_ok_text);
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, AppLocalizations.of(context)!.problem_server_text);
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
                          child: accountRowDefault(AppLocalizations.of(context)!.password_text, '********', true),
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
                                                  AppLocalizations.of(context)!.address_hint_text,
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
                                                        hintText: AppLocalizations.of(context)!.rue_text,
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
                                                        hintText: AppLocalizations.of(context)!.city_hint_text,
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
                                                        hintText: AppLocalizations.of(context)!.zip_code_hint_text,
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
                                                        AppLocalizations.of(context)!.enregister_text,
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
                                                        showMessage(context, AppLocalizations.of(context)!.address_ok_text);
                                                        await Future.delayed(const Duration(seconds: 3));
                                                        await fetchUserInfo();
                                                      } else {
                                                        Navigator.pop(context);
                                                        showMessage(context, AppLocalizations.of(context)!.problem_server_text,);
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
                          child: accountRowDefault(AppLocalizations.of(context)!.address_hint_text, userInfo.rue, true),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context, (_) => const WebViewContainer(webUrl: 'https://www.meetpe.fr/privacy/'));
                          },
                          child: accountRowDefault(AppLocalizations.of(context)!.security_and_privacy_text, '', true),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.calculateWidth(30, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.my_documents_text,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                              fontSize: 20, color: AppResources.colorDark),
                        ),
                        const SizedBox(height: 17),
                        Text(
                          AppLocalizations.of(context)!.my_documents_desc_text,
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
                            child: accountRowToComplete(AppLocalizations.of(context)!.my_id_text, userInfo.pieceIdentite, false)
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
                            child: accountRowToComplete(AppLocalizations.of(context)!.my_kbis_text, userInfo.kbisFile, false),
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
                            child: accountRowToComplete(AppLocalizations.of(context)!.other_document_text, documentTitle, true)
                        ),
                        const SizedBox(height: 17),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await AppService.api.deleteUser(context);
                      AppService.instance.logOut;
                    },
                    child: Text(
                        AppLocalizations.of(context)!.delete_account_text,
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
                  child: PopupView(contentTitle: AppLocalizations.of(context)!.pop_view_other_document_text)
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
                      AppLocalizations.of(context)!.to_complete_text,
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
