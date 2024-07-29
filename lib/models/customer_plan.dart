// customer_plan.dart
class CustomerPlan {
  final bool status;
  final String message;
  final int statusCode;
  final PlanDetails planDetails;

  CustomerPlan({required this.status, required this.message, required this.statusCode, required this.planDetails});

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

  PlanDetails({required this.id, required this.menu});

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
  final String date;
  final Meal breakfast;
  final Meal? lunch;
  final Meal? snacks;
  final Meal? dinner;

  Menu({required this.date, required this.breakfast, this.lunch, this.snacks, this.dinner});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      date: json['date'],
      breakfast: Meal.fromJson(json['breakfast']),
      lunch: json['lunch'] != '' ? Meal.fromJson(json['lunch']) : null,
      snacks: json['snacks'] != '' ? Meal.fromJson(json['snacks']) : null,
      dinner: json['dinner'] != '' ? Meal.fromJson(json['dinner']) : null,
    );
  }
}

class Meal {
  final int id;
  final String menuname;
  final int kcal;
  final int protein;
  final int carb;
  final int fat;
  final String image;

  Meal({required this.id, required this.menuname, required this.kcal, required this.protein, required this.carb, required this.fat, required this.image});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      menuname: json['menuname'],
      kcal: json['kcal'],
      protein: json['protien'],
      carb: json['carb'],
      fat: json['fat'],
      image: json['image'],
    );
  }
}
