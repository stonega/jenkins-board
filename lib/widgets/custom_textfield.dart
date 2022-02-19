import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/extensions.dart';

class InputWrapper extends StatelessWidget {
  final String title;
  final Widget inputBox;
  final String? error;
  final double horizontalPadding;
  const InputWrapper(
      {required this.title,
      required this.inputBox,
      this.error,
      this.horizontalPadding = 30,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.bodyText1
                .copyWith(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 50),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      width: 1,
                      color: error != null && error!.isNotEmpty
                          ? const Color(0xFFFF2210).withOpacity(0.5)
                          : context.primaryColorLight),
                  color: context.primaryColorLight),
              child: inputBox,
            ),
          ),
          if (error != null && error!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Transform.rotate(
                      angle: math.pi,
                      child: const Icon(
                        Icons.info,
                        size: 14,
                        color: Color(0xFFFAAD14),
                      )),
                  const SizedBox(width: 4),
                  Text(
                    error!,
                    style: context.sutitle1,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeHolder;
  final TextInputType? inputType;
  final int? maxLines;
  final bool? autofocus;
  final bool obscureText;
  const CustomTextField(
      {required this.controller,
      required this.placeHolder,
      this.inputType,
      this.maxLines,
      this.autofocus,
      this.obscureText = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorWidth: 2,
      autofocus: autofocus ?? true,
      controller: controller,
      cursorColor: context.accentColor,
      cursorHeight: 20,
      maxLines: maxLines ?? 1,
      minLines: 1,
      style: context.bodyText1,
      keyboardType: inputType ?? TextInputType.name,
      decoration: InputDecoration.collapsed(
        hintText: placeHolder,
        hintStyle: const TextStyle(
          color: Color(0xFFB4BEC8),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
