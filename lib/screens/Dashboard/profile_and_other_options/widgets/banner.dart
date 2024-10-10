import 'package:flutter/material.dart';

import '../../../../custom_style.dart';
import '../../../../providers/app_localizations.dart';
import '../../nav_bar.dart';

class EmptyMeal extends StatelessWidget {
  const EmptyMeal({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 165,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0x52fec66f),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/selected_pack_bg2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomRight,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations?.translate('emptyMealTitle') ?? 'translation error',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localizations?.translate('emptyMealSubtitle') ?? 'translation error',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff124734),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavbar(),
                        ),
                      );
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xff124734),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        localizations?.translate('orderNow') ?? 'translation error',
                        style: CustomTextStyles.titleTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
