import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class InputRow extends StatefulWidget {
  final String label;
  final String value;
  final String? prefix;
  final String? suffix;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool embedded;

  const InputRow({
    super.key,
    required this.label,
    required this.value,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    this.readOnly = false,
    this.embedded = false,
  });

  @override
  State<InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.text = widget.value;
      }
    });
  }

  @override
  void didUpdateWidget(InputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: widget.embedded
          ? null
          : BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.white,
              border: Border(bottom: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.neutral200,
              )),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label.toUpperCase(), style: AppTextStyles.inputLabel),
          const SizedBox(height: 4),
          Row(
            children: [
              if (widget.prefix != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(widget.prefix!, style: AppTextStyles.inputPrefix),
                ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  keyboardType: widget.keyboardType,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  style: AppTextStyles.inputValue,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: widget.onChanged,
                ),
              ),
              if (widget.suffix != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(widget.suffix!, style: AppTextStyles.inputSuffix),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
