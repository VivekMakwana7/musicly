import 'package:flutter/material.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';

/// For display Detail page's title
class DetailTitleWidget extends StatelessWidget {
  /// Detail Title Widget constructor
  const DetailTitleWidget({required this.title, super.key, this.maxLines});

  /// For display title
  final String title;

  /// for change maxLine
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.titleLarge, maxLines: maxLines ?? 1, overflow: TextOverflow.ellipsis);
  }
}
