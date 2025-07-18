import 'package:flutter/material.dart';
import 'dart:math';
import 'waste_type.dart';

class WasteItem {
  final String name;
  final WasteType type;
  final IconData icon;
  final Offset position;

  WasteItem({
    required this.name,
    required this.type,
    required this.icon,
    required this.position,
  });

  static WasteItem generateRandomItem(double screenWidth, double screenHeight) {
    final List<Map<String, dynamic>> wasteTypes = [
      {'name': 'Plastic Bottle', 'type': WasteType.recyclable, 'icon': Icons.local_drink},
      {'name': 'Newspaper', 'type': WasteType.recyclable, 'icon': Icons.newspaper},
      {'name': 'Banana Peel', 'type': WasteType.organic, 'icon': Icons.compost},
      {'name': 'Battery', 'type': WasteType.hazardous, 'icon': Icons.battery_alert},
      {'name': 'Chips Bag', 'type': WasteType.general, 'icon': Icons.fastfood},
      {'name': 'Glass Bottle', 'type': WasteType.recyclable, 'icon': Icons.local_bar},
      {'name': 'Fish Bones', 'type': WasteType.organic, 'icon': Icons.set_meal},
    ];

    final random = Random();
    final selectedWaste = wasteTypes[random.nextInt(wasteTypes.length)];

    return WasteItem(
      name: selectedWaste['name'],
      type: selectedWaste['type'],
      icon: selectedWaste['icon'],
      position: Offset(
        random.nextDouble() * (screenWidth - 100),
        random.nextDouble() * (screenHeight - 200),
      ),
    );
  }
}
