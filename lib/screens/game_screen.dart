import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/factory.dart';
import '../models/employee.dart';

class TycoonGame extends FlameGame with HasTappables {
  late GameService gameService;
  late TextComponent moneyText;
  late TextComponent reputationText;
  late TextComponent employeesText;
  late TextComponent factorySizeText;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    gameService = GameService();
    
    // Initialize UI components
    moneyText = TextComponent(
      text: 'Dinheiro: R\$ 0',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    
    reputationText = TextComponent(
      text: 'Reputação: 0',
      position: Vector2(20, 50),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    
    employeesText = TextComponent(
      text: 'Funcionários: 0',
      position: Vector2(20, 80),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    
    factorySizeText = TextComponent(
      text: 'Tamanho: Oficina',
      position: Vector2(20, 110),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    
    add(moneyText);
    add(reputationText);
    add(employeesText);
    add(factorySizeText);
    
    // Initialize game
    gameService.initializeGame('Minha Fábrica');
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateUI();
  }

  void updateUI() {
    Factory? factory = gameService.currentFactory;
    if (factory != null) {
      moneyText.text = 'Dinheiro: R\$ ${factory.money.toStringAsFixed(2)}';
      reputationText.text = 'Reputação: ${factory.reputation}';
      employeesText.text = 'Funcionários: ${factory.employees.length}';
      factorySizeText.text = 'Tamanho: ${_getFactorySizeName(factory.size)}';
    }
  }

  String _getFactorySizeName(FactorySize size) {
    switch (size) {
      case FactorySize.workshop:
        return 'Oficina';
      case FactorySize.smallFactory:
        return 'Fábrica Pequena';
      case FactorySize.mediumFactory:
        return 'Fábrica Média';
      case FactorySize.largeFactory:
        return 'Fábrica Grande';
      case FactorySize.corporation:
        return 'Corporação';
    }
  }

  @override
  void onRemove() {
    gameService.dispose();
    super.onRemove();
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late TycoonGame game;

  @override
  void initState() {
    super.initState();
    game = TycoonGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tycoon Fabric'),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: _showEmployeeManagement,
          ),
          IconButton(
            icon: Icon(Icons.factory),
            onPressed: _showProductionManagement,
          ),
          IconButton(
            icon: Icon(Icons.local_shipping),
            onPressed: _showDistributionManagement,
          ),
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: _showContractsManagement,
          ),
        ],
      ),
      body: GameWidget(game: game),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActions,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[700],
      ),
    );
  }

  void _showEmployeeManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeManagementScreen()),
    );
  }

  void _showProductionManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductionManagementScreen()),
    );
  }

  void _showDistributionManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DistributionManagementScreen()),
    );
  }

  void _showContractsManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContractsManagementScreen()),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => QuickActionsPanel(),
    );
  }
}

class QuickActionsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ações Rápidas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Contratar Funcionário'),
            onTap: () {
              GameService().hireEmployee();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Funcionário contratado!')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Comprar Materiais'),
            onTap: () {
              Navigator.pop(context);
              _showMaterialsPurchase(context);
            },
          ),
        ],
      ),
    );
  }

  void _showMaterialsPurchase(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MaterialsPurchaseDialog(),
    );
  }
}

class MaterialsPurchaseDialog extends StatefulWidget {
  @override
  _MaterialsPurchaseDialogState createState() => _MaterialsPurchaseDialogState();
}

class _MaterialsPurchaseDialogState extends State<MaterialsPurchaseDialog> {
  final Map<String, int> quantities = {
    'silicon': 0,
    'plastic': 0,
    'metal': 0,
    'cotton': 0,
    'dye': 0,
    'steel': 0,
    'rubber': 0,
    'chemicals': 0,
  };

  @override
  Widget build(BuildContext context) {
    double totalCost = quantities.values.fold(0.0, (sum, qty) => sum + (qty * 10));
    
    return AlertDialog(
      title: Text('Comprar Materiais'),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Preço por unidade: R\$ 10,00'),
            SizedBox(height: 16),
            ...quantities.keys.map((material) => Row(
              children: [
                Expanded(child: Text(_getMaterialName(material))),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantities[material]! > 0) {
                        quantities[material] = quantities[material]! - 1;
                      }
                    });
                  },
                ),
                Text('${quantities[material]}'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantities[material] = quantities[material]! + 1;
                    });
                  },
                ),
              ],
            )),
            SizedBox(height: 16),
            Text(
              'Total: R\$ ${totalCost.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: totalCost > 0 ? () {
            for (var entry in quantities.entries) {
              if (entry.value > 0) {
                GameService().buyMaterials(entry.key, entry.value);
              }
            }
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Materiais comprados!')),
            );
          } : null,
          child: Text('Comprar'),
        ),
      ],
    );
  }

  String _getMaterialName(String material) {
    switch (material) {
      case 'silicon': return 'Silício';
      case 'plastic': return 'Plástico';
      case 'metal': return 'Metal';
      case 'cotton': return 'Algodão';
      case 'dye': return 'Tinta';
      case 'steel': return 'Aço';
      case 'rubber': return 'Borracha';
      case 'chemicals': return 'Químicos';
      default: return material;
    }
  }
}