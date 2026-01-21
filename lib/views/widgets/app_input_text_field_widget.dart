import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInputTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool leftIcon;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value) onChange;
  final Function(String value) onSubmitted;

  const AppInputTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.leftIcon = false,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    required this.onChange,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      maxLines: maxLines,
      cursorColor: Colors.black,
      keyboardType: keyboardType,
      onChanged: onChange,
      onSubmitted: onSubmitted,
      inputFormatters: inputFormatters,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hint: Text(
          hintText,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        prefixIcon: leftIcon
            ? Container(
                padding: EdgeInsets.only(left: 10, right: 4),
                child: Icon(Icons.search),
              )
            : null,
        prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ), // ✅ center the text
      ),
    );
  }
}
