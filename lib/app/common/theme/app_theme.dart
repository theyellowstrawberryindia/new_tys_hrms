import 'package:hrms_ys/app/packages.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,

      scaffoldBackgroundColor: AppColor.kLightPrimaryBGColor,

      colorScheme: const ColorScheme.light(
        primary: AppColor.kPrimaryColor,

        surface: Colors.white,

        onSurface: AppColor.kLightTextColor,

        secondary: AppColor.kIconColor,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,

        selectedItemColor: AppColor.kIconColor,

        unselectedItemColor: AppColor.kGrayTextColor,
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColor.kDarkPrimaryBGColor,

      colorScheme: const ColorScheme.dark(
        primary: AppColor.kPrimaryColor,

        surface: Color(0xFF1E1E1E),

        onSurface: AppColor.kDarkTextColor,

        secondary: AppColor.kYellowTextColor,
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),

        selectedItemColor: AppColor.kYellowTextColor,

        unselectedItemColor: AppColor.kGrayTextColor,
      ),
    );
  }

  static TextStyle textStyle({
    BuildContext? context,
    double size = 14,
    FontWeight weight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,

      color: color ??
          (context != null
              ? Theme.of(context).colorScheme.onSurface
              : Get.theme.colorScheme.onSurface),
    );
  }

  static Color cardColor(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color textColor(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color iconColor(BuildContext context) {
    return Theme.of(context).colorScheme.secondary;
  }

  static Color primaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}