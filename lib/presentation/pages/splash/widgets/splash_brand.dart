import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/assets.dart';

class SplashBrand extends StatelessWidget {
  const SplashBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      Assets.logoTransparent,
      width: 247,
      height: 66,
      fit: BoxFit.contain,
    );
  }
}
