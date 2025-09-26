import 'product.dart';
import 'employee.dart';

enum FactorySize {
  workshop,    // 1-5 employees
  smallFactory, // 6-20 employees
  mediumFactory, // 21-100 employees
  largeFactory, // 101-500 employees
  corporation, // 500+ employees
}

enum ProductionLineStatus {
  stopped,
  running,
  maintenance,
}

class ProductionLine {
  final String id;
  final Product product;
  ProductionLineStatus status;
  List<Employee> assignedEmployees;
  int currentProduction; // units being produced
  DateTime? lastProductionTime;
  double efficiency; // 0.0 to 1.0

  ProductionLine({
    required this.id,
    required this.product,
    this.status = ProductionLineStatus.stopped,
    List<Employee>? assignedEmployees,
    this.currentProduction = 0,
    this.efficiency = 0.8,
  }) : assignedEmployees = assignedEmployees ?? [];

  double get totalProductivity {
    return assignedEmployees
        .map((e) => e.effectiveProductivity)
        .fold(0.0, (a, b) => a + b);
  }

  bool get canProduce => assignedEmployees.isNotEmpty && status == ProductionLineStatus.running;

  int calculateProductionRate() {
    if (!canProduce) return 0;
    double rate = totalProductivity * efficiency;
    return (rate * 60 / product.productionTime).round(); // units per hour
  }

  void startProduction() {
    if (assignedEmployees.isNotEmpty) {
      status = ProductionLineStatus.running;
      lastProductionTime = DateTime.now();
    }
  }

  void stopProduction() {
    status = ProductionLineStatus.stopped;
  }
}

class Factory {
  String name;
  FactorySize size;
  double money;
  List<Employee> employees;
  List<ProductionLine> productionLines;
  Map<String, int> inventory; // materials and finished products
  Map<String, int> materials; // raw materials
  int reputation; // affects contracts and pricing
  DateTime foundedDate;

  Factory({
    required this.name,
    this.size = FactorySize.workshop,
    this.money = 10000.0,
    List<Employee>? employees,
    List<ProductionLine>? productionLines,
    Map<String, int>? inventory,
    Map<String, int>? materials,
    this.reputation = 50,
    DateTime? foundedDate,
  }) : 
    employees = employees ?? [],
    productionLines = productionLines ?? [],
    inventory = inventory ?? {},
    materials = materials ?? {
      'silicon': 10,
      'plastic': 20,
      'metal': 15,
      'cotton': 50,
      'dye': 10,
      'steel': 5,
      'rubber': 10,
      'chemicals': 20,
    },
    foundedDate = foundedDate ?? DateTime.now();

  FactorySize calculateSize() {
    int employeeCount = employees.length;
    if (employeeCount <= 5) return FactorySize.workshop;
    if (employeeCount <= 20) return FactorySize.smallFactory;
    if (employeeCount <= 100) return FactorySize.mediumFactory;
    if (employeeCount <= 500) return FactorySize.largeFactory;
    return FactorySize.corporation;
  }

  void updateSize() {
    size = calculateSize();
  }

  double get totalMonthlySalaries {
    return employees.map((e) => e.currentSalary).fold(0.0, (a, b) => a + b);
  }

  double get averageEmployeeSatisfaction {
    if (employees.isEmpty) return 1.0;
    return employees.map((e) => e.satisfaction).fold(0.0, (a, b) => a + b) / employees.length;
  }

  List<Employee> get unhappyEmployees {
    return employees.where((e) => e.isUnhappy).toList();
  }

  List<Employee> get strikingEmployees {
    return employees.where((e) => e.status == EmployeeStatus.onStrike).toList();
  }

  bool hireEmployee(Employee employee) {
    if (money >= employee.currentSalary) {
      employees.add(employee);
      money -= employee.currentSalary; // first month salary
      updateSize();
      return true;
    }
    return false;
  }

  bool fireEmployee(String employeeId) {
    int index = employees.indexWhere((e) => e.id == employeeId);
    if (index != -1) {
      Employee employee = employees[index];
      employees.removeAt(index);
      
      // Remove from production lines
      for (var line in productionLines) {
        line.assignedEmployees.removeWhere((e) => e.id == employeeId);
      }
      
      // Pay severance (optional)
      money -= employee.currentSalary * 0.5; // half month severance
      updateSize();
      return true;
    }
    return false;
  }

  void addProductionLine(Product product) {
    productionLines.add(ProductionLine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      product: product,
    ));
  }

  bool assignEmployeeToLine(String employeeId, String lineId) {
    Employee? employee = employees.where((e) => e.id == employeeId).firstOrNull;
    ProductionLine? line = productionLines.where((l) => l.id == lineId).firstOrNull;
    
    if (employee != null && line != null) {
      // Remove from other lines first
      for (var otherLine in productionLines) {
        otherLine.assignedEmployees.removeWhere((e) => e.id == employeeId);
      }
      line.assignedEmployees.add(employee);
      return true;
    }
    return false;
  }

  void processMonthlyOperations() {
    // Pay salaries
    money -= totalMonthlySalaries;
    
    // Update employee satisfaction based on various factors
    for (var employee in employees) {
      double satisfactionChange = 0.0;
      
      // Base satisfaction decay
      satisfactionChange -= 0.02;
      
      // Factory size affects satisfaction
      switch (size) {
        case FactorySize.workshop:
          satisfactionChange += 0.01;
        case FactorySize.smallFactory:
          satisfactionChange += 0.005;
        case FactorySize.corporation:
          satisfactionChange -= 0.01;
        default:
          break;
      }
      
      // Low money affects satisfaction
      if (money < totalMonthlySalaries) {
        satisfactionChange -= 0.05;
      }
      
      employee.updateSatisfaction(satisfactionChange);
      employee.experienceMonths++;
      
      // Check for strikes
      if (employee.isLikelyToStrike) {
        employee.goOnStrike();
      }
    }
    
    // Update reputation based on employee satisfaction
    double avgSatisfaction = averageEmployeeSatisfaction;
    if (avgSatisfaction > 0.8) {
      reputation = (reputation + 2).clamp(0, 100);
    } else if (avgSatisfaction < 0.3) {
      reputation = (reputation - 3).clamp(0, 100);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size.name,
      'money': money,
      'reputation': reputation,
      'foundedDate': foundedDate.toIso8601String(),
      'employees': employees.length,
      'productionLines': productionLines.length,
      'materials': materials,
      'inventory': inventory,
    };
  }
}