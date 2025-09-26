import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/factory_game.dart';
import '../../data/models/savegame.dart';

/// Manages save/load functionality using Hive for local persistence
class SaveService {
  static const String _saveBoxName = 'savegame';
  static const String _saveKey = 'current_save';
  
  late Box _saveBox;
  
  /// Initialize the save service
  Future<void> init(FactoryGame gameRef) async {
    try {
      _saveBox = await Hive.openBox(_saveBoxName);
    } catch (e) {
      // Handle error opening box
      print('Error opening save box: $e');
      rethrow;
    }
  }
  
  /// Save current game state
  Future<bool> saveGame(SaveGame saveGame) async {
    try {
      final saveData = saveGame.toJson();
      await _saveBox.put(_saveKey, saveData);
      return true;
    } catch (e) {
      print('Error saving game: $e');
      return false;
    }
  }
  
  /// Load saved game state
  Future<SaveGame?> loadGame() async {
    try {
      final saveData = _saveBox.get(_saveKey);
      if (saveData == null) {
        return null;
      }
      
      return SaveGame.fromJson(Map<String, dynamic>.from(saveData));
    } catch (e) {
      print('Error loading game: $e');
      return null;
    }
  }
  
  /// Check if a save file exists
  bool hasSaveFile() {
    return _saveBox.containsKey(_saveKey);
  }
  
  /// Delete current save file
  Future<bool> deleteSave() async {
    try {
      await _saveBox.delete(_saveKey);
      return true;
    } catch (e) {
      print('Error deleting save: $e');
      return false;
    }
  }
  
  /// Create a new save from current game state
  SaveGame createSaveFromGameState(
    int money,
    Map<String, int> inventory,
    List<Map<String, dynamic>> components,
    Map<String, int> productionStats,
  ) {
    return SaveGame(
      money: money,
      inventory: inventory,
      components: components,
      productionStats: productionStats,
      lastSaved: DateTime.now(),
      version: '1.0.0',
    );
  }
  
  /// Auto-save functionality
  Future<void> autoSave(FactoryGame gameRef) async {
    final saveGame = createSaveFromGameState(
      gameRef.economyService.getCurrentMoney(),
      gameRef.inventoryService.getAllItems(),
      [], // TODO: Serialize components
      gameRef.productionService.getProductionStats(),
    );
    
    await saveGame(saveGame);
  }
  
  /// Get save file metadata
  Map<String, dynamic>? getSaveMetadata() {
    try {
      final saveData = _saveBox.get(_saveKey);
      if (saveData == null) return null;
      
      final data = Map<String, dynamic>.from(saveData);
      return {
        'lastSaved': data['lastSaved'],
        'version': data['version'],
        'money': data['money'],
        'components': (data['components'] as List?)?.length ?? 0,
      };
    } catch (e) {
      print('Error getting save metadata: $e');
      return null;
    }
  }
}