import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class PickedFile extends StatelessWidget {
  final String fileName;
  final VoidCallback onDeleteButtonPress;

  const PickedFile(
      {Key? key, required this.fileName, required this.onDeleteButtonPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey,
      dashPattern: [10, 4],
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                fileName,
                maxLines: 1,
              ),
            ),
            IconButton(
              onPressed: onDeleteButtonPress,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
