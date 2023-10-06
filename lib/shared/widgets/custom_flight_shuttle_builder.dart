import 'package:flutter/material.dart';

/// This `customFlightShuttleBuilder` serves as a fallback for when the [Hero]
/// needs to animate a text and doesn't know its style.
Widget customFlightShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return DefaultTextStyle(
    style: DefaultTextStyle.of(toHeroContext).style,
    child: toHeroContext.widget,
  );
}
