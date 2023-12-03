import 'package:flutter/material.dart';
import 'package:medz/Classes/Medicine.dart';

class MedItem extends StatefulWidget {
  const MedItem({super.key, required this.med});
  final Medicine med;
  @override
  State<StatefulWidget> createState() {
    return _MedItem_state();
  }
}

class _MedItem_state extends State<MedItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.med.name,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Text('Finish before '),
              Text(widget.med.date),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Next dose in '),
              Row(
                children: [
                  const Icon(Icons.medication_outlined),
                  Text(
                    widget.med.dozes.toString(),
                  ),
                  const Text(' dose left today'),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
