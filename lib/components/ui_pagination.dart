import 'package:flutter/material.dart';
import '../core/models/pagination_meta.dart';
import '../core/theme/app_colors.dart';

class UiPagination extends StatelessWidget {
  final PaginationMeta? meta;
  final Function(int) onPageChanged;

  const UiPagination({
    super.key,
    this.meta,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (meta == null || meta!.lastPage <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: meta!.currentPage > 1 ? () => onPageChanged(meta!.currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 8),
          Text(
            "Page ${meta!.currentPage} of ${meta!.lastPage}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: meta!.currentPage < meta!.lastPage ? () => onPageChanged(meta!.currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
