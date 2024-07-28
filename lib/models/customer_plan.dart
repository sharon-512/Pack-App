class CustomerPlan {
  final bool status;
  final String message;
  final int statusCode;
  final PlanDetails planDetails;

  CustomerPlan({
    required this.status,
    required this.message,
    required this.statusCode,
    required this.planDetails,
  });

  factory CustomerPlan.fromJson(Map<String, dynamic> json) {
    return CustomerPlan(
      status: json['status'],
      message: json['message'],
      statusCode: json['status_code'],
      planDetails: PlanDetails.fromJson(json['plan_details']),
    );
  }
}

class PlanDetails {
  final int id;
  final List<Menu> menu;

  PlanDetails({
    required this.id,
    required this.menu,
  });

  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    var list = json['menu'] as List;
    List<Menu> menuList = list.map((i) => Menu.fromJson(i)).toList();
    return PlanDetails(
      id: json['id'],
      menu: menuList,
    );
  }
}

class Menu {
  String date;
  Meal? breakfast;
  Meal? lunch;
  Meal? snacks;
  Meal? dinner;

  Menu({
    required this.date,
    this.breakfast,
    this.lunch,
    this.snacks,
    this.dinner,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      date: json['date'],
      breakfast: json['breakfast'] != null ? Meal.fromJson(json['breakfast']) : null,
      lunch: json['lunch'] != null ? Meal.fromJson(json['lunch']) : null,
      snacks: json['snacks'] != null ? Meal.fromJson(json['snacks']) : null,
      dinner: json['dinner'] != null ? Meal.fromJson(json['dinner']) : null,
    );
  }
}

class Meal {
  int id;
  String menuname;
  int kcal;
  int protein;
  int carb;
  int fat;
  String image;

  Meal({
    required this.id,
    required this.menuname,
    required this.kcal,
    required this.protein,
    required this.carb,
    required this.fat,
    required this.image,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? 0, // Provide a default value if null
      menuname: json['menuname'] ?? 'Unknown',
      kcal: json['kcal'] ?? 0,
      protein: json['protein'] ?? 0,
      carb: json['carb'] ?? 0,
      fat: json['fat'] ?? 0,
      image: json['image'] ?? '',
    );
  }

}
