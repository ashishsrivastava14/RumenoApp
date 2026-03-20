import 'dart:async';
import 'dart:math';

import 'package:home_widget/home_widget.dart';
import '../mock/mock_animals.dart';
import '../mock/mock_health.dart';
import '../models/models.dart';

/// Service to push farm summary data to the native home screen widget.
/// Includes a 2-second demo ticker that randomises mock values.
class HomeWidgetService {
  static const _androidWidgetName = 'RumenoWidgetProvider';
  static const _iOSWidgetName = 'RumenoWidget';

  static Timer? _demoTimer;
  static final _rng = Random();

  /// Start auto-refresh every 2 seconds (demo mode).
  static void startDemoRefresh() {
    _demoTimer?.cancel();
    updateWidget();
    _demoTimer = Timer.periodic(const Duration(seconds: 2), (_) => updateWidget());
  }

  static void stopDemoRefresh() {
    _demoTimer?.cancel();
    _demoTimer = null;
  }

  // ── Simulated "live" event messages ──
  static const _eventPool = [
    'FMD Vaccination – C-001',
    'Deworming due – G-002',
    'Pregnancy check – B-002',
    'Vet visit – Dr. Emily',
    'Heat detected – C-003',
    'Dry-off alert – C-004',
    'Weight recording day',
    'PPR Vaccination – G-001',
    'Hoof trimming – B-004',
    'Milk test – C-006',
  ];

  /// Push current farm stats to native widget.
  /// All values saved as String to prevent type mismatch on Android.
  static Future<void> updateWidget() async {
    final baseTotal = mockAnimals.length;
    final basePregnant = mockAnimals.where((a) => a.status == AnimalStatus.pregnant).length;
    final baseActive = mockAnimals.where((a) => a.status == AnimalStatus.active).length;

    final baseVaxDue = mockVaccinations
        .where((v) => v.status == VaccinationStatus.due || v.status == VaccinationStatus.overdue)
        .length;

    final baseTreatments = mockTreatments
        .where((t) => t.status == TreatmentStatus.active || t.status == TreatmentStatus.followUp)
        .length;

    // Small random jitter so the widget visibly changes every tick
    int jitter(int base, int lo, int hi) =>
        (base + _rng.nextInt(hi - lo + 1) + lo).clamp(0, 999);

    final total = jitter(baseTotal, -2, 3);
    final pregnant = jitter(basePregnant, -1, 2);
    final active = jitter(baseActive, -2, 3);
    final vaxDue = jitter(baseVaxDue, -1, 2);
    final treatments = jitter(baseTreatments, -1, 2);
    final milkToday = 210 + _rng.nextInt(60);
    final nextEvent = _eventPool[_rng.nextInt(_eventPool.length)];

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    // Save ALL as String to avoid int/String type mismatch in Android SharedPreferences
    await HomeWidget.saveWidgetData<String>('total_animals', '$total');
    await HomeWidget.saveWidgetData<String>('pregnant', '$pregnant');
    await HomeWidget.saveWidgetData<String>('active', '$active');
    await HomeWidget.saveWidgetData<String>('overdue_vax', '$vaxDue');
    await HomeWidget.saveWidgetData<String>('active_treatments', '$treatments');
    await HomeWidget.saveWidgetData<String>('milk_today', '$milkToday');
    await HomeWidget.saveWidgetData<String>('next_event', nextEvent);
    await HomeWidget.saveWidgetData<String>('last_updated', timeStr);

    await HomeWidget.updateWidget(
      androidName: _androidWidgetName,
      iOSName: _iOSWidgetName,
    );
  }
}
