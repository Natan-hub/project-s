import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoUserSenha extends StatelessWidget {
  final String? mascara;
  final TextEditingController? controller;
  final String? labelText;
  final String? initialValue;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function(String? text)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final String? hintText;
  final bool readOnly;
  final EdgeInsetsGeometry padding;
  final TextStyle? hintStyle;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Color? fillColor;
  final int? maxLength;

  const CampoUserSenha({
    super.key,
    this.textInputAction,
    this.maxLength,
    this.fillColor = Colors.white,
    required this.padding,
    this.initialValue,
    this.focusNode,
    required this.readOnly,
    this.hintStyle,
    this.mascara,
    this.hintText,
    this.inputFormatters,
    this.onTap,
    this.controller,
    this.onFieldSubmitted,
    this.labelText,
    required this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        maxLength: maxLength,
        initialValue: initialValue,
        focusNode: focusNode,
        textInputAction: textInputAction,
        readOnly: readOnly,
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: onFieldSubmitted,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        onChanged: onChanged,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          counterText: '',
          hintStyle: hintStyle,
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: fillColor,
          labelText: labelText,
          filled: true,
        ),
      ),
    );
  }
}
