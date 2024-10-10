import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../custom_style.dart';
import '../../../models/activity_level_model.dart';
import '../../../providers/activity_level_provider.dart';
import '../../../providers/app_localizations.dart';
import '../../../providers/user_registration_provider.dart';
import '../../../services/language_selection.dart';

class ActivityLevelSelection2 extends StatefulWidget {
  const ActivityLevelSelection2({super.key});

  @override
  State<ActivityLevelSelection2> createState() =>
      _SelectActivityLevelSelection2();
}

class _SelectActivityLevelSelection2 extends State<ActivityLevelSelection2> {
  int _selectedIndex = -1;

  void _updateActivityLevel(String activityLevel) {
    Provider.of<UserProvider>(context, listen: false).updateActivityLevel(activityLevel);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ActivityProvider>(context, listen: false).fetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      body: activityProvider.isLoading
          ? _buildShimmerEffect()
          : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              localizations!.translate('describeActivityLevel'),
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 30),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: activityProvider.activities.length,
              itemBuilder: (context, index) {
                final activity = activityProvider.activities[index];
                return _buildContainer(index, activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(int index, Activity activity) {
    bool isSelected = _selectedIndex == index;
    final locale = Provider.of<LocaleNotifier>(context).locale;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _updateActivityLevel(activity.activityName); // Update activity level with selected activity name
      },
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEDC0B2) : Colors.transparent,
          border: Border.all(color: Color(0xFFEDC0B2)),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            SizedBox(width: 10),
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300], // Background color while loading
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  activity.imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 70,
                          width: 70,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/images/default.png', // Path to your default image
                      height: 70,
                      width: 70,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded( // Add Expanded here to constrain the Column
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale?.languageCode == 'ar'
                          ? activity.activityNameAr
                          : activity.activityName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Aeonik',
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      activity.activityDescription,
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                        color: isSelected ? Colors.white : Color(0xffCDD1D6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )

      ),
    );
  }

  Widget _buildShimmerEffect() {
    final localizations = AppLocalizations.of(context)!;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Center(
            child: Text(
              localizations!.translate('describeActivityLevel'),
              style: CustomTextStyles.titleTextStyle.copyWith(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Display 5 shimmer items
              itemBuilder: (context, index) {
                return Container(
                  height: 90,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
