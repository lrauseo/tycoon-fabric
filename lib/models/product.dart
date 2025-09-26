enum ProductType {
  electronics,
  clothing,
  cars,
  medicines,
}

class Product {
  final String id;
  final String name;
  final ProductType type;
  final double baseCost;
  final double basePrice;
  final int productionTime; // in minutes
  final Map<String, int> requiredMaterials;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.baseCost,
    required this.basePrice,
    required this.productionTime,
    required this.requiredMaterials,
  });

  double get profitMargin => basePrice - baseCost;
  double get profitPercent => (profitMargin / baseCost) * 100;

  static List<Product> getDefaultProducts() {
    return [
      // Electronics
      Product(
        id: 'smartphone',
        name: 'Smartphone',
        type: ProductType.electronics,
        baseCost: 200.0,
        basePrice: 500.0,
        productionTime: 120,
        requiredMaterials: {'silicon': 2, 'plastic': 1, 'metal': 1},
      ),
      Product(
        id: 'laptop',
        name: 'Laptop',
        type: ProductType.electronics,
        baseCost: 400.0,
        basePrice: 1000.0,
        productionTime: 180,
        requiredMaterials: {'silicon': 4, 'plastic': 2, 'metal': 2},
      ),
      
      // Clothing
      Product(
        id: 'tshirt',
        name: 'T-Shirt',
        type: ProductType.clothing,
        baseCost: 5.0,
        basePrice: 20.0,
        productionTime: 30,
        requiredMaterials: {'cotton': 2},
      ),
      Product(
        id: 'jeans',
        name: 'Jeans',
        type: ProductType.clothing,
        baseCost: 15.0,
        basePrice: 60.0,
        productionTime: 45,
        requiredMaterials: {'cotton': 3, 'dye': 1},
      ),
      
      // Cars
      Product(
        id: 'sedan',
        name: 'Sedan Car',
        type: ProductType.cars,
        baseCost: 15000.0,
        basePrice: 30000.0,
        productionTime: 600,
        requiredMaterials: {'steel': 10, 'plastic': 5, 'rubber': 4},
      ),
      
      // Medicines
      Product(
        id: 'painkiller',
        name: 'Painkiller',
        type: ProductType.medicines,
        baseCost: 2.0,
        basePrice: 10.0,
        productionTime: 60,
        requiredMaterials: {'chemicals': 1},
      ),
    ];
  }
}