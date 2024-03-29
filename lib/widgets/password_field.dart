import 'package:meet_pe/resources/_resources.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    Key? key,
    this.hint,
    this.onChanged,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.onSaved,
    this.controller,
  }) : super(key: key);

  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = false;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      controller: widget.controller,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: AppResources.colorDark),
      decoration: InputDecoration(
          hintText: widget.hint ?? 'Ton mot de passe',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          suffix: const SizedBox(height: 10),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _isError ? Color(0xFFFF0000) : AppResources.colorGray15),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: _isError ? Color(0xFFFF0000) : AppResources.colorGray15),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
            child: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
          )),
      obscureText: !_showPassword,
      textInputAction: widget.textInputAction ?? TextInputAction.unspecified,
      autocorrect: false,
      validator: widget.validator ?? AppResources.validatorPassword,
      /*onChanged: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          setState(() {
            _isError = true;
          });
        }
        setState(() {
          _isError = false;
        });
      },*/
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
