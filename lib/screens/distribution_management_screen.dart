import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/distribution.dart';
import '../models/factory.dart';

class DistributionManagementScreen extends StatefulWidget {
  @override
  _DistributionManagementScreenState createState() => _DistributionManagementScreenState();
}

class _DistributionManagementScreenState extends State<DistributionManagementScreen> {
  final GameService gameService = GameService();

  @override
  Widget build(BuildContext context) {
    Factory? factory = gameService.currentFactory;
    if (factory == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Gestão de Distribuição')),
        body: Center(child: Text('Nenhuma fábrica ativa')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Distribuição'),
        backgroundColor: Colors.brown[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Inventory summary
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estoque de Produtos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    if (factory.inventory.isEmpty)
                      Text('Nenhum produto em estoque', style: TextStyle(color: Colors.grey))
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: factory.inventory.entries.map((entry) {
                          String productName = gameService.availableProducts
                              .where((p) => p.id == entry.key).isNotEmpty
                                  ? gameService.availableProducts.where((p) => p.id == entry.key).first.name
                                  : entry.key;
                          return Chip(
                            label: Text('$productName: ${entry.value}'),
                            backgroundColor: entry.value > 0 ? Colors.green[100] : Colors.red[100],
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            // Transport methods
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Métodos de Transporte',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ...TransportMethod.getDefaultMethods().map((method) => 
                      Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getTransportColor(method.type),
                            child: Icon(
                              _getTransportIcon(method.type),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(method.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Custo: R\$ ${method.costPerKm}/km'),
                              Text('Velocidade: ${method.speedKmH} km/h'),
                              Text('Capacidade: ${method.capacity} unidades'),
                              Text('Confiabilidade: ${(method.reliability * 100).toStringAsFixed(0)}%'),
                            ],
                          ),
                          trailing: Icon(Icons.info_outline),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Market niches
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nichos de Mercado',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ...gameService.marketNiches.map((niche) => 
                      Card(
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: _getNicheColor(niche.priceMultiplier),
                            child: Text(
                              '${niche.demandLevel}',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(niche.name),
                          subtitle: Text(
                            'Multiplicador de preço: ${niche.priceMultiplier}x • '
                            'Demanda: ${niche.demandLevel}/10'
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(niche.description),
                                  SizedBox(height: 8),
                                  Text(
                                    'Produtos Preferidos:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                    String productName = gameService.availableProducts
                                        .where((p) => p.id == productId).isNotEmpty
                                            ? gameService.availableProducts.where((p) => p.id == productId).first.name
                                            : productId;
                                    return Text('• $productName');
                                  }),
                                  SizedBox(height: 8),
                                  Text(
                                    'Requisitos:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...niche.requirements.entries.map((req) =>
                                    Text('• ${_getRequirementName(req.key)}: ${(req.value * 100).toStringAsFixed(0)}%')
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 100), // Space for floating action button
          ],
        ),
      ),
    );
  }

  Color _getTransportColor(TransportType type) {
    switch (type) {
      case TransportType.truck:
        return Colors.blue;
      case TransportType.train:
        return Colors.green;
      case TransportType.ship:
        return Colors.indigo;
    }
  }

  IconData _getTransportIcon(TransportType type) {
    switch (type) {
      case TransportType.truck:
        return Icons.local_shipping;
      case TransportType.train:
        return Icons.train;
      case TransportType.ship:
        return Icons.directions_boat;
    }
  }

  Color _getNicheColor(double priceMultiplier) {
    if (priceMultiplier >= 1.4) return Colors.purple; // Luxury
    if (priceMultiplier >= 1.1) return Colors.orange; // Premium
    if (priceMultiplier >= 0.9) return Colors.blue;   // Standard
    return Colors.green; // Budget
  }

  String _getRequirementName(String requirement) {
    switch (requirement) {
      case 'quality':
        return 'Qualidade';
      case 'price':
        return 'Preço';
      case 'availability':
        return 'Disponibilidade';
      case 'reputation':
        return 'Reputação';
      case 'compliance':
        return 'Conformidade';
      case 'speed':
        return 'Velocidade';
      default:
        return requirement;
    }
  }
}

class ContractsManagementScreen extends StatefulWidget {
  @override
  _ContractsManagementScreenState createState() => _ContractsManagementScreenState();
}

class _ContractsManagementScreenState extends State<ContractsManagementScreen> {
  final GameService gameService = GameService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestão de Contratos'),
          backgroundColor: Colors.brown[700],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Disponíveis (${gameService.availableContracts.length})'),
              Tab(text: 'Ativos (${gameService.activeContracts.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAvailableContracts(),
            _buildActiveContracts(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableContracts() {
    if (gameService.availableContracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment, size: 64, color: Colors.grey),
            Text(
              'Nenhum contrato disponível',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Novos contratos aparecem a cada 6 horas de jogo',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: gameService.availableContracts.length,
      itemBuilder: (context, index) {
        Contract contract = gameService.availableContracts[index];
        String productName = gameService.availableProducts
            .where((p) => p.id == contract.productId).isNotEmpty
                ? gameService.availableProducts.where((p) => p.id == contract.productId).first.name
                : contract.productId;

        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.assignment, color: Colors.white),
            ),
            title: Text(contract.clientName),
            subtitle: Text(
              '$productName • ${contract.quantity} unidades • '
              'R\$ ${contract.totalValue.toStringAsFixed(2)}'
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Produto: $productName'),
                        Text('Quantidade: ${contract.quantity}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Preço unitário: R\$ ${contract.pricePerUnit.toStringAsFixed(2)}'),
                        Text('Valor total: R\$ ${contract.totalValue.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Distância: ${contract.distance.toStringAsFixed(0)} km'),
                        Text('Prazo: ${contract.deadline.day}/${contract.deadline.month}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Transporte: ${contract.transportMethod.name}'),
                        Text('Custo transporte: R\$ ${contract.transportCost.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nicho: ${contract.niche.name}'),
                        Text(
                          'Lucro estimado: R\$ ${contract.estimatedProfit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: contract.estimatedProfit > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (gameService.acceptContract(contract.id)) {
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Contrato aceito com ${contract.clientName}!')),
                            );
                          }
                        },
                        child: Text('Aceitar Contrato'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveContracts() {
    if (gameService.activeContracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work, size: 64, color: Colors.grey),
            Text(
              'Nenhum contrato ativo',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Aceite contratos para começar a vender',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: gameService.activeContracts.length,
      itemBuilder: (context, index) {
        Contract contract = gameService.activeContracts[index];
        String productName = gameService.availableProducts
            .where((p) => p.id == contract.productId).isNotEmpty
                ? gameService.availableProducts.where((p) => p.id == contract.productId).first.name
                : contract.productId;

        double progress = contract.deliveredQuantity / contract.quantity;
        bool isOverdue = contract.isOverdue;

        return Card(
          color: isOverdue ? Colors.red[50] : null,
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: isOverdue ? Colors.red : (contract.isCompleted ? Colors.green : Colors.orange),
              child: Icon(
                contract.isCompleted ? Icons.check : (isOverdue ? Icons.warning : Icons.hourglass_empty),
                color: Colors.white,
              ),
            ),
            title: Text(contract.clientName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$productName • ${contract.deliveredQuantity}/${contract.quantity} entregue'),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverdue ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isOverdue)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'CONTRATO EM ATRASO!',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Progresso: ${(progress * 100).toStringAsFixed(1)}%'),
                        Text('Restante: ${contract.remainingQuantity} unidades'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Valor entregue: R\$ ${contract.deliveredValue.toStringAsFixed(2)}'),
                        Text('Valor restante: R\$ ${contract.remainingValue.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Prazo: ${contract.deadline.day}/${contract.deadline.month}'),
                        Text('Tempo estimado: ${contract.estimatedDeliveryTime.inHours}h'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}