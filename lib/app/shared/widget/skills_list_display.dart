import 'package:flutter/material.dart';

class SkillsListDisplay extends StatelessWidget {
  const SkillsListDisplay({required this.skillWidgetList, Key? key})
      : super(key: key);

  final List skillWidgetList;
  @override
  Widget build(BuildContext context) {
    var widgetList = skillWidgetList
        .map((e) => Row(
              children: [
                Icon(Icons.arrow_right_alt_sharp),
                Text(e.description,
                    style:
                        TextStyle(inherit: true, fontWeight: FontWeight.w700)),
              ],
            ))
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetList,
      ),
    );
  }
}
