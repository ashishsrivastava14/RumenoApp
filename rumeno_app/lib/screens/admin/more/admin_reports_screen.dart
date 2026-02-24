import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../config/theme.dart';
import '../../../widgets/common/stat_card.dart';
import '../../../widgets/charts/bar_chart_widget.dart';
import '../../../widgets/charts/pie_chart_widget.dart';
import '../../../widgets/charts/line_chart_widget.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RumenoTheme.backgroundCream,
      appBar: AppBar(
        title: const Text('Reports'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [Tab(text: 'Revenue'), Tab(text: 'Users'), Tab(text: 'Health')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RevenueTab(),
          _UsersTab(),
          _HealthTab(),
        ],
      ),
    );
  }
}

class _RevenueTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Total Revenue', value: '₹4.2L', icon: Icons.currency_rupee)),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'MRR', value: '₹68K', icon: Icons.trending_up)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Monthly Revenue', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: BarChartWidget(
              values: const [35000, 42000, 48000, 52000, 58000, 68000],
              labels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
              barColor: RumenoTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          Text('Revenue by Plan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PieChartWidget(
              entries: [
                PieChartEntry(label: 'Free', value: 0, color: RumenoTheme.planFree),
                PieChartEntry(label: 'Starter', value: 40918, color: RumenoTheme.planStarter),
                PieChartEntry(label: 'Pro', value: 44955, color: RumenoTheme.planPro),
                PieChartEntry(label: 'Business', value: 57477, color: RumenoTheme.planBusiness),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Total Users', value: '248', icon: Icons.people)),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'Active', value: '230', icon: Icons.check_circle)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: StatCard(title: 'New (30d)', value: '12', icon: Icons.person_add)),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'Churn Rate', value: '2.1%', icon: Icons.trending_down)),
            ],
          ),
          const SizedBox(height: 20),
          Text('User Growth', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: LineChartWidget(
              spots: const [FlSpot(0, 120), FlSpot(1, 145), FlSpot(2, 168), FlSpot(3, 190), FlSpot(4, 220), FlSpot(5, 248)],
              bottomLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
              lineColor: RumenoTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          Text('Users by State', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: BarChartWidget(
              values: const [68, 45, 38, 32, 28, 22, 15],
              labels: const ['Gujarat', 'Rajasthan', 'MP', 'UP', 'Maharashtra', 'Haryana', 'Punjab'],
              barColor: RumenoTheme.accentOlive,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Total Animals', value: '3,456', icon: Icons.pets)),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'Vaccinated', value: '89%', icon: Icons.vaccines)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Under Treatment', value: '124', icon: Icons.medical_services)),
              SizedBox(width: 10),
              Expanded(child: StatCard(title: 'Pregnant', value: '286', icon: Icons.pregnant_woman)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Common Diseases', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PieChartWidget(
              entries: [
                PieChartEntry(label: 'Mastitis', value: 35, color: Colors.red),
                PieChartEntry(label: 'FMD', value: 22, color: Colors.orange),
                PieChartEntry(label: 'Tick Fever', value: 18, color: Colors.blue),
                PieChartEntry(label: 'Bloat', value: 12, color: Colors.teal),
                PieChartEntry(label: 'Pneumonia', value: 8, color: Colors.purple),
                PieChartEntry(label: 'Other', value: 5, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Species Distribution', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: BarChartWidget(
              values: const [1456, 890, 620, 340, 150],
              labels: const ['Cow', 'Buffalo', 'Goat', 'Sheep', 'Pig'],
              barColor: RumenoTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
