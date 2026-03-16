import 'package:flutter/material.dart';
import 'ui_search.dart';
import 'ui_button.dart';

class UiTableLayout extends StatelessWidget {
  final String title;
  final Widget table;
  final Widget? pagination;
  final Function(String)? onSearch;
  final VoidCallback? onCreate;
  final VoidCallback? onFilter;
  final List<Widget>? actions;

  const UiTableLayout({
    super.key,
    required this.title,
    required this.table,
    this.pagination,
    this.onSearch,
    this.onCreate,
    this.onFilter,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onCreate != null)
              UiButton(
                label: "Create New",
                onPressed: onCreate!,
                icon: Icons.add,
                width: 180,
              ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: UiSearch(onSearch: onSearch),
            ),
            const SizedBox(width: 12),
            if (onFilter != null)
              SizedBox(
                width: 48,
                height: 48,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: onFilter,
                    borderRadius: BorderRadius.circular(8),
                    child: const Icon(Icons.filter_list, color: Colors.grey),
                  ),
                ),
              ),
            if (actions != null) ...actions!,
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(child: table),
                if (pagination != null) pagination!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
