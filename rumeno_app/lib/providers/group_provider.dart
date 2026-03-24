import 'package:flutter/material.dart';
import '../mock/mock_animals.dart';
import '../mock/mock_groups.dart';
import '../models/models.dart';

class GroupProvider extends ChangeNotifier {
  late List<AnimalGroup> _groups;
  late List<GroupAlert> _alerts;

  GroupProvider() {
    _groups = List.from(mockGroups);
    _alerts = List.from(mockGroupAlerts);
  }

  List<AnimalGroup> get groups => List.unmodifiable(_groups);
  List<GroupAlert> get alerts => List.unmodifiable(_alerts);

  // ── Group CRUD ──────────────────────────────────

  void addGroup(AnimalGroup group) {
    _groups.add(group);
    notifyListeners();
  }

  void updateGroupName(String groupId, String newName) {
    final i = _groups.indexWhere((g) => g.id == groupId);
    if (i == -1) return;
    _groups[i] = _groups[i].copyWith(name: newName);
    notifyListeners();
  }

  void deleteGroup(String groupId) {
    // Only removes the group – animals are NOT deleted
    _groups.removeWhere((g) => g.id == groupId);
    _alerts.removeWhere((a) => a.groupId == groupId);
    notifyListeners();
  }

  // ── Animal ↔ Group assignment ───────────────────

  void addAnimalsToGroup(String groupId, List<String> animalIds) {
    final i = _groups.indexWhere((g) => g.id == groupId);
    if (i == -1) return;
    final current = Set<String>.from(_groups[i].animalIds);
    current.addAll(animalIds);
    _groups[i] = _groups[i].copyWith(animalIds: current.toList());
    notifyListeners();
  }

  void removeAnimalFromGroup(String groupId, String animalId) {
    final i = _groups.indexWhere((g) => g.id == groupId);
    if (i == -1) return;
    final updated = List<String>.from(_groups[i].animalIds)..remove(animalId);
    _groups[i] = _groups[i].copyWith(animalIds: updated);
    notifyListeners();
  }

  void setGroupAnimals(String groupId, List<String> animalIds) {
    final i = _groups.indexWhere((g) => g.id == groupId);
    if (i == -1) return;
    _groups[i] = _groups[i].copyWith(animalIds: animalIds);
    notifyListeners();
  }

  // ── Queries ─────────────────────────────────────

  AnimalGroup? getGroupById(String id) {
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  List<AnimalGroup> getGroupsBySpecies(Species species) {
    return _groups
        .where((g) => g.species == species || g.species == null)
        .toList();
  }

  List<AnimalGroup> getGroupsForAnimal(String animalId) {
    return _groups.where((g) => g.animalIds.contains(animalId)).toList();
  }

  List<Animal> getAnimalsInGroup(String groupId) {
    final group = getGroupById(groupId);
    if (group == null) return [];
    return mockAnimals
        .where((a) => group.animalIds.contains(a.id))
        .toList();
  }

  // ── Group Alerts ────────────────────────────────

  List<GroupAlert> getAlertsForGroup(String groupId) {
    return _alerts.where((a) => a.groupId == groupId).toList();
  }

  List<GroupAlert> get pendingAlerts =>
      _alerts.where((a) => !a.isDone).toList();

  void addAlert(GroupAlert alert) {
    _alerts.add(alert);
    notifyListeners();
  }

  void toggleAlertDone(String alertId) {
    final i = _alerts.indexWhere((a) => a.id == alertId);
    if (i == -1) return;
    _alerts[i] = _alerts[i].copyWith(isDone: !_alerts[i].isDone);
    notifyListeners();
  }

  void deleteAlert(String alertId) {
    _alerts.removeWhere((a) => a.id == alertId);
    notifyListeners();
  }
}
