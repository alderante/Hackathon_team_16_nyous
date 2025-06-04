// Packages
import 'package:flutter/material.dart';

class Themes {
  Themes._();

  //* Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      //* Theme of the application
      colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 0, 87, 255)).copyWith(
        primary: Color.fromARGB(255, 0, 87, 255),
        secondary: Color.fromARGB(255, 255, 227, 201),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),

      //* Shadow color
      shadowColor: Color.fromARGB(255, 1, 34, 100),

      //* Text color when selected
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.black38,
        selectionHandleColor: Colors.black54,
      ),

      //* Card color
      cardColor: Color.fromARGB(255, 50, 125, 255),

      //* Notification Bar (SnackBar) colors
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color.fromARGB(200, 255, 177, 3),
      ),

      //* TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          //* Color
          backgroundColor: Color.fromARGB(255, 0, 87, 255),
          foregroundColor: Colors.white,
          shadowColor: Color.fromARGB(255, 1, 34, 100),

          //* Borders
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Color.fromARGB(255, 1, 34, 100)),
          ),

          textStyle: TextStyle(fontSize: 24),
        ),
      ),

      //* FloatingButton colors
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),

      //* Slider colors
      sliderTheme: SliderThemeData(
        //* Thumb color
        thumbColor: Color.fromARGB(255, 255, 175, 2),
        //* Watched Bar color
        activeTrackColor: Color.fromARGB(255, 255, 175, 2),
        //* Remaining Bar color
        inactiveTrackColor: Colors.grey.withAlpha(150),
      ),

      //* Progress Indicators colors
      progressIndicatorTheme: ProgressIndicatorThemeData(
        //* Bar color
        color: Color.fromARGB(255, 255, 175, 2),
        //* Remaining/Background color
        linearTrackColor: Colors.grey.withAlpha(150),
      ),
    );
  }

  //* Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      //* Theme of the application
      colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 16, 32)).copyWith(
        primary: Color.fromARGB(255, 18, 16, 32),
        secondary: Color.fromARGB(255, 180, 173, 99),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),

      //* Shadow color
      shadowColor: Color.fromARGB(255, 10, 46, 52),

      //* Text color when selected
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.white38,
        selectionHandleColor: Colors.white54,
      ),

      //* Card color
      cardColor: Color.fromARGB(255, 20, 28, 58),

      //* Notification Bar (SnackBar) colors
      // snackBarTheme: SnackBarThemeData(
      //   backgroundColor: Color.fromARGB(200, 20, 28, 58),
      // ),

      //* TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          //* Color
          backgroundColor: Color.fromARGB(255, 50, 76, 92),
          foregroundColor: Colors.white,
          shadowColor: Color.fromARGB(255, 10, 46, 52),

          //* Borders
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Color.fromARGB(255, 10, 46, 52)),
          ),

          textStyle: TextStyle(fontSize: 24),
        ),
      ),

      //* FloatingButton colors
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: CircleBorder(),
      ),

      //* Slider colors
      sliderTheme: SliderThemeData(
        //* Thumb color
        thumbColor: Color.fromARGB(255, 180, 173, 99),
        //* Watched Bar color
        activeTrackColor: Color.fromARGB(255, 180, 173, 99),
        //* Remaining Bar color
        inactiveTrackColor: Colors.grey.withAlpha(150),
      ),

      //* Progress Indicators colors
      progressIndicatorTheme: ProgressIndicatorThemeData(
        //* Bar color
        color: Color.fromARGB(255, 180, 173, 99),
        //* Remaining/Background color
        linearTrackColor: Colors.grey.withAlpha(150),
      ),
    );
  }
}
