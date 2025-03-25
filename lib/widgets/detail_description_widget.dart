import 'package:flutter/material.dart';
import 'package:musicly/core/extensions/ext_build_context.dart';

/// For display Detail page's description
class DetailDescriptionWidget extends StatelessWidget {
  /// Detail Description Widget constructor
  const DetailDescriptionWidget({required this.description, super.key});

  /// For display description
  final String description;

  @override
  Widget build(BuildContext context) {
    return Text(description, style: context.textTheme.titleSmall?.copyWith(height: 1, color: const Color(0xFF989CA0)));
  }
}
