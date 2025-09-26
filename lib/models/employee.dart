enum EmployeeRole {
  worker,
  supervisor,
  engineer,
  manager,
}

enum EmployeeStatus {
  working,
  training,
  onStrike,
  fired,
}

class Employee {
  final String id;
  final String name;
  final EmployeeRole role;
  final double baseSalary;
  double skill; // 0.0 to 1.0
  double satisfaction; // 0.0 to 1.0
  double productivity; // 0.0 to 2.0
  EmployeeStatus status;
  int experienceMonths;
  DateTime hiredDate;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.baseSalary,
    this.skill = 0.3,
    this.satisfaction = 0.7,
    this.productivity = 1.0,
    this.status = EmployeeStatus.working,
    this.experienceMonths = 0,
    DateTime? hiredDate,
  }) : hiredDate = hiredDate ?? DateTime.now();

  double get currentSalary => baseSalary * (1 + (skill * 0.5));
  
  double get effectiveProductivity {
    double base = productivity * skill * satisfaction;
    if (status == EmployeeStatus.onStrike) return 0.0;
    if (status == EmployeeStatus.training) return 0.3;
    return base;
  }

  bool get isUnhappy => satisfaction < 0.3;
  bool get isLikelyToStrike => satisfaction < 0.2 && skill > 0.6;

  void updateSatisfaction(double change) {
    satisfaction = (satisfaction + change).clamp(0.0, 1.0);
  }

  void updateSkill(double change) {
    skill = (skill + change).clamp(0.0, 1.0);
  }

  void train() {
    if (status == EmployeeStatus.working) {
      status = EmployeeStatus.training;
      // Training will improve skill over time
    }
  }

  void completeTraining() {
    if (status == EmployeeStatus.training) {
      status = EmployeeStatus.working;
      updateSkill(0.1);
      updateSatisfaction(0.05);
    }
  }

  void goOnStrike() {
    if (isLikelyToStrike) {
      status = EmployeeStatus.onStrike;
    }
  }

  void endStrike() {
    if (status == EmployeeStatus.onStrike) {
      status = EmployeeStatus.working;
    }
  }

  static List<String> getRandomNames() {
    return [
      'João Silva', 'Maria Santos', 'Pedro Oliveira', 'Ana Costa',
      'Carlos Pereira', 'Lucia Ferreira', 'Miguel Rodrigues', 'Sofia Almeida',
      'Ricardo Martins', 'Isabel Gomes', 'Fernando Lima', 'Carla Ribeiro',
    ];
  }

  static Employee generateRandom() {
    final names = getRandomNames();
    final roles = EmployeeRole.values;
    final name = names[DateTime.now().millisecondsSinceEpoch % names.length];
    final role = roles[DateTime.now().millisecondsSinceEpoch % roles.length];
    
    double salary = switch (role) {
      EmployeeRole.worker => 1200.0,
      EmployeeRole.supervisor => 2000.0,
      EmployeeRole.engineer => 3500.0,
      EmployeeRole.manager => 5000.0,
    };

    return Employee(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      role: role,
      baseSalary: salary,
      skill: 0.2 + (DateTime.now().millisecondsSinceEpoch % 60) / 100.0,
      satisfaction: 0.5 + (DateTime.now().millisecondsSinceEpoch % 40) / 100.0,
    );
  }
}