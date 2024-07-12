class MealType {
  final int mealtypeId;
  final String mealtypeName;
  final List<Product> products;

  MealType({
    required this.mealtypeId,
    required this.mealtypeName,
    required this.products,
  });

  factory MealType.fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    if (json['products'] != null) {
      products = (json['products'] as Map<String, dynamic>).entries
          .map((entry) => Product.fromJson(entry.value))
          .toList();
    }
    return MealType(
      mealtypeId: json['mealtype_id'],
      mealtypeName: json['mealtype_name'],
      products: products,
    );
  }
}

class Product {
  final int menuId;
  final String menuName;
  final String menuImage;

  Product({
    required this.menuId,
    required this.menuName,
    required this.menuImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      menuId: json['menu_id'],
      menuName: json['menu_name'],
      menuImage: json['menu_image'],
    );
  }
}
List<MealType> parseMealTypes(dynamic response) {
  List<MealType> mealTypes = [];

  if (response['plan'] != null) {
    List<dynamic> plans = response['plan'];

    plans.forEach((plan) {
      if (plan['sub_plans'] != null) {
        List<dynamic> subPlans = plan['sub_plans'];

        subPlans.forEach((subPlan) {
          if (subPlan['meal_plan'] != null) {
            List<dynamic> mealPlan = subPlan['meal_plan'];

            mealPlan.forEach((meal) {
              if (meal['products'] != null) {
                Map<String, dynamic> products = meal['products'];
                List<Product> productList = [];

                products.forEach((key, value) {
                  if (value != null) {
                    List<dynamic> items = value;
                    List<Product> productsList = items.map((item) => Product.fromJson(item)).toList();
                    productList.addAll(productsList);
                  }
                });

                mealTypes.add(MealType(
                  mealtypeId: meal['mealtype_id'],
                  mealtypeName: meal['mealtype_name'],
                  products: productList,
                ));
              }
            });
          }
        });
      }
    });
  }

  return mealTypes;
}
