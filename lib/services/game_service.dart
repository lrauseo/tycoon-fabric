import 'dart:async';
import '../models/factory.dart';
import '../models/product.dart';
import '../models/employee.dart';
import '../models/distribution.dart';

class GameService {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  Factory? _currentFactory;
  List<Product> _availableProducts = [];
  List<MarketNiche> _marketNiches = [];
  List<Contract> _availableContracts = [];
  List<Contract> _activeContracts = [];
  Timer? _gameTimer;
  
  // Game speed: 1 real minute = 1 game hour
  static const Duration gameTickInterval = Duration(seconds: 10);
  DateTime _gameTime = DateTime.now();

  Factory? get currentFactory => _currentFactory;
  List<Product> get availableProducts => _availableProducts;
  List<MarketNiche> get marketNiches => _marketNiches;
  List<Contract> get availableContracts => _availableContracts;
  List<Contract> get activeContracts => _activeContracts;
  DateTime get gameTime => _gameTime;

  void initializeGame(String factoryName) {
    _currentFactory = Factory(name: factoryName);
    _availableProducts = Product.getDefaultProducts();
    _marketNiches = MarketNiche.getDefaultNiches();
    _generateInitialContracts();
    
    // Start the game loop
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(gameTickInterval, _gameTick);
  }

  void _gameTick(Timer timer) {
    if (_currentFactory == null) return;
    
    // Advance game time (10 seconds real time = 1 hour game time)
    _gameTime = _gameTime.add(Duration(hours: 1));
    
    // Process production
    _processProduction();
    
    // Generate new contracts periodically
    if (_gameTime.hour % 6 == 0 && _gameTime.minute == 0) {
      _generateNewContracts();
    }
    
    // Process monthly operations (every 30 game days)
    if (_gameTime.day == 1 && _gameTime.hour == 0) {
      _currentFactory!.processMonthlyOperations();
    }
    
    // Check for completed contracts
    _processContracts();
  }

  void _processProduction() {
    for (var line in _currentFactory!.productionLines) {
      if (line.canProduce) {
        int productionRate = line.calculateProductionRate();
        if (productionRate > 0) {
          // Check if we have materials
          bool canProduce = true;
          for (var material in line.product.requiredMaterials.entries) {
            int required = material.value * productionRate;
            if ((_currentFactory!.materials[material.key] ?? 0) < required) {
              canProduce = false;
              break;
            }
          }
          
          if (canProduce) {
            // Consume materials
            for (var material in line.product.requiredMaterials.entries) {
              int required = material.value * productionRate;
              _currentFactory!.materials[material.key] = 
                (_currentFactory!.materials[material.key] ?? 0) - required;
            }
            
            // Add to inventory
            _currentFactory!.inventory[line.product.id] = 
              (_currentFactory!.inventory[line.product.id] ?? 0) + productionRate;
          }
        }
      }
    }
  }

  void _processContracts() {
    for (var contract in _activeContracts) {
      if (contract.status == ContractStatus.active) {
        // Try to fulfill contract with available inventory
        int available = _currentFactory!.inventory[contract.productId] ?? 0;
        if (available > 0) {
          int toDeliver = available.clamp(0, contract.remainingQuantity);
          if (contract.deliver(toDeliver)) {
            // Remove from inventory
            _currentFactory!.inventory[contract.productId] = available - toDeliver;
            
            // Add money
            _currentFactory!.money += toDeliver * contract.pricePerUnit;
            
            // Subtract transport cost
            double transportCost = contract.transportCost * (toDeliver / contract.quantity);
            _currentFactory!.money -= transportCost;
          }
        }
        
        // Check if contract is overdue
        if (contract.isOverdue) {
          contract.cancel();
          _currentFactory!.reputation = (_currentFactory!.reputation - 5).clamp(0, 100);
        }
      }
    }
    
    // Remove completed or cancelled contracts
    _activeContracts.removeWhere((c) => 
      c.status == ContractStatus.completed || c.status == ContractStatus.cancelled);
  }

  void _generateInitialContracts() {
    _availableContracts.clear();
    for (int i = 0; i < 5; i++) {
      _generateRandomContract();
    }
  }

  void _generateNewContracts() {
    // Generate 1-3 new contracts every 6 hours
    int count = 1 + (_gameTime.millisecondsSinceEpoch % 3);
    for (int i = 0; i < count; i++) {
      _generateRandomContract();
    }
    
    // Remove old contracts that haven't been accepted
    _availableContracts.removeWhere((c) => 
      DateTime.now().difference(c.deadline).inDays > 7);
  }

  void _generateRandomContract() {
    if (_availableProducts.isEmpty || _marketNiches.isEmpty) return;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    final product = _availableProducts[random % _availableProducts.length];
    final niche = _marketNiches[random % _marketNiches.length];
    
    // Only generate contracts for products that match the niche
    if (niche.preferredProducts.contains(product.id)) {
      final contract = Contract.generateRandom(
        productId: product.id,
        basePrice: product.basePrice,
        niche: niche,
      );
      _availableContracts.add(contract);
    }
  }

  bool acceptContract(String contractId) {
    int index = _availableContracts.indexWhere((c) => c.id == contractId);
    if (index != -1) {
      Contract contract = _availableContracts.removeAt(index);
      contract.activate();
      _activeContracts.add(contract);
      return true;
    }
    return false;
  }

  bool hireEmployee() {
    if (_currentFactory == null) return false;
    
    Employee newEmployee = Employee.generateRandom();
    return _currentFactory!.hireEmployee(newEmployee);
  }

  bool fireEmployee(String employeeId) {
    if (_currentFactory == null) return false;
    return _currentFactory!.fireEmployee(employeeId);
  }

  bool addProductionLine(String productId) {
    if (_currentFactory == null) return false;
    
    Product? product = _availableProducts.where((p) => p.id == productId).firstOrNull;
    if (product != null) {
      _currentFactory!.addProductionLine(product);
      return true;
    }
    return false;
  }

  bool assignEmployeeToLine(String employeeId, String lineId) {
    if (_currentFactory == null) return false;
    return _currentFactory!.assignEmployeeToLine(employeeId, lineId);
  }

  void buyMaterials(String materialType, int quantity) {
    if (_currentFactory == null) return;
    
    // Simple pricing: materials cost 10 per unit
    double cost = quantity * 10.0;
    if (_currentFactory!.money >= cost) {
      _currentFactory!.money -= cost;
      _currentFactory!.materials[materialType] = 
        (_currentFactory!.materials[materialType] ?? 0) + quantity;
    }
  }

  void pauseGame() {
    _gameTimer?.cancel();
  }

  void resumeGame() {
    if (_currentFactory != null) {
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(gameTickInterval, _gameTick);
    }
  }

  void dispose() {
    _gameTimer?.cancel();
  }
}