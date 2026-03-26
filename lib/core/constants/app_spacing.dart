import 'package:flutter/material.dart';

/// Centralized spacing and sizing constants for consistent design
class AppSpacing {
  // Padding values
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;

  // Margin values
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 12.0;
  static const double marginL = 16.0;
  static const double marginXL = 20.0;
  static const double marginXXL = 24.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;

  // Icon sizes
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 50.0;

  // Avatar sizes
  static const double avatarS = 24.0;
  static const double avatarM = 32.0;
  static const double avatarL = 40.0;
  static const double avatarXL = 60.0;

  // Button heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  // Logo sizes
  static const double logoS = 60.0;
  static const double logoM = 80.0;
  static const double logoL = 100.0;

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(paddingL);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(paddingM);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(paddingL);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(
    horizontal: paddingL,
  );
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(
    vertical: paddingL,
  );

  // Form field padding
  static const EdgeInsets formFieldPadding = EdgeInsets.symmetric(
    vertical: paddingM,
  );
  static const EdgeInsets formFieldContentPadding = EdgeInsets.symmetric(
    horizontal: paddingL,
    vertical: paddingL,
  );

  // List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: paddingL,
    vertical: paddingM,
  );

  // Spacing between elements
  static const SizedBox spaceXS = SizedBox(height: paddingXS, width: paddingXS);
  static const SizedBox spaceS = SizedBox(height: paddingS, width: paddingS);
  static const SizedBox spaceM = SizedBox(height: paddingM, width: paddingM);
  static const SizedBox spaceL = SizedBox(height: paddingL, width: paddingL);
  static const SizedBox spaceXL = SizedBox(height: paddingXL, width: paddingXL);
  static const SizedBox spaceXXL = SizedBox(
    height: paddingXXL,
    width: paddingXXL,
  );
  static const SizedBox spaceXXXL = SizedBox(
    height: paddingXXXL,
    width: paddingXXXL,
  );
}
