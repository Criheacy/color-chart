import 'package:flutter/material.dart';
import 'package:color_chart/utils/interpolator.dart';

typedef ValueFormatter = String Function(num value);
typedef ValueListener = void Function(num value);

class ScrollWheel extends StatefulWidget {
  const ScrollWheel({
    Key? key,
    required this.defaultValue,
    required this.minValue,
    required this.maxValue,
    this.verticalStep = 1,
    this.horizontalStep = 10,
    this.numberOfWheels = 3, // 2n+1 wheels in total
    this.valueFormatter,
    this.onValueChanged,
  }) : super(key: key);

  final num defaultValue;
  final num minValue;
  final num maxValue;
  final num verticalStep;
  final num horizontalStep;
  final int numberOfWheels;
  final ValueFormatter? valueFormatter;
  final ValueListener? onValueChanged;

  @override
  State<ScrollWheel> createState() => _ScrollWheelState();
}

class _ScrollWheelState extends State<ScrollWheel> {
  late num _value;
  late double _offset;

  Interpolator offsetInterpolator = MagneticInterpolator(0.7, 0.65);
  Interpolator textSizeInterpolator = FocusedInterpolator(0.7, 1, 1);
  Interpolator textOpacityInterpolator = FocusedInterpolator(0, 1, 1);

  late num dragFrameCount;

  static const dragOffsetFactor = 0.02;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
    _offset = 0;
  }

  void updateWheelOffset(offset) {
    _offset += offset;

    // offset should between [-0.5, 0.5]
    if (_offset > 0.5 && _value > widget.minValue) {
      _offset -= 1;
      _value -= widget.verticalStep;

      // substracting the vertical step may cross the minimum
      // e.g. _value=3, min=0, verticalStep=10
      // new _value will be -7 which is lower than the minimum
      if (_value < widget.minValue) {
        _value = widget.minValue;
      }
      widget.onValueChanged?.call(_value);
    }
    if (_offset < -0.5 && _value < widget.maxValue) {
      _offset += 1;
      _value += widget.verticalStep;
      if (_value > widget.maxValue) {
        _value = widget.maxValue;
      }
      widget.onValueChanged?.call(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) {
          print('Drag Started!');
          dragFrameCount = 0;
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            updateWheelOffset((details.primaryDelta ?? 0) * dragOffsetFactor);
          });
          dragFrameCount += 1;
        },
        onVerticalDragEnd: (details) {
          print('Drag Event Lasted for $dragFrameCount');
          print(details.primaryVelocity);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 100, 20, 100),
          child: Stack(
              alignment: Alignment.center,
              children: List.generate(widget.numberOfWheels * 2 + 1, (index) {
                double offset = index - widget.numberOfWheels + _offset;
                num value = _value +
                    (index - widget.numberOfWheels) * widget.verticalStep;
                return Transform.translate(
                  offset:
                      Offset(0, offsetInterpolator.interpolate(offset) * 50),
                  child: Text(
                      widget.valueFormatter != null
                          ? widget.valueFormatter!(value)
                          : value.toString(),
                      style: TextStyle(
                          color: Colors.black.withOpacity(
                              textOpacityInterpolator.interpolate(offset) * 1),
                          fontSize:
                              textSizeInterpolator.interpolate(offset) * 40)),
                );
              })),
        ));
  }
}
