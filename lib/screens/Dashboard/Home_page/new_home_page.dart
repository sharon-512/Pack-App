import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/screens/Dashboard/Home_page/widget/selected_pack_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widgets/food_detail_container.dart';
import '../../../widgets/selected_food_card.dart';
import '../../meal_selection.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/profile_pic.png',
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/hand_emoji.png'),
                              Text(
                                'Hello! Mariam',
                                style: CustomTextStyles.labelTextStyle.copyWith(
                                    color: Color(0xffD7D7D7), fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            'Welcome to Pack',
                            style: CustomTextStyles.labelTextStyle
                                .copyWith(fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                  Image.asset('assets/images/setting.png'),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectedPackCard(planName: 'Lose Weight', planDuration: '3 Week Plan'),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 92, // Height set to 92
                          decoration: BoxDecoration(
                            color: Color(0xFF124734), // Background color for the 1st container
                            borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/note.png'),
                                SizedBox(height: 5),
                                Text(
                                  'Plan Start',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Apr 21',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          height: 92, // Height set to 92
                          decoration: BoxDecoration(
                            color: Color(0xFFBBC392), // Background color for the 2nd container
                            borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/note.png', color: Color(0xff8D9858),),
                                SizedBox(height: 5),
                                Text(
                                  'Plan ends',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'May 19',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          height: 92, // Height set to 92
                          decoration: BoxDecoration(
                            color: Color(0xFFA8353A), // Background color for the 3rd container
                            borderRadius: BorderRadius.circular(10), // Radius of 10 pixels
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/timer.png'),
                                SizedBox(height: 5),
                                Text(
                                  'Remainig',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '28 days',
                                  style: CustomTextStyles.titleTextStyle.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BookYourDailyNutrition(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Todays Meal Plan',
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 115, // Adjust the height to fit your card
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3, // The number of cards
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: SelectedFoodCard(),
                        ); // Your custom card widget
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController, // PageController
                      count: 3, // The number of dots
                      effect: WormEffect(
                        activeDotColor: Colors.grey,
                        dotColor: Colors.grey[300]!,
                        dotHeight: 8,
                        dotWidth: 8
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BookYourDailyNutrition ( BuildContext context ){
    return Container(
      height: 165,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MealSelection()),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFEC66F),
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage('assets/images/selected_pack_bg2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12,12,12,0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/phone.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your\nDaily Nutrition\nThrough',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Pack App',
                    style: CustomTextStyles.titleTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff124734),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 23,
                    width: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff124734),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Buy Now',
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
