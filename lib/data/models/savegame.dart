import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'savegame.g.dart';

/// Model for save game data using copyWith pattern for immutability
@JsonSerializable()
class SaveGame extends Equatable {
  final int money;
  final Map<String, int> inventory;
  final List<Map<String, dynamic>> components;
  final Map<String, int> productionStats;
  final DateTime lastSaved;
  final String version;
  
  const SaveGame({
    required this.money,
    required this.inventory,
    required this.components,
    required this.productionStats,
    required this.lastSaved,
    required this.version,
  });
  
  /// Create a copy with updated values
  SaveGame copyWith({
    int? money,
    Map<String, int>? inventory,
    List<Map<String, dynamic>>? components,
    Map<String, int>? productionStats,
    DateTime? lastSaved,
    String? version,
  }) {
    return SaveGame(
      money: money ?? this.money,
      inventory: inventory ?? this.inventory,
      components: components ?? this.components,
      productionStats: productionStats ?? this.productionStats,
      lastSaved: lastSaved ?? this.lastSaved,
      version: version ?? this.version,
    );
  }
  
  /// JSON serialization
  factory SaveGame.fromJson(Map<String, dynamic> json) => _$SaveGameFromJson(json);
  Map<String, dynamic> toJson() => _$SaveGameToJson(this);
  
  @override
  List<Object?> get props => [
        money,
        inventory,
        components,
        productionStats,
        lastSaved,
        version,
      ];
  
  /// Create empty save game
  factory SaveGame.empty() {
    return SaveGame(
      money: 1000,
      inventory: const {},
      components: const [],
      productionStats: const {},
      lastSaved: DateTime.now(),
      version: '1.0.0',
    );
  }
  
  /// Validate save game data
  bool isValid() {
    return money >= 0 && 
           version.isNotEmpty &&
           lastSaved.isBefore(DateTime.now().add(const Duration(days: 1)));
  }
}