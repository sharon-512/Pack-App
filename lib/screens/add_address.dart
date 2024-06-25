import 'package:flutter/material.dart';
import 'package:pack_app/screens/payment.dart';
import 'package:pack_app/widgets/common_button.dart';

import '../custom_style.dart';
import '../widgets/info_container.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Add Address',
                      style: CustomTextStyles.titleTextStyle
                          .copyWith(fontSize: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
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
              const AddressWidget(
                label: 'Address Line',
                address: 'Marina Twin Tower, Lusail',
              ),
              const AddressWidget(
                label: 'Street Number',
                address: 'Ex: 10th street',
              ),
              const Row(
                children: [
                  Expanded(
                    child: AddressWidget(
                      label: 'House/Floor Number',
                      address: 'Ex: 02',
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: AddressWidget(
                    label: '',
                    address: 'Ex: 2B',
                  ))
                ],
              ),
              AddressWidget(
                label: 'Contact Person Name',
                address: 'Muhammed Sheharin',
                hintStyle:
                    CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(),
                          ));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
