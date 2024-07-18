import 'package:flutter/material.dart';

import '../../../custom_style.dart';

class AddonItem extends StatefulWidget {
  final VoidCallback onTap;
  final Map<String, dynamic>? addonData;
  final bool isSelected;
  final Function(String addonId, int quantity, double totalPrice) onCountChange;

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

  @override
  Widget build(BuildContext context) {
    if (widget.addonData == null) {
      return Container(); // Handle case where addonData is null
    }

    double addonPrice = widget.addonData!['addon_price'] != null
        ? double.parse(widget.addonData!['addon_price'])
        : 0.0; // Default value if addon_price is null or cannot be parsed

    String addonId = widget.addonData!['addon_id'] ?? ''; // Default value for addon_id

    return GestureDetector(
      onTap: () {
        widget.onTap(); // Call onTap callback defined in the parent widget
        widget.onCountChange(addonId, count, addonPrice * count);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Color(0xffEDC0B2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.addonData!['addon_name'] ?? '', // Default value for addon_name
                        style: CustomTextStyles.labelTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Price: \$${addonPrice.toStringAsFixed(2)}',
                        style: CustomTextStyles.labelTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Total: \$${(addonPrice * count).toStringAsFixed(2)}',
                        style: CustomTextStyles.labelTextStyle.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                          if (count > 0) count--;
                          widget.onCountChange(addonId, count, addonPrice * count);
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
                          widget.onCountChange(addonId, count, addonPrice * count);
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
        ),
      ),
    );
  }
}
