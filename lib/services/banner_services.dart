import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../models/banner_model.dart';

class BannerService {
  static const String url = 'https://interfuel.qa/packupadmin/api/banners';
  static final box = Hive.box('bannersBox');

  static Future<List<BannerCard>> fetchBanners() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      List<BannerCard> banners = jsonData.map((json) => BannerCard.fromJson(json)).toList();
      await saveBannersToLocal(banners); // Save to local storage
      return banners;
    } else {
      throw Exception('Failed to load banners');
    }
  }

  static Future<void> saveBannersToLocal(List<BannerCard> banners) async {
    List<String> bannerJsonList = banners.map((banner) => json.encode(banner.toJson())).toList();
    await box.put('banners', bannerJsonList);
  }

  static List<BannerCard>? loadBannersFromLocal() {
    List<String>? bannerJsonList = box.get('banners')?.cast<String>();
    if (bannerJsonList == null) return null;
    return bannerJsonList.map((bannerJson) => BannerCard.fromJson(json.decode(bannerJson))).toList();
  }
}