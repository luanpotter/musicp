import 'dart:math';

import 'package:flutter/material.dart';

// TODO select pretty colors
const COLORS = [
  Colors.blueGrey,
  Colors.cyan,
  Colors.indigo,
  Colors.lime,
  Colors.orange,
  Colors.red,
  Colors.purple,
  Colors.yellow,
];

Random random = Random.secure();

class TagWidget extends StatelessWidget {
  static final List<Color> unusedColors = List.from(COLORS);
  static final Map<String, Color> tagColors = {};

  final String tag;
  final void Function(String) onClick;

  TagWidget({ @required this.tag, this.onClick });

  @override
  Widget build(BuildContext context) {
    Color color = _getColor(tag);
    return GestureDetector(
      onTap: () {
        if (this.onClick != null) {
          this.onClick(tag);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.all(4.0),
        color: color,
        child: Text(tag),
      ),
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
