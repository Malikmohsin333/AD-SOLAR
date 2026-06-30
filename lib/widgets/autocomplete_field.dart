import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AutocompleteField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> suggestions;
  final ValueChanged<String>? onSelected;

  const AutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.suggestions,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(color: AppTheme.labelGrey, fontSize: 10, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        RawAutocomplete<String>(
          textEditingController: controller,
          focusNode: FocusNode(),
          optionsBuilder: (TextEditingValue textValue) {
            if (textValue.text.length < 2) return const Iterable<String>.empty();
            return suggestions.where((s) =>
                s.toLowerCase().contains(textValue.text.toLowerCase()));
          },
          onSelected: (selection) {
            controller.text = selection;
            if (onSelected != null) onSelected!(selection);
          },
          fieldViewBuilder: (context, fieldController, focusNode, onSubmit) {
            return TextField(
              controller: fieldController,
              focusNode: focusNode,
              style: const TextStyle(fontSize: 12, color: Colors.black),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                hintText: '______________________',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: AppTheme.borderGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: AppTheme.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: AppTheme.navyBlue, width: 1.5),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150, minWidth: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          child: Text(option, style: const TextStyle(fontSize: 11)),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}