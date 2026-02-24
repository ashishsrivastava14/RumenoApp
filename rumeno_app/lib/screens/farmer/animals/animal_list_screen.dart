import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme.dart';
import '../../../mock/mock_animals.dart';
import '../../../models/models.dart';
import '../../../widgets/cards/animal_card.dart';
import '../../../widgets/common/search_bar_widget.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  String _searchQuery = '';
  Species? _selectedSpecies;
  String _sortBy = 'Tag';

  List<Animal> get _filteredAnimals {
    var list = mockAnimals.toList();
    if (_selectedSpecies != null) {
      list = list.where((a) => a.species == _selectedSpecies).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((a) =>
          a.tagId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          a.breed.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    switch (_sortBy) {
      case 'Name':
        list.sort((a, b) => a.breed.compareTo(b.breed));
        break;
      case 'Tag':
        list.sort((a, b) => a.tagId.compareTo(b.tagId));
        break;
      case 'Age':
        list.sort((a, b) => a.dateOfBirth.compareTo(b.dateOfBirth));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('My Animals'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (context) => ['Tag', 'Name', 'Age', 'Status']
                .map((s) => PopupMenuItem(value: s, child: Text('Sort by $s')))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search by tag or breed...',
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          // Filter chips
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(label: 'All', selected: _selectedSpecies == null, onTap: () => setState(() => _selectedSpecies = null)),
                _FilterChip(label: 'Cow', selected: _selectedSpecies == Species.cow, onTap: () => setState(() => _selectedSpecies = Species.cow)),
                _FilterChip(label: 'Buffalo', selected: _selectedSpecies == Species.buffalo, onTap: () => setState(() => _selectedSpecies = Species.buffalo)),
                _FilterChip(label: 'Goat', selected: _selectedSpecies == Species.goat, onTap: () => setState(() => _selectedSpecies = Species.goat)),
                _FilterChip(label: 'Sheep', selected: _selectedSpecies == Species.sheep, onTap: () => setState(() => _selectedSpecies = Species.sheep)),
                _FilterChip(label: 'Pig', selected: _selectedSpecies == Species.pig, onTap: () => setState(() => _selectedSpecies = Species.pig)),
                _FilterChip(label: 'Horse', selected: _selectedSpecies == Species.horse, onTap: () => setState(() => _selectedSpecies = Species.horse)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Animal count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('${_filteredAnimals.length} animals', style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
              child: ListView.builder(
                itemCount: _filteredAnimals.length,
                itemBuilder: (context, index) {
                  final animal = _filteredAnimals[index];
                  return AnimalCard(
                    animal: animal,
                    onTap: () => context.go('/farmer/animals/${animal.id}'),
                    onHealthTap: () => context.go('/farmer/health'),
                    onBreedTap: () => context.go('/farmer/breeding'),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/farmer/animals/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Animal'),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(label, style: TextStyle(color: selected ? Colors.white : RumenoTheme.textDark, fontSize: 13)),
          backgroundColor: selected ? RumenoTheme.primaryGreen : Colors.white,
          side: BorderSide(color: selected ? RumenoTheme.primaryGreen : Colors.grey.shade300),
        ),
      ),
    );
  }
}
