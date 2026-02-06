// lib/data/demo_data.dart
// OrchidLife - Demo data for new users

import '../models/orchid.dart';
import '../models/care_task.dart';
import '../services/database_service.dart';

class DemoData {
  /// Check if demo data has been created
  static Future<bool> hasDemoData() async {
    final isar = DatabaseService.isar;
    final count = await isar.orchids.count();
    return count > 0;
  }

  /// Create demo orchid with care tasks
  static Future<void> createDemoData() async {
    final isar = DatabaseService.isar;
    
    // Check if already has data
    if (await hasDemoData()) {
      return;
    }

    // Create demo Phalaenopsis
    final demoOrchid = Orchid(
      name: 'My First Orchid',
      nickname: 'Demo',
      variety: OrchidVariety.phalaenopsis,
      colorTag: '#4CAF50',
      location: 'Living room window',
      bloomStatus: BloomStatus.resting,
      notes: 'This is a demo orchid to show you how OrchidLife works! '
          'Feel free to edit or delete it once you add your own orchids.\n\n'
          'Tip: Phalaenopsis (moth orchids) are great for beginners. '
          'They like indirect light and should be watered when the roots turn silvery.',
      isActive: true,
    );

    // Save orchid and get ID
    int orchidId = 0;
    await isar.writeTxn(() async {
      orchidId = await isar.orchids.put(demoOrchid);
    });

    // Create care tasks for the demo orchid
    final now = DateTime.now();
    
    final careTasks = [
      CareTask(
        orchidId: orchidId,
        careType: CareType.watering,
        intervalDays: 7,
        preferredTime: '09:00',
        instructions: 'Water when roots turn silvery-gray. Use room temperature water. '
            'Let water drain completely - never let it sit in water!',
        isActive: true,
        nextDue: now.add(const Duration(days: 2)), // Due in 2 days
      ),
      CareTask(
        orchidId: orchidId,
        careType: CareType.fertilizing,
        intervalDays: 30,
        preferredTime: '09:00',
        instructions: 'Use orchid fertilizer at half strength. '
            '"Weekly, weakly" is the golden rule - fertilize lightly but regularly.',
        isActive: true,
        nextDue: now.add(const Duration(days: 14)), // Due in 2 weeks
      ),
      CareTask(
        orchidId: orchidId,
        careType: CareType.misting,
        intervalDays: 3,
        preferredTime: '08:00',
        instructions: 'Mist leaves and aerial roots in the morning. '
            'Avoid getting water in the crown (center) of the plant.',
        isActive: true,
        nextDue: now.add(const Duration(days: 1)), // Due tomorrow
      ),
      CareTask(
        orchidId: orchidId,
        careType: CareType.inspection,
        intervalDays: 7,
        preferredTime: '10:00',
        instructions: 'Check leaves for spots, pests, or yellowing. '
            'Look at roots - healthy roots are green/silver, not brown or mushy.',
        isActive: true,
        nextDue: now.add(const Duration(days: 5)), // Due in 5 days
      ),
    ];

    // Save care tasks
    await isar.writeTxn(() async {
      await isar.careTasks.putAll(careTasks);
    });
  }

  /// Delete all demo data
  static Future<void> clearDemoData() async {
    final isar = DatabaseService.isar;
    
    // Find the demo orchid
    final demoOrchid = await isar.orchids
        .filter()
        .nicknameEqualTo('Demo')
        .findFirst();
    
    if (demoOrchid != null) {
      await isar.writeTxn(() async {
        // Delete care tasks for this orchid
        await isar.careTasks
            .filter()
            .orchidIdEqualTo(demoOrchid.id)
            .deleteAll();
        
        // Delete care logs for this orchid
        await isar.careLogs
            .filter()
            .orchidIdEqualTo(demoOrchid.id)
            .deleteAll();
        
        // Delete light readings for this orchid
        await isar.lightReadings
            .filter()
            .orchidIdEqualTo(demoOrchid.id)
            .deleteAll();
        
        // Delete the orchid
        await isar.orchids.delete(demoOrchid.id);
      });
    }
  }
}
