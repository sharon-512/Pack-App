import 'package:flutter/material.dart';
import 'package:pack_app/screens/payment.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';

import '../../../custom_style.dart';
import '../../../widgets/info_container.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  int _selectedIndex = 0;
  late TextEditingController addressline;
  late TextEditingController streetNumber;
  late TextEditingController houseName;
  late TextEditingController flatNumber;
  late TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GreenAppBar(showBackButton: true, titleText: 'Add Address'),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('assets/images/map.png'),
                    const SizedBox(height: 20),
                    Text(
                      'Delivery Address',
                      style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 3; i++)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIndex = i;
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 37,
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
                              decoration: BoxDecoration(
                                color: _selectedIndex == i
                                    ? Color(0xFFEDC0B2)
                                    : Colors.transparent,
                                border: Border.all(color: Color(0xFFEDC0B2)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                i == 0
                                    ? 'Home'
                                    : i == 1
                                    ? 'Office'
                                    : 'Other',
                                style: TextStyle(
                                    color: _selectedIndex == i
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Aeonik',
                                    fontSize: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                    AddressWidget(
                      label: 'Address Line',
                      address: 'Marina Twin Tower, Lusail',
                      textEditingController: addressline,
                    ),
                    AddressWidget(
                      label: 'Street Number',
                      address: 'Ex: 10th street',
                      textEditingController: streetNumber,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AddressWidget(
                            label: 'House/Floor Number',
                            address: 'Ex: 02',
                            textEditingController: houseName,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: AddressWidget(
                              label: '',
                              address: 'Ex: 2B',
                              textEditingController: flatNumber,
                            ))
                      ],
                    ),
                    AddressWidget(
                      label: 'Contact Person Name',
                      address: 'Muhammed Sheharin',
                      hintStyle:
                      CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                      textEditingController: name,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Number',
                          style: CustomTextStyles.labelTextStyle
                              .copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 44,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          decoration: BoxDecoration(
                            border:
                            Border.all(color: Color(0xff000000).withOpacity(.07)),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Image.asset('assets/images/flag.png'),
                              Text(
                                '  +974',
                                style: CustomTextStyles.labelTextStyle
                                    .copyWith(fontSize: 14),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                '32165426',
                                style: CustomTextStyles.labelTextStyle
                                    .copyWith(fontSize: 14, color: Color(0xffB1B1B1)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const SizedBox(height: 20),
                        CommonButton(
                          text: 'Add Address',
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => PaymentScreen(),
                            //     ));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
