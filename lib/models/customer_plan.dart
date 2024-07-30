class CustomerPlan {
  final PlanDetails planDetails;
  CustomerPlan({required this.planDetails});
  factory CustomerPlan.fromJson(Map<String, dynamic> json) {
    return CustomerPlan(
      planDetails: PlanDetails.fromJson(json['plan_details']),
    );
  }
}

class PlanDetails {
  final int id;
  final List<Menu> menu;
  PlanDetails({required this.id, required this.menu});
  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    var menuList = json['menu'] as List;
    List<Menu> menu = menuList.map((i) => Menu.fromJson(i)).toList();
    return PlanDetails(id: json['id'], menu: menu);
  }
}

class Menu {
  final String date;
  final Meal? breakfast;
  final Meal? lunch;
  final Meal? snacks;
  final Meal? dinner;
  Menu({required this.date, this.breakfast, this.lunch, this.snacks, this.dinner});
  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      date: json['date'],
      breakfast: json['breakfast'] != null && json['breakfast'] is Map<String, dynamic> ? Meal.fromJson(json['breakfast']) : null,
      lunch: json['lunch'] != null && json['lunch'] is Map<String, dynamic> ? Meal.fromJson(json['lunch']) : null,
      snacks: json['snacks'] != null && json['snacks'] is Map<String, dynamic> ? Meal.fromJson(json['snacks']) : null,
      dinner: json['dinner'] != null && json['dinner'] is Map<String, dynamic> ? Meal.fromJson(json['dinner']) : null,
    );
  }
}

class Meal {
  final int id;
  final String menuname;
  final int kcal;
  final int protien;
  final int carb;
  final int fat;
  final String image;
  Meal({required this.id, required this.menuname, required this.kcal, required this.protien, required this.carb, required this.fat, required this.image});
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      menuname: json['menuname'],
      kcal: json['kcal'],
      protien: json['protien'],
      carb: json['carb'],
      fat: json['fat'],
      image: json['image'],
    );
  }
}
