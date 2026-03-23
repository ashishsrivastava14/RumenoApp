import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/models.dart';
import '../../providers/ecommerce_provider.dart';

/// Category management screen designed for simplicity — big visual cards,
/// large emoji icons, intuitive edit/delete actions, and color-coded categories
/// so even non-literate users can identify and manage categories easily.
class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eco = context.watch<EcommerceProvider>();
    final categories = eco.allShopCategories;

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: Row(
          children: const [
            Text('📂', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Text('Categories', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_category',
        onPressed: () => _openAddEditSheet(context, null),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded, size: 28),
        label: const Text('Add New',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: categories.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📂', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('No categories yet',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Tap + to add your first category',
                      style: TextStyle(fontSize: 14, color: Colors.grey[400])),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                final cat = categories[i];
                final productCount = eco.allProductsUnfiltered
                    .where((p) => p.categoryName == cat.name)
                    .length;
                return _CategoryCard(
                  category: cat,
                  productCount: productCount,
                  onEdit: () => _openAddEditSheet(context, cat),
                  onDelete: () => _confirmDelete(context, cat, eco),
                  onToggleActive: () {
                    eco.updateShopCategory(cat.id, isActive: !cat.isActive);
                  },
                );
              },
            ),
    );
  }

  void _confirmDelete(
      BuildContext context, ShopCategory cat, EcommerceProvider eco) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🗑️', style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Delete Category?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show the category being deleted with its emoji
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(cat.colorValue).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Color(cat.colorValue).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(cat.name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(cat.colorValue))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text('This will permanently remove this category.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          // Big Cancel button
          SizedBox(
            width: 120,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(ctx),
              icon: const Icon(Icons.close_rounded, size: 20),
              label:
                  const Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          // Big Delete button
          SizedBox(
            width: 120,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                eco.deleteShopCategory(cat.id);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text('${cat.name} deleted'),
                      ],
                    ),
                    backgroundColor: RumenoTheme.errorRed,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.delete_rounded, size: 20),
              label: const Text('Yes',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: RumenoTheme.errorRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddEditSheet(BuildContext context, ShopCategory? existing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddEditCategorySheet(category: existing),
    );
  }
}

// ─── Category Card ────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final ShopCategory category;
  final int productCount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const _CategoryCard({
    required this.category,
    required this.productCount,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = Color(category.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: catColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: category.isActive
              ? catColor.withValues(alpha: 0.3)
              : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Opacity(
        opacity: category.isActive ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Big emoji circle — visual identifier
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: catColor.withValues(alpha: 0.3), width: 2),
                ),
                child: Center(
                  child:
                      Text(category.emoji, style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 14),
              // Name + description + product count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: catColor,
                        )),
                    if (category.description != null &&
                        category.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(category.description!,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$productCount product${productCount == 1 ? '' : 's'}',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: catColor),
                      ),
                    ),
                  ],
                ),
              ),
              // Action buttons — big and visual
              Column(
                children: [
                  // Edit - pencil icon
                  _ActionButton(
                    icon: Icons.edit_rounded,
                    color: const Color(0xFF1976D2),
                    tooltip: 'Edit',
                    onTap: onEdit,
                  ),
                  const SizedBox(height: 8),
                  // Delete - trash icon
                  _ActionButton(
                    icon: Icons.delete_rounded,
                    color: RumenoTheme.errorRed,
                    tooltip: 'Delete',
                    onTap: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

// ─── Add/Edit Category Bottom Sheet ───────────────────────────────────────────

class _AddEditCategorySheet extends StatefulWidget {
  final ShopCategory? category;
  const _AddEditCategorySheet({this.category});

  @override
  State<_AddEditCategorySheet> createState() => _AddEditCategorySheetState();
}

class _AddEditCategorySheetState extends State<_AddEditCategorySheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late String _selectedEmoji;
  late int _selectedColorValue;

  bool get isEditing => widget.category != null;

  // Emoji palette — common farm/shop/product emojis for visual selection
  static const _emojiOptions = [
    '🌾', '💊', '🧴', '💉', '🔧', '🥛', '🐄', '🐐', '🐑', '🐔',
    '🐖', '🐴', '🌿', '🧪', '🏥', '🛠️', '⚙️', '🧲', '📦', '🛒',
    '🌽', '🍀', '💧', '🧹', '🪣', '🧤', '🪴', '🔬', '🩺', '🩹',
  ];

  // Color palette — pre-set colors for illiterate-friendly visual picking
  static const _colorOptions = [
    0xFF4CAF50, // Green
    0xFF9C27B0, // Purple
    0xFF009688, // Teal
    0xFFE53935, // Red
    0xFFFF9800, // Orange
    0xFF1976D2, // Blue
    0xFFFF5722, // Deep Orange
    0xFF795548, // Brown
    0xFF607D8B, // Blue Grey
    0xFFF44336, // Bright Red
    0xFF3F51B5, // Indigo
    0xFF00BCD4, // Cyan
    0xFFFFC107, // Amber
    0xFF8BC34A, // Light Green
    0xFFE91E63, // Pink
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');
    _descCtrl =
        TextEditingController(text: widget.category?.description ?? '');
    _selectedEmoji = widget.category?.emoji ?? '📦';
    _selectedColorValue = widget.category?.colorValue ?? 0xFF4CAF50;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1565C0),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        Text(isEditing ? '✏️' : '➕',
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit Category' : 'New Category',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  // Form body
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      children: [
                        // ── Live Preview ──
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              color: Color(_selectedColorValue)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Color(_selectedColorValue)
                                      .withValues(alpha: 0.3),
                                  width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_selectedEmoji,
                                    style: const TextStyle(fontSize: 36)),
                                const SizedBox(width: 12),
                                Text(
                                  _nameCtrl.text.isEmpty
                                      ? 'Category Name'
                                      : _nameCtrl.text,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _nameCtrl.text.isEmpty
                                        ? Colors.grey
                                        : Color(_selectedColorValue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Section: Name ──
                        _sectionHeader('📝', 'Category Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'e.g. Feed, Tonic, Supplements...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Color(0xFF1976D2), width: 2),
                            ),
                            prefixIcon: const Icon(
                                Icons.category_rounded,
                                size: 22),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name is required'
                              : null,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),

                        // ── Section: Pick an Icon (Emoji) ──
                        _sectionHeader('🎨', 'Pick an Icon'),
                        const SizedBox(height: 4),
                        Text('Tap on any icon below',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _emojiOptions.map((emoji) {
                            final selected = _selectedEmoji == emoji;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedEmoji = emoji),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Color(_selectedColorValue)
                                          .withValues(alpha: 0.15)
                                      : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: selected
                                        ? Color(_selectedColorValue)
                                        : Colors.grey.shade200,
                                    width: selected ? 2.5 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(emoji,
                                      style: const TextStyle(fontSize: 26)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // ── Section: Pick a Color ──
                        _sectionHeader('🎨', 'Pick a Color'),
                        const SizedBox(height: 4),
                        Text('This color shows on the category card',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _colorOptions.map((colorVal) {
                            final selected = _selectedColorValue == colorVal;
                            return GestureDetector(
                              onTap: () => setState(
                                  () => _selectedColorValue = colorVal),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Color(colorVal),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: Color(colorVal)
                                                .withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          )
                                        ]
                                      : null,
                                ),
                                child: selected
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 26)
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // ── Section: Description (optional) ──
                        _sectionHeader('📋', 'Description (optional)'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Short description...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: Color(0xFF1976D2), width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // Save button — big and prominent
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: Icon(
                            isEditing
                                ? Icons.check_rounded
                                : Icons.add_rounded,
                            size: 26),
                        label: Text(
                          isEditing ? 'Save Changes' : 'Add Category',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(_selectedColorValue),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String emoji, String title) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final eco = context.read<EcommerceProvider>();
    final name = _nameCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (isEditing) {
      eco.updateShopCategory(
        widget.category!.id,
        name: name,
        emoji: _selectedEmoji,
        colorValue: _selectedColorValue,
        description: desc.isEmpty ? null : desc,
      );
    } else {
      final newCat = ShopCategory(
        id: 'cat_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        emoji: _selectedEmoji,
        colorValue: _selectedColorValue,
        description: desc.isEmpty ? null : desc,
        sortOrder: eco.allShopCategories.length,
        createdAt: DateTime.now(),
      );
      eco.addShopCategory(newCat);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(_selectedEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(isEditing ? '$name updated!' : '$name added!'),
          ],
        ),
        backgroundColor: RumenoTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
