import 'package:flutter/material.dart';

class PriceSlider extends StatefulWidget {
  const PriceSlider({
    super.key,
    required this.sliderValue,
    this.onChanged,
  });

  final ValueNotifier<double> sliderValue;
  final void Function(double)? onChanged;

  @override
  State<PriceSlider> createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Definir preço',
                style: theme.textTheme.titleLarge,
              ),
              ValueListenableBuilder(
                valueListenable: widget.sliderValue,
                builder: (_, value, __) {
                  return Text(
                    'Até R\$ ${value.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium,
                  );
                },
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder(
          valueListenable: widget.sliderValue,
          builder: (_, value, __) {
            return Slider(
              value: value,
              min: 0,
              max: 100,
              onChanged: widget.onChanged,
            );
          },
        ),
      ],
    );
  }
}
