import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/factory.dart';
import '../models/product.dart';
import '../models/employee.dart';

class ProductionManagementScreen extends StatefulWidget {
  @override
  _ProductionManagementScreenState createState() => _ProductionManagementScreenState();
}

class _ProductionManagementScreenState extends State<ProductionManagementScreen> {
  final GameService gameService = GameService();

  @override
  Widget build(BuildContext context) {
    Factory? factory = gameService.currentFactory;
    if (factory == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Gestão de Produção')),
        body: Center(child: Text('Nenhuma fábrica ativa')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Produção'),
        backgroundColor: Colors.brown[700],
      ),
      body: Column(
        children: [
          // Production summary
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo da Produção',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Linhas ativas: ${factory.productionLines.where((l) => l.status == ProductionLineStatus.running).length}'),
                      Text('Total de linhas: ${factory.productionLines.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Materials inventory
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estoque de Materiais',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: factory.materials.entries.map((entry) => 
                      Chip(
                        label: Text('${_getMaterialName(entry.key)}: ${entry.value}'),
                        backgroundColor: entry.value < 5 ? Colors.red[100] : Colors.green[100],
                      )
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16),

          // Production lines
          Expanded(
            child: factory.productionLines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.factory, size: 64, color: Colors.grey),
                        Text(
                          'Nenhuma linha de produção',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _showAddProductionLineDialog,
                          child: Text('Adicionar Linha de Produção'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: factory.productionLines.length,
                    itemBuilder: (context, index) {
                      ProductionLine line = factory.productionLines[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: _getStatusColor(line.status),
                            child: Icon(
                              _getProductIcon(line.product.type),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(line.product.name),
                          subtitle: Text(
                            '${_getStatusName(line.status)} • '
                            'Taxa: ${line.calculateProductionRate()} un/h • '
                            'Funcionários: ${line.assignedEmployees.length}'
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Detalhes da Produção',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text('Custo: R\$ ${line.product.baseCost}'),
                                  Text('Preço: R\$ ${line.product.basePrice}'),
                                  Text('Margem: R\$ ${line.product.profitMargin}'),
                                  Text('Tempo de produção: ${line.product.productionTime} min'),
                                  Text('Eficiência: ${(line.efficiency * 100).toStringAsFixed(1)}%'),
                                  
                                  SizedBox(height: 16),
                                  Text(
                                    'Materiais Necessários',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...line.product.requiredMaterials.entries.map((entry) =>
                                    Text('• ${_getMaterialName(entry.key)}: ${entry.value}')
                                  ),
                                  
                                  SizedBox(height: 16),
                                  Text(
                                    'Funcionários Atribuídos (${line.assignedEmployees.length})',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (line.assignedEmployees.isEmpty)
                                    Text('Nenhum funcionário atribuído', style: TextStyle(color: Colors.grey)),
                                  ...line.assignedEmployees.map((employee) =>
                                    ListTile(
                                      dense: true,
                                      leading: Icon(Icons.person, size: 20),
                                      title: Text(employee.name, style: TextStyle(fontSize: 14)),
                                      subtitle: Text(
                                        'Produtividade: ${(employee.effectiveProductivity * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.remove_circle, color: Colors.red, size: 20),
                                        onPressed: () => _removeEmployeeFromLine(employee.id, line.id),
                                      ),
                                    )
                                  ),
                                  
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _assignEmployeeToLine(line.id),
                                        icon: Icon(Icons.person_add, size: 16),
                                        label: Text('Atribuir Funcionário'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: line.status == ProductionLineStatus.running
                                            ? () => _toggleProductionLine(line, false)
                                            : () => _toggleProductionLine(line, true),
                                        icon: Icon(
                                          line.status == ProductionLineStatus.running 
                                              ? Icons.pause 
                                              : Icons.play_arrow,
                                          size: 16,
                                        ),
                                        label: Text(
                                          line.status == ProductionLineStatus.running 
                                              ? 'Parar' 
                                              : 'Iniciar'
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: line.status == ProductionLineStatus.running 
                                              ? Colors.orange 
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductionLineDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.brown[700],
      ),
    );
  }

  Color _getStatusColor(ProductionLineStatus status) {
    switch (status) {
      case ProductionLineStatus.running:
        return Colors.green;
      case ProductionLineStatus.stopped:
        return Colors.grey;
      case ProductionLineStatus.maintenance:
        return Colors.orange;
    }
  }

  String _getStatusName(ProductionLineStatus status) {
    switch (status) {
      case ProductionLineStatus.running:
        return 'Funcionando';
      case ProductionLineStatus.stopped:
        return 'Parada';
      case ProductionLineStatus.maintenance:
        return 'Manutenção';
    }
  }

  IconData _getProductIcon(ProductType type) {
    switch (type) {
      case ProductType.electronics:
        return Icons.smartphone;
      case ProductType.clothing:
        return Icons.checkroom;
      case ProductType.cars:
        return Icons.directions_car;
      case ProductType.medicines:
        return Icons.medical_services;
    }
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

  void _showAddProductionLineDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Linha de Produção'),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Selecione um produto para produzir:'),
              SizedBox(height: 16),
              ...gameService.availableProducts.map((product) => 
                ListTile(
                  leading: Icon(_getProductIcon(product.type)),
                  title: Text(product.name),
                  subtitle: Text('Margem: R\$ ${product.profitMargin.toStringAsFixed(2)}'),
                  onTap: () {
                    gameService.addProductionLine(product.id);
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Linha de produção de ${product.name} adicionada!')),
                    );
                  },
                )
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _assignEmployeeToLine(String lineId) {
    Factory? factory = gameService.currentFactory;
    if (factory == null) return;

    List<Employee> availableEmployees = factory.employees.where((e) => 
      e.status == EmployeeStatus.working &&
      !factory.productionLines.any((line) => 
        line.assignedEmployees.any((emp) => emp.id == e.id)
      )
    ).toList();

    if (availableEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nenhum funcionário disponível!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Atribuir Funcionário'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: availableEmployees.length,
            itemBuilder: (context, index) {
              Employee employee = availableEmployees[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(employee.name),
                subtitle: Text('${employee.role.name} • Produtividade: ${(employee.effectiveProductivity * 100).toStringAsFixed(0)}%'),
                onTap: () {
                  gameService.assignEmployeeToLine(employee.id, lineId);
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${employee.name} atribuído à linha!')),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _removeEmployeeFromLine(String employeeId, String lineId) {
    Factory? factory = gameService.currentFactory;
    if (factory != null) {
      ProductionLine? line = factory.productionLines.where((l) => l.id == lineId).isNotEmpty
          ? factory.productionLines.where((l) => l.id == lineId).first : null;
      if (line != null) {
        line.assignedEmployees.removeWhere((e) => e.id == employeeId);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Funcionário removido da linha!')),
        );
      }
    }
  }

  void _toggleProductionLine(ProductionLine line, bool start) {
    if (start) {
      if (line.assignedEmployees.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Atribua funcionários antes de iniciar a produção!')),
        );
        return;
      }
      line.startProduction();
    } else {
      line.stopProduction();
    }
    setState(() {});
  }
}