import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AmPmPicker extends StatefulWidget {
  final bool initialIsAm;
  final ValueChanged<bool> onChanged;

  const AmPmPicker({required this.initialIsAm, required this.onChanged});

  @override
  State<AmPmPicker> createState() => AmPmPickerState();
}

class AmPmPickerState extends State<AmPmPicker> {
  late final ValueNotifier<bool> _isAm;

  @override
  void initState() {
    super.initState();
    _isAm = ValueNotifier(widget.initialIsAm);
  }

  @override
  void dispose() {
    _isAm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 116,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CupertinoPicker(
            itemExtent: 87,
            scrollController: FixedExtentScrollController(
              initialItem: widget.initialIsAm ? 0 : 1,
            ),
            onSelectedItemChanged: (v) {
              _isAm.value = v == 0;
              widget.onChanged(v == 0); // plain assignment in parent
            },
            selectionOverlay: const SizedBox.shrink(),
            looping: false,
            children: [
              _AmPmItem(label: 'AM', isAmNotifier: _isAm, representsAm: true),
              _AmPmItem(label: 'PM', isAmNotifier: _isAm, representsAm: false),
            ],
          ),
          Positioned(
            top: (220 - 87) / 2,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 87,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF2D2D2D), width: 1),
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmPmItem extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> isAmNotifier;
  final bool representsAm;

  const _AmPmItem({
    required this.label,
    required this.isAmNotifier,
    required this.representsAm,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isAmNotifier,
      builder: (_, isAm, __) {
        final isSelected = isAm == representsAm;
        return Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Sora',
              fontSize: isSelected ? 40.0 : 20.0,
              fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
              color: isSelected
                  ? const Color(0xFFDDDDDD)
                  : const Color(0xFF717171),
              height: 1.2,
            ),
          ),
        );
      },
    );
  }
}
