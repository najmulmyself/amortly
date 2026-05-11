import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/section_label.dart';

/// Groups settings rows under an optional section header with iOS grouped-list style.
class SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> rows;
  final bool isDark;

  const SettingsGroup({
    super.key,
    this.title,
    required this.rows,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 0, 6),
            child: SectionLabel(text: title!),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.neutral200,
              width: 0.5,
            ),
          ),
          child: Column(
            children: List.generate(rows.length, (i) {
              return Column(
                children: [
                  rows[i],
                  if (i < rows.length - 1)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      indent: 62,
                      color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
