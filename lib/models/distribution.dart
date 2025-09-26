enum TransportType {
  truck,
  train,
  ship,
}

enum ContractStatus {
  pending,
  active,
  completed,
  cancelled,
}

class TransportMethod {
  final TransportType type;
  final String name;
  final double costPerKm;
  final double speedKmH;
  final int capacity;
  final double reliability; // 0.0 to 1.0

  TransportMethod({
    required this.type,
    required this.name,
    required this.costPerKm,
    required this.speedKmH,
    required this.capacity,
    required this.reliability,
  });

  static List<TransportMethod> getDefaultMethods() {
    return [
      TransportMethod(
        type: TransportType.truck,
        name: 'Caminhão Local',
        costPerKm: 2.5,
        speedKmH: 60,
        capacity: 1000,
        reliability: 0.9,
      ),
      TransportMethod(
        type: TransportType.truck,
        name: 'Caminhão Longa Distância',
        costPerKm: 1.8,
        speedKmH: 80,
        capacity: 2000,
        reliability: 0.85,
      ),
      TransportMethod(
        type: TransportType.train,
        name: 'Trem de Carga',
        costPerKm: 1.2,
        speedKmH: 50,
        capacity: 10000,
        reliability: 0.8,
      ),
      TransportMethod(
        type: TransportType.ship,
        name: 'Navio Cargueiro',
        costPerKm: 0.8,
        speedKmH: 25,
        capacity: 50000,
        reliability: 0.75,
      ),
    ];
  }
}

class MarketNiche {
  final String id;
  final String name;
  final String description;
  final List<String> preferredProducts; // product IDs
  final double priceMultiplier;
  final int demandLevel; // 1-10
  final Map<String, double> requirements; // quality, speed, etc.

  MarketNiche({
    required this.id,
    required this.name,
    required this.description,
    required this.preferredProducts,
    required this.priceMultiplier,
    required this.demandLevel,
    required this.requirements,
  });

  static List<MarketNiche> getDefaultNiches() {
    return [
      MarketNiche(
        id: 'luxury',
        name: 'Mercado de Luxo',
        description: 'Clientes dispostos a pagar mais por qualidade premium',
        preferredProducts: ['laptop', 'sedan'],
        priceMultiplier: 1.5,
        demandLevel: 3,
        requirements: {'quality': 0.9, 'reputation': 80},
      ),
      MarketNiche(
        id: 'mass_market',
        name: 'Mercado de Massa',
        description: 'Grande volume, preços competitivos',
        preferredProducts: ['tshirt', 'smartphone'],
        priceMultiplier: 0.9,
        demandLevel: 8,
        requirements: {'price': 0.8, 'availability': 0.9},
      ),
      MarketNiche(
        id: 'budget',
        name: 'Mercado Econômico',
        description: 'Foco em preços baixos',
        preferredProducts: ['tshirt', 'painkiller'],
        priceMultiplier: 0.7,
        demandLevel: 9,
        requirements: {'price': 0.95},
      ),
      MarketNiche(
        id: 'specialized',
        name: 'Mercado Especializado',
        description: 'Produtos específicos para nichos técnicos',
        preferredProducts: ['medicines'],
        priceMultiplier: 1.3,
        demandLevel: 4,
        requirements: {'quality': 0.95, 'compliance': 0.9},
      ),
    ];
  }
}

class Contract {
  final String id;
  final String clientName;
  final String productId;
  final int quantity;
  final double pricePerUnit;
  final DateTime deadline;
  final double distance; // km
  final MarketNiche niche;
  final TransportMethod transportMethod;
  ContractStatus status;
  int deliveredQuantity;
  DateTime? completedDate;

  Contract({
    required this.id,
    required this.clientName,
    required this.productId,
    required this.quantity,
    required this.pricePerUnit,
    required this.deadline,
    required this.distance,
    required this.niche,
    required this.transportMethod,
    this.status = ContractStatus.pending,
    this.deliveredQuantity = 0,
  });

  double get totalValue => quantity * pricePerUnit;
  double get deliveredValue => deliveredQuantity * pricePerUnit;
  double get remainingValue => totalValue - deliveredValue;
  
  double get transportCost => distance * transportMethod.costPerKm;
  double get estimatedProfit => totalValue - transportCost;
  
  int get remainingQuantity => quantity - deliveredQuantity;
  bool get isCompleted => deliveredQuantity >= quantity;
  bool get isOverdue => DateTime.now().isAfter(deadline) && !isCompleted;

  Duration get estimatedDeliveryTime {
    double hours = distance / transportMethod.speedKmH;
    return Duration(hours: hours.round());
  }

  bool deliver(int amount) {
    if (status == ContractStatus.active && amount > 0) {
      deliveredQuantity = (deliveredQuantity + amount).clamp(0, quantity);
      if (isCompleted) {
        status = ContractStatus.completed;
        completedDate = DateTime.now();
      }
      return true;
    }
    return false;
  }

  void activate() {
    if (status == ContractStatus.pending) {
      status = ContractStatus.active;
    }
  }

  void cancel() {
    status = ContractStatus.cancelled;
  }

  static List<String> getRandomClientNames() {
    return [
      'TechnoMax Ltda',
      'Comercial Santos',
      'Distribuidora Silva',
      'Empresa Beta',
      'Grupo Alfa',
      'Indústria Gamma',
      'Comércio Delta',
      'Corporação Omega',
      'Mercado Central',
      'Rede Nacional',
    ];
  }

  static Contract generateRandom({
    required String productId,
    required double basePrice,
    required MarketNiche niche,
  }) {
    final clients = getRandomClientNames();
    final transports = TransportMethod.getDefaultMethods();
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return Contract(
      id: random.toString(),
      clientName: clients[random % clients.length],
      productId: productId,
      quantity: 10 + (random % 100),
      pricePerUnit: basePrice * niche.priceMultiplier,
      deadline: DateTime.now().add(Duration(days: 7 + (random % 21))),
      distance: 50.0 + (random % 500),
      niche: niche,
      transportMethod: transports[random % transports.length],
    );
  }
}