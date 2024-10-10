import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_style.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/language_selection.dart';
import '../../../widgets/selected_food_card.dart';

class AddonItem extends StatefulWidget {
  final VoidCallback onTap;
  final Map<String, dynamic>? addonData;
  final bool isSelected;
  final Function(int addonId, int quantity, double totalPrice) onCountChange;

  const AddonItem({
    Key? key,
    required this.onTap,
    required this.addonData,
    required this.isSelected,
    required this.onCountChange,
  }) : super(key: key);

  @override
  State<AddonItem> createState() => _AddonItemState();
}

class _AddonItemState extends State<AddonItem> {
  int count = 0;
  double subtotalAddonPrice = 0.0;
  List<Map<String, dynamic>> selectedAddonsFinal = [];

  @override
  void initState() {
    super.initState();
    _loadSubtotalAddonPrice();
  }

  Future<void> _loadSubtotalAddonPrice() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      subtotalAddonPrice = prefs.getDouble('subtotalAddonPrice') ?? 0.0;
    });
  }

  Future<void> _updateSubtotalAddonPrice(double totalPrice) async {
    final prefs = await SharedPreferences.getInstance();
    double currentTotal = prefs.getDouble('subtotalAddonPrice') ?? 0.0;
    currentTotal += totalPrice;
    await prefs.setDouble('subtotalAddonPrice', currentTotal);
    setState(() {
      subtotalAddonPrice = currentTotal;
    });
    print('Subtotal Addon Price: $subtotalAddonPrice');
    // Print the current value in shared preferences
    print('Current Subtotal Addon Price in Shared Preferences: ${prefs.getDouble('subtotalAddonPrice')}');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleNotifier>(context).locale;
    if (widget.addonData == null) {
      return Container(); // Handle case where addonData is null
    }

    double addonPrice = widget.addonData!['addon_price'] != null
        ? double.parse(widget.addonData!['addon_price'])
        : 0.0; // Default value if addon_price is null or cannot be parsed

    int addonId = widget.addonData!['id'] ?? ''; // Default value for addon_id

    return GestureDetector(
      onTap: () {
        widget.onTap();
        widget.onCountChange(addonId, count, addonPrice);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        height: 131,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xffEDC0B2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Image.network(
                widget.addonData!['image_url'] ?? '', // Default value for image_url
                height: 50,
                width: 50,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Container(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    //widget.addonData!['addon_name'] ?? '',
                     locale?.languageCode == 'ar'
                       ? widget.addonData!['addon_arabic'] ?? 'arabic unavailable'
                       : widget.addonData!['addon_name'] ?? '',
                    style: CustomTextStyles.labelTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/fire2.png',
                        height: 14,
                        width: 13,
                      ),
                      Text(
                        '${widget.addonData!['kcal']} ${localizations.translate('kcal')}',
                        style: CustomTextStyles.subtitleTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      NutritionBar(
                        color: const Color(0xffBBC392),
                        label: '${widget.addonData!['protein']} ${localizations.translate('g')}',
                        widthFactor: 24 / 100 * 50,
                        label2: ' ${localizations.translate('protein')}',
                      ),
                      NutritionBar(
                        color: const Color(0xffF7C648),
                        label: '${widget.addonData!['carb']} ${localizations.translate('g')}',
                        widthFactor: 20 / 100 * 50,
                        label2: ' ${localizations.translate('carbs')}',
                      ),
                      NutritionBar(
                        color: const Color(0xffA8353A),
                        label: '${widget.addonData!['fat']} ${localizations.translate('g')}',
                        widthFactor: 60 / 100 * 50,
                        label2: ' ${localizations.translate('fat')}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${localizations.translate('price')}: ${addonPrice.toStringAsFixed(2)} QR',
                            style: CustomTextStyles.labelTextStyle.copyWith(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${localizations.translate('total')}: ${(addonPrice * count).toStringAsFixed(2)} QR',
                            style: CustomTextStyles.labelTextStyle.copyWith(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Color(0xffEDC0B2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (count > 0) {
                                    count--;
                                    widget.onCountChange(addonId, count, addonPrice);
                                    _updateSubtotalAddonPrice(-addonPrice);
                                  }
                                });
                              },
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '$count',
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  count++;
                                  widget.onCountChange(addonId, count, addonPrice);
                                  _updateSubtotalAddonPrice(addonPrice);
                                });
                              },
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
