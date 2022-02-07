import 'package:talao/app/shared/ui/ui.dart';
import 'package:talao/app/shared/widget/tooltip_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledItem extends StatelessWidget {
  final String icon;
  final String label;
  final String hero;
  final String value;

  const LabeledItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.hero,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 16.0,
            height: 16.0,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: TooltipText(
              tag: hero,
              text: value,
              tooltip: '$label $value',
              style: GoogleFonts.poppins(
                color: Theme.of(context).primaryColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
}
