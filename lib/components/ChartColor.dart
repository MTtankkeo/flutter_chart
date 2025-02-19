// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

class ChartColor {
    /// Returns the color that is converted to the hover color.
    static Color hoverOf(Color color, double value, double percent) {
        return HSLColor.fromColor(color).lightness > 0.9
            ? darken(color, percent * value)
            : lighten(color, percent * value);
    }

    /// Converts the given color as dark as the given percent and return it.
    static Color darken(Color color, double percent) {
        return Color.fromARGB(
            color.alpha,
            (color.red * (1 - percent)).round(),
            (color.green * (1 - percent)).round(),
            (color.blue * (1 - percent)).round()
        );
    }

    /// Converts the given color as bright as the given percent and return it.
    static Color lighten(Color color, double percent) {
        return Color.fromARGB(
            color.alpha,
            color.red + ((255 - color.red) * percent).round(),
            color.green + ((255 - color.green) * percent).round(),
            color.blue + ((255 - color.blue) * percent).round()
        );
    }
}