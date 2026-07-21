import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/assets.dart';

class PhoneLoginBrand extends StatelessWidget {
  const PhoneLoginBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset(
          Assets.logoTransparent,
          width: 150,
          height: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
