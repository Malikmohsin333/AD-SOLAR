import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class IconField extends StatelessWidget {
  final String label;
  final bool required;
  final IconData icon;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? errorText;
  final GlobalKey? fieldKey;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const IconField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.required = false,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.fieldKey,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;
    return Column(
      key: fieldKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 👈 added
      children: [
        RichText(
          text: TextSpan(
            text: label.toUpperCase(),
            style: TextStyle(
              color: hasError ? Colors.red : AppTheme.labelGrey,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
            children: required
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 3),
        IntrinsicHeight(
          // 👈 added - ye fix karta hai infinite height issue
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: hasError ? Colors.red : AppTheme.borderGrey,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 14,
                  color: hasError ? Colors.red : AppTheme.iconGrey,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppTheme.borderGrey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppTheme.borderGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      borderSide: BorderSide(
                        color: hasError ? Colors.red : AppTheme.navyBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 3, left: 4),
            child: Text(
              errorText!,
              style: const TextStyle(fontSize: 11, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
