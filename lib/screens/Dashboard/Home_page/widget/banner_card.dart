import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../models/banner_model.dart';
import '../../../../services/banner_services.dart';
import '../../../Mealselection/meal_selection.dart';

class BannerCardWidget extends StatefulWidget {
  @override
  _BannerCardWidgetState createState() => _BannerCardWidgetState();
}

class _BannerCardWidgetState extends State<BannerCardWidget> {
  late Future<List<BannerCard>> futureBanners;

  @override
  void initState() {
    super.initState();
    List<BannerCard>? localBanners = BannerService.loadBannersFromLocal();
    if (localBanners != null) {
      futureBanners = Future.value(localBanners);
      checkForUpdates();
    } else {
      futureBanners = BannerService.fetchBanners();
    }
  }

  void checkForUpdates() async {
    List<BannerCard> updatedBanners = await BannerService.fetchBanners();
    setState(() {
      futureBanners = Future.value(updatedBanners);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BannerCard>>(
      future: futureBanners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerEffect();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Container(
            height: 165,
            child: PageView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final banner = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealSelection(planId: 1)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFEC66F),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(banner.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 165,
        color: Colors.white,
      ),
    );
  }
}
