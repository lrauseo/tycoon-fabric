import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tycoon_fabric/main.dart';
import 'package:tycoon_fabric/models/factory.dart';
import 'package:tycoon_fabric/models/product.dart';
import 'package:tycoon_fabric/models/employee.dart';
import 'package:tycoon_fabric/services/game_service.dart';

void main() {
  group('Factory Model Tests', () {
    test('Factory should initialize with default values', () {
      final factory = Factory(name: 'Test Factory');
      
      expect(factory.name, 'Test Factory');
      expect(factory.size, FactorySize.workshop);
      expect(factory.money, 10000.0);
      expect(factory.reputation, 50);
      expect(factory.employees.isEmpty, true);
      expect(factory.productionLines.isEmpty, true);
    });

    test('Factory size should update based on employee count', () {
      final factory = Factory(name: 'Test Factory');
      
      // Add employees
      for (int i = 0; i < 3; i++) {
        factory.employees.add(Employee.generateRandom());
      }
      factory.updateSize();
      expect(factory.size, FactorySize.workshop);
      
      // Add more employees
      for (int i = 0; i < 15; i++) {
        factory.employees.add(Employee.generateRandom());
      }
      factory.updateSize();
      expect(factory.size, FactorySize.smallFactory);
    });

    test('Employee hiring should consume money', () {
      final factory = Factory(name: 'Test Factory');
      final initialMoney = factory.money;
      final employee = Employee.generateRandom();
      
      final hired = factory.hireEmployee(employee);
      
      expect(hired, true);
      expect(factory.money, lessThan(initialMoney));
      expect(factory.employees.length, 1);
    });
  });

  group('Product Model Tests', () {
    test('Products should have correct profit calculations', () {
      final products = Product.getDefaultProducts();
      
      expect(products.isNotEmpty, true);
      
      for (final product in products) {
        expect(product.profitMargin, product.basePrice - product.baseCost);
        expect(product.profitPercent, (product.profitMargin / product.baseCost) * 100);
      }
    });

    test('Products should have required materials', () {
      final products = Product.getDefaultProducts();
      
      for (final product in products) {
        expect(product.requiredMaterials.isNotEmpty, true);
        expect(product.productionTime, greaterThan(0));
      }
    });
  });

  group('Employee Model Tests', () {
    test('Employee should generate with valid attributes', () {
      final employee = Employee.generateRandom();
      
      expect(employee.name.isNotEmpty, true);
      expect(employee.skill, inInclusiveRange(0.0, 1.0));
      expect(employee.satisfaction, inInclusiveRange(0.0, 1.0));
      expect(employee.baseSalary, greaterThan(0));
    });

    test('Employee satisfaction should affect productivity', () {
      final employee = Employee.generateRandom();
      final initialProductivity = employee.effectiveProductivity;
      
      employee.updateSatisfaction(-0.5);
      final newProductivity = employee.effectiveProductivity;
      
      expect(newProductivity, lessThan(initialProductivity));
    });

    test('Training should improve skill', () {
      final employee = Employee.generateRandom();
      final initialSkill = employee.skill;
      
      employee.train();
      employee.completeTraining();
      
      expect(employee.skill, greaterThan(initialSkill));
    });
  });

  group('Game Service Tests', () {
    test('Game service should initialize properly', () {
      final gameService = GameService();
      gameService.initializeGame('Test Factory');
      
      expect(gameService.currentFactory, isNotNull);
      expect(gameService.currentFactory!.name, 'Test Factory');
      expect(gameService.availableProducts.isNotEmpty, true);
      expect(gameService.marketNiches.isNotEmpty, true);
    });

    test('Should be able to hire employees through service', () {
      final gameService = GameService();
      gameService.initializeGame('Test Factory');
      
      final initialEmployeeCount = gameService.currentFactory!.employees.length;
      final hired = gameService.hireEmployee();
      
      expect(hired, true);
      expect(gameService.currentFactory!.employees.length, initialEmployeeCount + 1);
    });

    test('Should be able to add production lines', () {
      final gameService = GameService();
      gameService.initializeGame('Test Factory');
      
      final initialLineCount = gameService.currentFactory!.productionLines.length;
      final added = gameService.addProductionLine('smartphone');
      
      expect(added, true);
      expect(gameService.currentFactory!.productionLines.length, initialLineCount + 1);
    });
  });

  group('Widget Tests', () {
    testWidgets('App should start without errors', (WidgetTester tester) async {
      await tester.pumpWidget(TycoonFabricApp());
      
      expect(find.text('TYCOON FABRIC'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should navigate to home screen after splash', (WidgetTester tester) async {
      await tester.pumpWidget(TycoonFabricApp());
      
      // Wait for splash screen timeout
      await tester.pumpAndSettle(Duration(seconds: 3));
      
      expect(find.text('Bem-vindo ao Tycoon Fabric!'), findsOneWidget);
      expect(find.text('Novo Jogo'), findsOneWidget);
    });
  });
}