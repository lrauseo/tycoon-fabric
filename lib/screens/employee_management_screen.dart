import 'package:flutter/material.dart';
import '../services/game_service.dart';
import '../models/employee.dart';
import '../models/factory.dart';

class EmployeeManagementScreen extends StatefulWidget {
  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final GameService gameService = GameService();

  @override
  Widget build(BuildContext context) {
    Factory? factory = gameService.currentFactory;
    if (factory == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Gestão de Funcionários')),
        body: Center(child: Text('Nenhuma fábrica ativa')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de Funcionários'),
        backgroundColor: Colors.brown[700],
      ),
      body: Column(
        children: [
          // Summary card
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo dos Funcionários',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: ${factory.employees.length}'),
                      Text('Salários/mês: R\$ ${factory.totalMonthlySalaries.toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Satisfação média: ${(factory.averageEmployeeSatisfaction * 100).toStringAsFixed(1)}%'),
                      Text('Em greve: ${factory.strikingEmployees.length}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Employee list
          Expanded(
            child: ListView.builder(
              itemCount: factory.employees.length,
              itemBuilder: (context, index) {
                Employee employee = factory.employees[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(employee.status),
                      child: Icon(
                        _getRoleIcon(employee.role),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(employee.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${_getRoleName(employee.role)} • ${_getStatusName(employee.status)}'),
                        Text('Habilidade: ${(employee.skill * 100).toStringAsFixed(0)}% • '
                            'Satisfação: ${(employee.satisfaction * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'R\$ ${employee.currentSalary.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${employee.experienceMonths} meses',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    onTap: () => _showEmployeeDetails(employee),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (gameService.hireEmployee()) {
            setState(() {});
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Novo funcionário contratado!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Dinheiro insuficiente para contratar!')),
            );
          }
        },
        child: Icon(Icons.person_add),
        backgroundColor: Colors.brown[700],
      ),
    );
  }

  Color _getStatusColor(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.working:
        return Colors.green;
      case EmployeeStatus.training:
        return Colors.blue;
      case EmployeeStatus.onStrike:
        return Colors.red;
      case EmployeeStatus.fired:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.worker:
        return Icons.build;
      case EmployeeRole.supervisor:
        return Icons.supervisor_account;
      case EmployeeRole.engineer:
        return Icons.engineering;
      case EmployeeRole.manager:
        return Icons.manage_accounts;
    }
  }

  String _getRoleName(EmployeeRole role) {
    switch (role) {
      case EmployeeRole.worker:
        return 'Operário';
      case EmployeeRole.supervisor:
        return 'Supervisor';
      case EmployeeRole.engineer:
        return 'Engenheiro';
      case EmployeeRole.manager:
        return 'Gerente';
    }
  }

  String _getStatusName(EmployeeStatus status) {
    switch (status) {
      case EmployeeStatus.working:
        return 'Trabalhando';
      case EmployeeStatus.training:
        return 'Treinamento';
      case EmployeeStatus.onStrike:
        return 'Em Greve';
      case EmployeeStatus.fired:
        return 'Demitido';
    }
  }

  void _showEmployeeDetails(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(employee.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cargo: ${_getRoleName(employee.role)}'),
            Text('Status: ${_getStatusName(employee.status)}'),
            Text('Salário: R\$ ${employee.currentSalary.toStringAsFixed(2)}'),
            Text('Habilidade: ${(employee.skill * 100).toStringAsFixed(1)}%'),
            Text('Satisfação: ${(employee.satisfaction * 100).toStringAsFixed(1)}%'),
            Text('Produtividade: ${(employee.effectiveProductivity * 100).toStringAsFixed(1)}%'),
            Text('Experiência: ${employee.experienceMonths} meses'),
            Text('Contratado em: ${employee.hiredDate.day}/${employee.hiredDate.month}/${employee.hiredDate.year}'),
            if (employee.isUnhappy)
              Text(
                'Funcionário insatisfeito!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            if (employee.isLikelyToStrike)
              Text(
                'Risco de greve!',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          if (employee.status == EmployeeStatus.working)
            TextButton(
              onPressed: () {
                employee.train();
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${employee.name} está em treinamento')),
                );
              },
              child: Text('Treinar'),
            ),
          if (employee.status == EmployeeStatus.onStrike)
            TextButton(
              onPressed: () {
                employee.endStrike();
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${employee.name} voltou ao trabalho')),
                );
              },
              child: Text('Negociar'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmFireEmployee(employee);
            },
            child: Text('Demitir', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _confirmFireEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Demitir Funcionário'),
        content: Text('Tem certeza que deseja demitir ${employee.name}? '
            'Isso custará R\$ ${(employee.currentSalary * 0.5).toStringAsFixed(2)} de indenização.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (gameService.fireEmployee(employee.id)) {
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${employee.name} foi demitido')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Demitir'),
          ),
        ],
      ),
    );
  }
}