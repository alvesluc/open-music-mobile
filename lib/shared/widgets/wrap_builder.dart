import 'package:flutter/widgets.dart';

class WrapBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final double spacing;
  final int itemCount;

  const WrapBuilder({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.spacing = 0.0,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      textDirection: textDirection,
      alignment: WrapAlignment.spaceBetween,
      verticalDirection: verticalDirection,
      children: List.generate(itemCount, (index) => itemBuilder(context, index))
          .toList(),
    );
  }
}
