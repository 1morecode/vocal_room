import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vocal/res/my_colors.dart';

class AppTheme {
  AppTheme._();

  static const LightBrown = Color(0xfff1efe5);
  static const LightGreen = Color(0xffE8FCD9);
  static const LightGrey = Color(0xfff2f2f2);

  static const AccentRed = Color(0xffDA6864);
  static const AccentGreen = Color(0xff55AB67);
  static const AccentBrown = Color(0xffE6E2D6);
  static const AccentBlue = Color(0xff5B75A6);
  static const AccentGrey = Color(0xff807970);

  static const DarkBrown = Color(0xff918E81);
  static const DarkBlack = Color(0xff000000);

  static const SelectedItemGrey = Color(0xffCCCFDC);
  static const SelectedItemBorderGrey = Color(0xffC5C5CF);

  // static const Color _lightPrimaryColor = MyColors.SelectedItemGrey;
  // static const Color _lightPrimaryVariantColor = MyColors.SelectedItemBorderGrey;
  // static const Color _lightOnPrimaryColor = MyColors.AccentGrey;
  // static const Color _lightSecondaryColor = MyColors.AccentBrown;
  // static const Color _lightGreyColor = MyColors.LightBrown;
  // static const Color _lightBrightColor = MyColors.LightGrey;
  // static const Color _lightTextColor = MyColors.DarkBrown;
  // static const Color _lightTextVariantColor = MyColors.SelectedItemGrey;

  // static final TextStyle _lightScreenHeadingTextStyle =
  //     TextStyle(fontSize: 32.0, color: _lightPrimaryVariantColor);
  // static final TextStyle _lightSubHeadingTextStyle =
  //     TextStyle(fontSize: 18.0, color: _lightBrightColor);
  // static final TextStyle _lightAppBarHeadingTextStyle = TextStyle(
  //     fontSize: 20.0, color: _lightOnPrimaryColor, fontWeight: FontWeight.w700);
  // static final TextStyle _lightScreenTaskNameTextStyle = TextStyle(
  //     fontSize: 20.0,
  //     color: _lightTextVariantColor,
  //     fontWeight: FontWeight.w500);
  // static final TextStyle _lightScreenTaskDurationTextStyle =
  //     TextStyle(fontSize: 16.0, color: _lightTextColor);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: LightBrown,
    inputDecorationTheme: InputDecorationTheme(fillColor: LightGrey),
    appBarTheme: AppBarTheme(
      color: LightBrown,
      brightness: Brightness.light,
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: DarkBlack,
      ),
      titleTextStyle: TextStyle(color: DarkBlack)
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: LightBrown,
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(primaryColor: DarkBlack),
        primaryColor: DarkBlack),
    colorScheme: ColorScheme.light(
      primary: AccentBlue,
      primaryVariant: AccentGrey,
      secondary: AccentGreen,
      onPrimary: LightBrown,
      onSecondary: LightGreen,
      background: LightBrown,
      surface: LightGrey,
      onSurface: SelectedItemBorderGrey,
      brightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: DarkBlack, size: 24),
    // textTheme: _lightTextTheme,
    disabledColor: SelectedItemBorderGrey,
    dialogBackgroundColor: LightGrey,
    accentColor: AccentGreen,
    cardTheme: CardTheme(elevation: 2, color: LightGrey),
    backgroundColor: LightBrown,
    splashFactory: InkRipple.splashFactory,
    dividerColor: Colors.grey.withOpacity(0.3),
  );

  // static final TextTheme _lightTextTheme = TextTheme(
  //     headline5: _lightScreenHeadingTextStyle,
  //     bodyText2: _lightScreenTaskNameTextStyle,
  //     bodyText1: _lightScreenTaskDurationTextStyle,
  //     headline1: _lightAppBarHeadingTextStyle,
  //     subtitle1: _lightScreenHeadingTextStyle,
  //     headline2: _lightSubHeadingTextStyle,
  //     caption: _lightScreenTaskDurationTextStyle);

  // Dark Theme
  // static const Color _darkPrimaryColor = Colors.blue;
  // static const Color _darkPrimaryVariantColor = Colors.blue;
  // static const Color _darkOnPrimaryColor = MyColors.black;
  // static const Color _darkSecondaryColor = MyColors.yellow;
  // static const Color _darkGreyColor = MyColors.lightBlack;
  // static const Color _darkBrightColor = MyColors.lightBlack;
  // static const Color _darkTextColor = MyColors.white;
  // static const Color _darkTextVariantColor = MyColors.lightGrey;
  //
  // static final TextStyle _darkScreenHeadingTextStyle =
  //     TextStyle(fontSize: 32.0, color: _darkPrimaryVariantColor);
  // static final TextStyle _darkSubHeadingTextStyle =
  //     TextStyle(fontSize: 18.0, color: _darkTextVariantColor);
  // static final TextStyle _darkAppBarHeadingTextStyle = TextStyle(
  //     fontSize: 20.0, color: _darkTextColor, fontWeight: FontWeight.w700);
  // static final TextStyle _darkScreenTaskNameTextStyle = TextStyle(
  //     fontSize: 20.0,
  //     color: _darkTextVariantColor,
  //     fontWeight: FontWeight.w500);
  // static final TextStyle _darkScreenTaskDurationTextStyle =
  //     TextStyle(fontSize: 16.0, color: _darkTextColor);
  //
  // static final ThemeData darkTheme = ThemeData(
  //   scaffoldBackgroundColor: _darkGreyColor,
  //   inputDecorationTheme: InputDecorationTheme(fillColor: _darkPrimaryColor),
  //   appBarTheme: AppBarTheme(
  //     color: _darkOnPrimaryColor,
  //     brightness: Brightness.dark,
  //     iconTheme: IconThemeData(
  //       color: _darkPrimaryColor,
  //     ),
  //       titleTextStyle: TextStyle(color: _darkPrimaryColor)
  //   ),
  //   cupertinoOverrideTheme: CupertinoThemeData(
  //       barBackgroundColor: _darkOnPrimaryColor,
  //       brightness: Brightness.dark,
  //       primaryContrastingColor: _darkOnPrimaryColor,
  //       textTheme: CupertinoTextThemeData(primaryColor: _darkPrimaryColor),
  //       primaryColor: _darkPrimaryColor),
  //   colorScheme: ColorScheme.light(
  //     primary: _darkPrimaryColor,
  //     primaryVariant: _darkPrimaryVariantColor,
  //     secondary: _darkSecondaryColor,
  //     onPrimary: _darkOnPrimaryColor,
  //     onSecondary: _darkTextColor,
  //     background: _darkPrimaryColor,
  //     surface: _darkGreyColor,
  //     onSurface: _darkGreyColor,
  //     brightness: Brightness.light,
  //   ),
  //   iconTheme: IconThemeData(color: _darkPrimaryColor, size: 24),
  //   textTheme: _darkTextTheme,
  //   disabledColor: _darkBrightColor,
  //   dialogBackgroundColor: _darkPrimaryVariantColor,
  //   accentColor: _darkPrimaryColor,
  //   cardTheme: CardTheme(elevation: 2, color: _darkOnPrimaryColor),
  //   backgroundColor: _darkOnPrimaryColor,
  //   splashFactory: InkRipple.splashFactory,
  //   dividerColor: Colors.grey.withOpacity(0.3),
  // );
  //
  // static final TextTheme _darkTextTheme = TextTheme(
  //     headline5: _darkScreenHeadingTextStyle,
  //     bodyText2: _darkScreenTaskNameTextStyle,
  //     bodyText1: _darkScreenTaskDurationTextStyle,
  //     headline1: _darkAppBarHeadingTextStyle,
  //     headline2: _darkSubHeadingTextStyle,
  //     subtitle1: _darkScreenHeadingTextStyle,
  //     headline3: _darkAppBarHeadingTextStyle,
  //     caption: _darkScreenTaskDurationTextStyle);
}
