import 'dart:math';

import 'package:flutter/material.dart';

const COLORS = [
  Colors.blueGrey,
  Colors.cyan,
  Colors.indigo,
];

Random random = Random.secure();

class TagWidget extends StatelessWidget {
  static final List<Color> unusedColors = List.from(COLORS);
  static final Map<String, Color> tagColors = {};

  final String tag;

  TagWidget({this.tag});

  @override
  Widget build(BuildContext context) {
    Color color = _getColor(tag);
    return Container(
      padding: EdgeInsets.all(4.0),
      margin: EdgeInsets.all(4.0),
      color: color,
      child: Text(tag),
    );
  }

  Color _getColor(String tag) {
    if (!tagColors.containsKey(tag)) {
      tagColors[tag] = _newUnusedColor();
    }
    return tagColors[tag];
  }

  Color _newUnusedColor() {
    if (unusedColors.isEmpty) {
      unusedColors.addAll(COLORS);
    }
    int idx = random.nextInt(unusedColors.length);
    return unusedColors.removeAt(idx);
  }
}