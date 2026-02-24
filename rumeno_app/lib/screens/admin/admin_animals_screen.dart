import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../mock/mock_animals.dart';
import '../../models/models.dart';
import '../../widgets/cards/animal_card.dart';

class AdminAnimalsScreen extends StatefulWidget {
  const AdminAnimalsScreen({super.key});

  @override
  State<AdminAnimalsScreen> createState() => _AdminAnimalsScreenState();
}

class _AdminAnimalsScreenState extends State<AdminAnimalsScreen> {
  String _search = '';
  Species? _speciesFilter;

  @override
  Widget build(BuildContext context) {
    var filtered = mockAnimals.where((a) {
      final matchSearch = a.breed.toLowerCase().contains(_search.toLowerCase()) ||
          a.tagId.toLowerCase().contains(_search.toLowerCase());
      final matchSpecies = _speciesFilter == null || a.species == _speciesFilter;
      return matchSearch && matchSpecies;
    }).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('All Animals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exporting animal data...')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or tag...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('All'),
                    selected: _speciesFilter == null,
                    selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
                    onSelected: (_) => setState(() => _speciesFilter = null),
                  ),
                ),
                ...Species.values.map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(s.name[0].toUpperCase() + s.name.substring(1)),
                    selected: _speciesFilter == s,
                    selectedColor: RumenoTheme.primaryGreen.withValues(alpha: 0.2),
                    onSelected: (_) => setState(() => _speciesFilter = s),
                  ),
                )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Text('${filtered.length} animals', style: Theme.of(context).textTheme.bodySmall),
                const Spacer(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) => AnimalCard(
                animal: filtered[index],
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
