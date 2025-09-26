import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'item_component.dart';

/// Machine component with input/output slots, processing time, and failure rates
class MachineComponent extends SpriteComponent with HasGameRef, TapCallbacks {
  final String machineType;
  final int processingTime; // in ticks
  final double failureRate; // 0.0 to 1.0
  
  // Input/Output slots
  final List<ItemComponent> inputSlots = [];
  final List<ItemComponent> outputSlots = [];
  final int maxInputSlots;
  final int maxOutputSlots;
  
  // Processing state
  ItemComponent? _currentItem;
  int _processingTicks = 0;
  bool _isProcessing = false;
  
  MachineComponent({
    required this.machineType,
    required Vector2 position,
    this.processingTime = 5,
    this.failureRate = 0.1,
    this.maxInputSlots = 2,
    this.maxOutputSlots = 2,
  }) : super(
          position: position,
          size: Vector2(96, 96), // Larger than conveyor
        );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // TODO: Load machine sprite based on machineType
    // sprite = await Sprite.load('machine_$machineType.png');
    
    // Placeholder: Create a colored rectangle
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF696969), // Gray machine
    ));
    
    // Add machine type label
    _addMachineLabel();
  }
  
  void _addMachineLabel() {
    // Add text component to show machine type
    final label = TextComponent(
      text: machineType,
      position: Vector2(5, 5),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
        ),
      ),
    );
    add(label);
  }
  
  /// Process production on each tick
  void processProduction() {
    if (_isProcessing) {
      _processingTicks++;
      
      if (_processingTicks >= processingTime) {
        _completeProcessing();
      }
    } else {
      _tryStartProcessing();
    }
  }
  
  void _tryStartProcessing() {
    // Check if we have input items and output space
    if (inputSlots.isNotEmpty && outputSlots.length < maxOutputSlots) {
      _currentItem = inputSlots.removeAt(0);
      _isProcessing = true;
      _processingTicks = 0;
    }
  }
  
  void _completeProcessing() {
    if (_currentItem == null) return;
    
    // Check for processing failure
    if (_random.nextDouble() < failureRate) {
      // Processing failed - item is lost
      _currentItem?.removeFromParent();
    } else {
      // Processing succeeded - create output item
      final outputItem = _createOutputItem(_currentItem!);
      outputSlots.add(outputItem);
      add(outputItem);
    }
    
    _currentItem = null;
    _isProcessing = false;
    _processingTicks = 0;
  }
  
  ItemComponent _createOutputItem(ItemComponent inputItem) {
    // Transform input item into output item based on recipe
    // For now, just create a basic processed item
    return ItemComponent(
      itemType: '${inputItem.itemType}_processed',
      position: Vector2(size.x - 20, size.y / 2),
    );
  }
  
  /// Add item to input slot
  bool addInputItem(ItemComponent item) {
    if (inputSlots.length < maxInputSlots) {
      inputSlots.add(item);
      item.position = Vector2(10, size.y / 2);
      add(item);
      return true;
    }
    return false;
  }
  
  /// Remove item from output slot
  ItemComponent? removeOutputItem() {
    if (outputSlots.isNotEmpty) {
      final item = outputSlots.removeAt(0);
      remove(item);
      return item;
    }
    return null;
  }
  
  /// Check if machine can accept input
  bool canAcceptInput() {
    return inputSlots.length < maxInputSlots;
  }
  
  /// Check if machine has output ready
  bool hasOutput() {
    return outputSlots.isNotEmpty;
  }
  
  /// Get processing progress (0.0 to 1.0)
  double getProcessingProgress() {
    if (!_isProcessing) return 0.0;
    return _processingTicks / processingTime;
  }
  
  @override
  bool onTapDown(TapDownEvent event) {
    // Handle machine selection/interaction
    print('Machine $_machineType tapped - Processing: $_isProcessing, Progress: ${getProcessingProgress()}');
    return true;
  }
  
  // Random number generator for failure calculation
  static final _random = Random();
}

// Import Random
import 'dart:math';