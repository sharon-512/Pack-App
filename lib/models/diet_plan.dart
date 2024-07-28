class DietPlan {
  final bool status;
  final String message;
  final List<Plan> plans;

  DietPlan({
    required this.status,
    required this.message,
    required this.plans,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    var list = json['plan'] as List;
    List<Plan> planList = list.map((i) => Plan.fromJson(i)).toList();
    return DietPlan(
      status: json['status'],
      message: json['message'],
      plans: planList,
    );
  }
}

class Plan {
  final int planId;
  final String planName;

  Plan({
    required this.planId,
    required this.planName,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['plan_id'],
      planName: json['plan_name'],
    );
  }
}
