import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import 'widgets/saved_item_card.dart';
import 'widgets/empty_saved_state.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  int _segmentIndex = 0; // 0 = Loans, 1 = Scenarios
  String _search = '';

  static const _loans = [
    {
      'label': 'Dream Home',
      'price': '\$450,000',
      'date': 'May 12, 2025',
      'monthly': '\$2,377',
    },
    {
      'label': 'Investment Property',
      'price': '\$550,000',
      'date': 'May 10, 2025',
      'monthly': '\$3,340',
    },
    {
      'label': 'Vacation Home',
      'price': '\$325,000',
      'date': 'May 8, 2025',
      'monthly': '\$1,620',
    },
    {
      'label': 'Refinance Option',
      'price': '\$360,000',
      'date': 'May 5, 2025',
      'monthly': '\$2,204',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filtered = _loans
        .where((l) => l['label']!.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.tabSaved),
        actions: [
          IconButton(
            icon:
                const Icon(CupertinoIcons.line_horizontal_3_decrease, size: 20),
            onPressed: () {},
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Loans / Scenarios segmented control
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _IOSSegmentedControl(
              labels: const ['Loans', 'Scenarios'],
              selectedIndex: _segmentIndex,
              onSelected: (i) => setState(() => _segmentIndex = i),
              isDark: isDark,
            ),
          ),
          const SizedBox(height: 12),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CupertinoSearchTextField(
              placeholder: 'Search saved loans',
              style: TextStyle(
                color: isDark ? AppColors.white : AppColors.neutral900,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: _segmentIndex == 0
                ? filtered.isEmpty
                    ? const EmptySavedState()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (ctx, i) {
                          final loan = filtered[i];
                          return SavedItemCard(
                            label: loan['label']!,
                            price: loan['price']!,
                            date: loan['date']!,
                            monthly: loan['monthly']!,
                          );
                        },
                      )
                : const EmptySavedState(),
          ),
        ],
      ),
      // Add New Loan button
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
            16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand800,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            icon: const Icon(CupertinoIcons.add, size: 18),
            label: const Text(
              '+ Add New Loan',
              style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── iOS segmented control ─────────────────────────────────────────────────

class _IOSSegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool isDark;

  const _IOSSegmentedControl({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : AppColors.neutral100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? AppColors.darkSurface : AppColors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppColors.brand800 : AppColors.neutral500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
