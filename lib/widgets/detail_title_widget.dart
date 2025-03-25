import 'package:flutter/material.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';

/// For display Detail page's title
class DetailTitleWidget extends StatelessWidget {
  /// Detail Title Widget constructor
  const DetailTitleWidget({required this.title, super.key});

  /// For display title
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: context.textTheme.titleLarge);
  }
}
