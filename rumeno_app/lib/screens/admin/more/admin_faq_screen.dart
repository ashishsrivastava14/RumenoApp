import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme.dart';
import '../../../providers/admin_provider.dart';

class AdminFaqScreen extends StatefulWidget {
  const AdminFaqScreen({super.key});

  @override
  State<AdminFaqScreen> createState() => _AdminFaqScreenState();
}

class _AdminFaqScreenState extends State<AdminFaqScreen> {
  String _selectedCategory = 'All';

  static const _categories = [
    'All', 'General', 'Animals', 'Health', 'Finance', 'Shop', 'Subscription'
  ];

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final allFaqs = admin.faqItems;
    final faqs = _selectedCategory == 'All'
        ? allFaqs
        : allFaqs.where((f) => f.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF4527A0), Color(0xFF7E57C2)],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 90, 20, 20),
                child: Row(
                  children: [
                    const Text('❓', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text('FAQ & Content',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              '${admin.publishedFaqCount} published · ${allFaqs.length} total',
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: [
                      _StatChip(
                          label: 'Published',
                          value: '${admin.publishedFaqCount}',
                          color: RumenoTheme.successGreen),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: 'Draft',
                          value:
                              '${allFaqs.length - admin.publishedFaqCount}',
                          color: Colors.orange),
                      const SizedBox(width: 8),
                      _StatChip(
                          label: 'Categories',
                          value: '${admin.faqCategories.length}',
                          color: RumenoTheme.infoBlue),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category Filter
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (ctx, i) {
                        final cat = _categories[i];
                        final selected = _selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey[700])),
                          selected: selected,
                          selectedColor: const Color(0xFF4527A0),
                          backgroundColor: Colors.white,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = cat),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(
                              color: selected
                                  ? const Color(0xFF4527A0)
                                  : Colors.grey.shade300),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // FAQ List
          faqs.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                      child: Text('No FAQs in this category',
                          style: TextStyle(color: Colors.grey))))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final faq = faqs[i];
                      return _FaqCard(faq: faq);
                    },
                    childCount: faqs.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFaqDialog(context),
        backgroundColor: const Color(0xFF4527A0),
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
        label: const Text('Add FAQ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
      ),
    );
  }

  void _showAddFaqDialog(BuildContext context) {
    final questionC = TextEditingController();
    final answerC = TextEditingController();
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('❓', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Text('Add FAQ'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: questionC,
                    decoration:
                        const InputDecoration(labelText: 'Question *'),
                    maxLines: 2),
                const SizedBox(height: 12),
                TextField(
                    controller: answerC,
                    decoration: const InputDecoration(labelText: 'Answer *'),
                    maxLines: 4),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration:
                      const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .where((c) => c != 'All')
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => category = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4527A0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (questionC.text.isEmpty || answerC.text.isEmpty) return;
                context.read<AdminProvider>().addFaq(FaqItem(
                      id: 'FAQ${DateTime.now().millisecondsSinceEpoch}',
                      question: questionC.text,
                      answer: answerC.text,
                      category: category,
                      sortOrder:
                          context.read<AdminProvider>().faqItems.length + 1,
                      createdAt: DateTime.now(),
                    ));
                Navigator.pop(ctx);
              },
              child:
                  const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// FAQ Card Widget
// ═════════════════════════════════════════════════════════════════════════════
class _FaqCard extends StatelessWidget {
  final FaqItem faq;
  const _FaqCard({required this.faq});

  static const _catColors = {
    'General': Color(0xFF607D8B),
    'Animals': Color(0xFF2E7D32),
    'Health': Color(0xFFE53935),
    'Finance': Color(0xFF1565C0),
    'Shop': Color(0xFFFF8F00),
    'Subscription': Color(0xFF6A1B9A),
  };

  @override
  Widget build(BuildContext context) {
    final catColor = _catColors[faq.category] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: faq.isPublished
            ? null
            : Border.all(color: Colors.orange.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
              child: Text(
                  faq.isPublished ? '❓' : '📝',
                  style: const TextStyle(fontSize: 22))),
        ),
        title: Text(faq.question,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: faq.isPublished ? null : Colors.grey)),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(faq.category,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: catColor)),
            ),
            const SizedBox(width: 8),
            if (!faq.isPublished)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Draft',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange)),
              ),
          ],
        ),
        shape: const Border(),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: RumenoTheme.backgroundCream,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(faq.answer,
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey[700])),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Updated: ${_formatDate(faq.updatedAt)}',
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey[400])),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: faq.isPublished,
                          activeColor: const Color(0xFF4527A0),
                          onChanged: (val) => context
                              .read<AdminProvider>()
                              .updateFaq(faq.id, isPublished: val),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, size: 20),
                          onPressed: () =>
                              _showEditDialog(context, faq),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_rounded,
                              size: 20, color: RumenoTheme.errorRed),
                          onPressed: () =>
                              _showDeleteDialog(context, faq),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  void _showEditDialog(BuildContext context, FaqItem faq) {
    final questionC = TextEditingController(text: faq.question);
    final answerC = TextEditingController(text: faq.answer);
    String category = faq.category;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('✏️', style: TextStyle(fontSize: 24)),
              SizedBox(width: 10),
              Text('Edit FAQ'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: questionC,
                    decoration:
                        const InputDecoration(labelText: 'Question *'),
                    maxLines: 2),
                const SizedBox(height: 12),
                TextField(
                    controller: answerC,
                    decoration:
                        const InputDecoration(labelText: 'Answer *'),
                    maxLines: 4),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration:
                      const InputDecoration(labelText: 'Category'),
                  items: const [
                    'General', 'Animals', 'Health', 'Finance', 'Shop',
                    'Subscription'
                  ]
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() => category = val);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4527A0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<AdminProvider>().updateFaq(
                      faq.id,
                      question: questionC.text,
                      answer: answerC.text,
                      category: category,
                    );
                Navigator.pop(ctx);
              },
              child: const Text('Save',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FaqItem faq) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete FAQ?'),
        content: Text('Remove "${faq.question}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RumenoTheme.errorRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<AdminProvider>().deleteFaq(faq.id);
              Navigator.pop(ctx);
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Stat Chip
// ═════════════════════════════════════════════════════════════════════════════
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
