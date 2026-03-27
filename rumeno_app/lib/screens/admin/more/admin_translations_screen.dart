import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../config/theme.dart';

/// Admin screen for viewing and managing ARB translation files.
/// Reads the bundled intl_*.arb files and shows translation coverage
/// with search, filter-by-category, and missing-key highlighting.
class AdminTranslationsScreen extends StatefulWidget {
  const AdminTranslationsScreen({super.key});

  @override
  State<AdminTranslationsScreen> createState() =>
      _AdminTranslationsScreenState();
}

class _AdminTranslationsScreenState extends State<AdminTranslationsScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  bool _loading = true;

  /// Locale code → { key: value } for every ARB file.
  final Map<String, Map<String, String>> _translations = {};

  /// All non-metadata keys found in the template (en).
  List<String> _allKeys = [];

  /// Categories derived from key prefixes (e.g. "common", "auth", "farm").
  List<String> _categories = [];

  String _search = '';
  String _selectedCategory = 'All';
  String _selectedLocale = 'hi';
  String _filterMode = 'All'; // All | Missing | Translated

  static const _locales = [
    {'code': 'hi', 'label': 'Hindi', 'flag': '🇮🇳'},
    {'code': 'ur', 'label': 'Urdu', 'flag': '🇵🇰'},
  ];

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      for (final locale in ['en', 'hi', 'ur']) {
        final raw =
            await rootBundle.loadString('lib/l10n/intl_$locale.arb');
        final Map<String, dynamic> json = jsonDecode(raw);
        final entries = <String, String>{};
        for (final e in json.entries) {
          if (!e.key.startsWith('@')) {
            entries[e.key] = e.value.toString();
          }
        }
        _translations[locale] = entries;
      }

      final enKeys = _translations['en']!.keys.toList()..sort();
      final cats = <String>{};
      for (final k in enKeys) {
        final prefix = _prefixOf(k);
        if (prefix.isNotEmpty) cats.add(prefix);
      }

      setState(() {
        _allKeys = enKeys;
        _categories = ['All', ...cats.toList()..sort()];
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load translations: $e')),
        );
      }
    }
  }

  String _prefixOf(String key) {
    final idx = key.indexOf(RegExp(r'[A-Z]'));
    if (idx <= 0) return key;
    return key.substring(0, idx);
  }

  // ── Computed helpers ───────────────────────────────────────────────────────
  List<String> get _filteredKeys {
    var keys = _allKeys;
    if (_selectedCategory != 'All') {
      keys = keys.where((k) => _prefixOf(k) == _selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      keys = keys.where((k) {
        if (k.toLowerCase().contains(q)) return true;
        final en = _translations['en']?[k] ?? '';
        if (en.toLowerCase().contains(q)) return true;
        final target = _translations[_selectedLocale]?[k] ?? '';
        if (target.toLowerCase().contains(q)) return true;
        return false;
      }).toList();
    }
    if (_filterMode == 'Missing') {
      keys = keys
          .where((k) =>
              (_translations[_selectedLocale]?[k] ?? '').isEmpty)
          .toList();
    } else if (_filterMode == 'Translated') {
      keys = keys
          .where((k) =>
              (_translations[_selectedLocale]?[k] ?? '').isNotEmpty)
          .toList();
    }
    return keys;
  }

  int get _totalKeys => _allKeys.length;
  int _translatedCount(String locale) =>
      _allKeys.where((k) => (_translations[locale]?[k] ?? '').isNotEmpty).length;

  double _coverage(String locale) =>
      _totalKeys == 0 ? 0 : _translatedCount(locale) / _totalKeys;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(child: _buildStats()),
                SliverToBoxAdapter(child: _buildToolbar()),
                _buildKeyList(),
              ],
            ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
          child: Row(
            children: [
              const Text('🌐', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text('Translation Manager',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                    Text(
                      '$_totalKeys keys · ${_translations.length} languages',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stats Cards ────────────────────────────────────────────────────────────
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: _locales.map((l) {
          final code = l['code']!;
          final label = l['label']!;
          final flag = l['flag']!;
          final translated = _translatedCount(code);
          final missing = _totalKeys - translated;
          final pct = (_coverage(code) * 100).toStringAsFixed(1);
          final isSelected = _selectedLocale == code;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedLocale = code),
              child: Container(
                margin: EdgeInsets.only(
                    right: code != _locales.last['code'] ? 8 : 0),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(color: RumenoTheme.primaryGreen, width: 2)
                      : null,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(flag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Text(label,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _coverage(code),
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(
                          _coverage(code) > 0.9
                              ? Colors.green
                              : _coverage(code) > 0.5
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$pct% · $translated / $_totalKeys',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                    if (missing > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('$missing missing',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.redAccent)),
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Toolbar: search, category chips, filter ────────────────────────────────
  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: 'Search keys or values…',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 12),

          // Category chips
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final active = cat == _selectedCategory;
                return ChoiceChip(
                  label: Text(cat,
                      style: TextStyle(
                          fontSize: 12,
                          color: active ? Colors.white : Colors.grey[700])),
                  selected: active,
                  selectedColor: RumenoTheme.primaryGreen,
                  backgroundColor: Colors.white,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = cat),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 8),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // Filter row
          Row(
            children: ['All', 'Missing', 'Translated'].map((f) {
              final active = f == _filterMode;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChip(
                  label: Text(f,
                      style: TextStyle(
                          fontSize: 12,
                          color: active ? Colors.white : Colors.grey[700])),
                  selected: active,
                  selectedColor: f == 'Missing'
                      ? Colors.redAccent
                      : RumenoTheme.primaryGreen,
                  backgroundColor: Colors.white,
                  onSelected: (_) => setState(() => _filterMode = f),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${_filteredKeys.length} keys',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Key list ───────────────────────────────────────────────────────────────
  Widget _buildKeyList() {
    final keys = _filteredKeys;
    if (keys.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text('No matching keys',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final key = keys[index];
            final en = _translations['en']?[key] ?? '';
            final target = _translations[_selectedLocale]?[key] ?? '';
            final isMissing = target.isEmpty;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isMissing
                    ? Border.all(
                        color: Colors.red.withValues(alpha: 0.3), width: 1)
                    : null,
              ),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                childrenPadding:
                    const EdgeInsets.fromLTRB(14, 0, 14, 12),
                shape: const Border(),
                leading: Icon(
                  isMissing
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_rounded,
                  size: 18,
                  color: isMissing ? Colors.redAccent : Colors.green,
                ),
                title: Text(key,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'monospace')),
                subtitle: Text(en,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[600])),
                children: [
                  _fieldRow('🇬🇧 English', en),
                  const SizedBox(height: 6),
                  _fieldRow(
                    '${_locales.firstWhere((l) => l['code'] == _selectedLocale)['flag']} ${_locales.firstWhere((l) => l['code'] == _selectedLocale)['label']}',
                    isMissing ? '— not translated —' : target,
                    isMissing: isMissing,
                  ),
                ],
              ),
            );
          },
          childCount: keys.length,
        ),
      ),
    );
  }

  Widget _fieldRow(String label, String value, {bool isMissing = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500])),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMissing
                ? Colors.red.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value,
              style: TextStyle(
                  fontSize: 13,
                  color: isMissing ? Colors.redAccent : Colors.black87)),
        ),
      ],
    );
  }
}
