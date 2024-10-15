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
  final List<Meal> meals;

  Menu({required this.date, required this.meals});

  factory Menu.fromJson(Map<String, dynamic> json) {
    List<Meal> meals = [];
    json.forEach((key, value) {
      if (key != 'date' && value is Map<String, dynamic>) {
        Meal meal = Meal.fromJson({...value, 'type': key});
        meals.add(meal);
      }
    });
    return Menu(
      date: json['date'],
      meals: meals,
    );
  }
}

class Meal {
  final int id;
  final String type; // New field to indicate meal type
  final String menuname;
  final int kcal;
  final int protien;
  final int carb;
  final int fat;
  final String image;

  Meal({
    required this.id,
    required this.type,
    required this.menuname,
    required this.kcal,
    required this.protien,
    required this.carb,
    required this.fat,
    required this.image,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      type: json['type'], // Extracting meal type from JSON
      menuname: json['menuname'],
      kcal: json['kcal'],
      protien: json['protien'],
      carb: json['carb'],
      fat: json['fat'],
      image: json['image'],
    );
  }
}

