library font_awesome_flutter;

import 'package:flutter/widgets.dart';

/// [IconData] for a font awesome regular icon from a code point
///
/// Code points can be obtained from fontawesome.com
class IconDataRegular extends IconData {
  const IconDataRegular(int codePoint)
      : super(
          codePoint,
          fontFamily: 'FontAwesomeRegular',
        );
}

/// [IconData] for a font awesome solid icon from a code point
///
/// Code points can be obtained from fontawesome.com
class IconDataSolid extends IconData {
  const IconDataSolid(int codePoint)
      : super(
          codePoint,
          fontFamily: 'FontAwesomeSolid',
        );
}
