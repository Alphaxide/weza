import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'main.dart';

class TransactionAnalysisScreen extends StatefulWidget {
  const TransactionAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<TransactionAnalysisScreen> createState() => _TransactionAnalysisScreenState();
}

class _TransactionAnalysisScreenState extends State<TransactionAnalysisScreen> {
  String _selectedTimeFrame = 'Last 6 Months';
  String _selectedCategory = 'All Categories';
  final List<String> _timeFrames = ['Last Month', 'Last 3 Months', 'Last 6 Months', 'Last Year'];
  late List<String> _categories;
  
  @override
  void initState() {
    super.initState();
    // Extract unique categories from transactions
    _categories = ['All Categories', ...seedTransactions.map((t) => t.category).toSet().toList()];
  }
  
  @override
  Widget build(BuildContext context) {
    // Filter transactions based on selected category
    final List<Transaction> filteredTransactions = _selectedCategory == 'All Categories'
        ? seedTransactions
        : seedTransactions.where((t) => t.category == _selectedCategory).toList();
    
    // Calculate total spent and received
    final double totalSpent = filteredTransactions
        .where((t) => t.type == 'send' || t.type == 'paybill' || t.type == 'withdraw')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final double totalReceived = filteredTransactions
        .where((t) => t.type == 'receive')
        .fold(0.0, (sum, t) => sum + t.amount);
    
    // Get category breakdown
    final categoryBreakdown = _getCategoryBreakdown(filteredTransactions);
    
    // Get monthly spending data
    final monthlySpendingData = _getMonthlySpendingData(filteredTransactions);
    
   
   return Scaffold(
  backgroundColor: const Color(0xFFF5F7FA), // Match dashboard background
  appBar: AppBar(
    title: const Text(
      'Transaction Analysis',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 22,
        fontFamily: 'Poppins',
        color: Colors.white,
      ),
    ),
    centerTitle: true,
    elevation: 0,
    backgroundColor: Theme.of(context).primaryColor,
  
  ),
  body: SingleChildScrollView(
    padding: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Gradient header with summary
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.85),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top row with summary stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCategory == 'All Categories' 
                            ? 'All Transactions' 
                            : _selectedCategory,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'KSh ${NumberFormat('#,###.00').format(totalSpent - totalReceived)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: totalReceived > totalSpent ? Colors.green.shade300 : Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedTimeFrame,
                          dropdownColor: Theme.of(context).primaryColor,
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedTimeFrame = newValue;
                              });
                            }
                          },
                          items: _timeFrames.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatisticItem(
                    title: 'Transactions',
                    value: filteredTransactions.length.toString(),
                    icon: Icons.receipt_long,
                    color: Colors.white,
                  ),
                  _StatisticItem(
                    title: 'Money Out',
                    value: 'KSh ${NumberFormat('#,###').format(totalSpent)}',
                    icon: Icons.arrow_upward,
                    color: Colors.red.shade300,
                  ),
                  _StatisticItem(
                    title: 'Money In',
                    value: 'KSh ${NumberFormat('#,###').format(totalReceived)}',
                    icon: Icons.arrow_downward,
                    color: Colors.green.shade300,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Category Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category, color: Colors.white70),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategory,
                        underline: Container(),
                        dropdownColor: Theme.of(context).primaryColor,
                        style: const TextStyle(color: Colors.white),
                        hint: const Text('Select Category', style: TextStyle(color: Colors.white70)),
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedCategory = newValue;
                            });
                          }
                        },
                        items: _categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Spending Over Time
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Spending Over Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Monthly Spending Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: _buildMonthlySpendingChart(monthlySpendingData),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Monthly Transaction Flow',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Category Breakdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Spending by Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Category Breakdown Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 250,
                    child: _buildCategoryBreakdownChart(categoryBreakdown),
                  ),
                  const SizedBox(height: 16),
                  // Legend
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: categoryBreakdown.map((category) => _buildLegendItem(
                      category.category,
                      _getCategoryColor(category.category),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Transaction Types
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Transaction Types',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: _buildTransactionTypeChart(filteredTransactions),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Send', Colors.orange),
                      const SizedBox(width: 16),
                      _buildLegendItem('Receive', Colors.green),
                      const SizedBox(width: 16),
                      _buildLegendItem('Paybill', Colors.blue),
                      const SizedBox(width: 16),
                      _buildLegendItem('Withdraw', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Recent Transactions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Recent Transactions List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTransactions.length > 5 ? 5 : filteredTransactions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(transaction.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(transaction.type),
                      color: _getTypeColor(transaction.type),
                    ),
                  ),
                  title: Text(transaction.recipient),
                  subtitle: Text(
                    '${transaction.category} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Text(
                    'KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: transaction.type == 'receive' ? Colors.green : Colors.red,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionDetailsScreen(
                          transaction: transaction,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Spending Insights
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Spending Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _InsightTile(
                    icon: Icons.trending_up,
                    color: Colors.red,
                    title: 'Spending Trend',
                    description: _getSpendingTrendInsight(monthlySpendingData),
                  ),
                  const Divider(),
                  _InsightTile(
                    icon: Icons.category,
                    color: Colors.blue,
                    title: 'Top Spending',
                    description: _getTopSpendingInsight(categoryBreakdown),
                  ),
                  const Divider(),
                  _InsightTile(
                    icon: Icons.calendar_today,
                    color: Colors.purple,
                    title: 'Transaction Frequency',
                    description: _getTransactionFrequencyInsight(filteredTransactions),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Financial Tips
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Financial Tips',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem(
                    _getPersonalizedTip(filteredTransactions, categoryBreakdown),
                  ),
                  _buildTipItem(
                    'Setting up automatic savings can help you build wealth over time',
                  ),
                  _buildTipItem(
                    'Track your expenses regularly to identify areas where you can reduce spending',
                  ),
                ],
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 80), // Bottom padding for FAB
      ],
    ),
  ),
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () {},
    icon: const Icon(Icons.download),
    label: const Text(
      'Export Report',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    elevation: 4,
    backgroundColor: Theme.of(context).primaryColor,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
);
  }
  
  Widget _buildMonthlySpendingChart(List<MonthlyTransactionData> data) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 6.0, top: 24.0, bottom: 12.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: 10000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        data[value.toInt()].month,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10000,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    NumberFormat.compact().format(value),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade200),
          ),
          minX: 0,
          maxX: data.length - 1.0,
          minY: 0,
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final flSpot = spot;
                  if (spot.barIndex == 0) {
                    return LineTooltipItem(
                      'In: KSh ${NumberFormat('#,###').format(data[flSpot.x.toInt()].received)}',
                      const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return LineTooltipItem(
                      'Out: KSh ${NumberFormat('#,###').format(data[flSpot.x.toInt()].spent)}',
                      const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    );
                  }
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            // Money In
            LineChartBarData(
              spots: List.generate(data.length, (i) {
                return FlSpot(i.toDouble(), data[i].received);
              }),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withOpacity(0.1),
              ),
            ),
            // Money Out
            LineChartBarData(
              spots: List.generate(data.length, (i) {
                return FlSpot(i.toDouble(), data[i].spent);
              }),
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryBreakdownChart(List<CategoryBreakdown> data) {
    // Calculate total for percentages
    final totalAmount = data.fold(0.0, (sum, item) => sum + item.amount);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: data.map((category) {
            final percentage = (category.amount / totalAmount) * 100;
            return PieChartSectionData(
              color: _getCategoryColor(category.category),
              value: category.amount,
              title: '${percentage.toStringAsFixed(1)}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
          centerSpaceRadius: 40,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {},
          ),
        ),
      ),
    );
  }
  
  Widget _buildTransactionTypeChart(List<Transaction> transactions) {
    // Count transactions by type
    Map<String, int> typeCounts = {};
    for (var transaction in transactions) {
      if (typeCounts.containsKey(transaction.type)) {
        typeCounts[transaction.type] = typeCounts[transaction.type]! + 1;
      } else {
        typeCounts[transaction.type] = 1;
      }
    }
    
    // Calculate total for percentages
    final total = typeCounts.values.fold(0, (sum, count) => sum + count);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: typeCounts.values.isEmpty 
              ? 10 
              : typeCounts.values.reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey.shade700,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String type = typeCounts.keys.elementAt(groupIndex);
                int count = typeCounts.values.elementAt(groupIndex);
                double percentage = (count / total) * 100;
                return BarTooltipItem(
                  '$type: $count (${percentage.toStringAsFixed(1)}%)',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < typeCounts.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        typeCounts.keys.elementAt(value.toInt()).capitalize(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade200,
                strokeWidth: 1,
              );
            },
          ),
          barGroups: typeCounts.entries.map((e) {
            final index = typeCounts.keys.toList().indexOf(e.key);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  color: _getTypeColor(e.key),
                  width: 30,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
  
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  
  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  List<CategoryBreakdown> _getCategoryBreakdown(List<Transaction> transactions) {
    final Map<String, double> categoryMap = {};
    
    for (var transaction in transactions) {
      // For spending analysis, we only consider outgoing transactions
      if (transaction.type != 'receive') {
        if (categoryMap.containsKey(transaction.category)) {
          categoryMap[transaction.category] = 
              categoryMap[transaction.category]! + transaction.amount;
        } else {
          categoryMap[transaction.category] = transaction.amount;
        }
      }
    }
    
    return categoryMap.entries
        .map((entry) => CategoryBreakdown(entry.key, entry.value))
        .toList();
  }
  
  List<MonthlyTransactionData> _getMonthlySpendingData(List<Transaction> transactions) {
    final Map<String, MonthlyTransactionData> monthlyMap = {};
    final now = DateTime.now();
    int monthsToShow = 6;
    
    switch (_selectedTimeFrame) {
      case 'Last Month':
        monthsToShow = 1;
        break;
      case 'Last 3 Months':
        monthsToShow = 3;
        break;
      case 'Last 6 Months':
        monthsToShow = 6;
        break;
      case 'Last Year':
        monthsToShow = 12;
        break;
    }
    
    // Initialize with empty data for last N months
    for (int i = 0; i < monthsToShow; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthStr = DateFormat('MMM').format(month);
      monthlyMap[monthStr] = MonthlyTransactionData(monthStr, 0, 0);
    }
    
    // Fill with actual data
    for (var transaction in transactions) {
      final date = transaction.date;
      if (date.isAfter(DateTime(now.year, now.month - monthsToShow, now.day))) {
        final monthStr = DateFormat('MMM').format(date);
        if (monthlyMap.containsKey(monthStr)) {
          var existingData = monthlyMap[monthStr]!;
          if (transaction.type == 'receive') {
            monthlyMap[monthStr] = MonthlyTransactionData(
              monthStr, 
              existingData.spent, 
              existingData.received + transaction.amount
            );
          } else {
            monthlyMap[monthStr] = MonthlyTransactionData(
              monthStr, 
              existingData.spent + transaction.amount, 
              existingData.received
            );
          }
        }
      }
    }
    
    // Convert to list and sort by date
    final List<MonthlyTransactionData> result = [];
    for (int i = 0; i < monthsToShow; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthStr = DateFormat('MMM').format(month);
      if (monthlyMap.containsKey(monthStr)) {
        result.add(monthlyMap[monthStr]!);
      }
    }
    
    // Reverse to show oldest month first
    return result.reversed.toList();
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Utilities':
        return Colors.yellow.shade800;
      case 'Bills':
        return Colors.blue;
      case 'Family':
        return Colors.pink;
      case 'Friends':
        return Colors.purple;
      case 'Food':
        return Colors.orange;
      case 'Transport':
        return Colors.teal;
      case 'Salary':
      case 'Income':
        return Colors.green;
      case 'Cash':
        return Colors.grey.shade700;
      default:
        return Colors.indigo;
    }
  }
  
  Color _getTypeColor(String type) {
    switch (type) {
      case 'send':
        return Colors.orange;
      case 'receive':
        return Colors.green;
      case 'paybill':
        return Colors.blue;
      case 'withdraw':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'send':
        return Icons.arrow_upward;
      case 'receive':
        return Icons.arrow_downward;
      case 'paybill':
        return Icons.receipt;
      case 'withdraw':
        return Icons.money;
      default:
        return Icons.swap_horiz;
    }
  }
  
  String _getSpendingTrendInsight(List<MonthlyTransactionData> data) {
    if (data.length < 2) return 'Not enough data to determine trend';
    
    double spendingDifference = 0;
    int count = 0;
    
    for (int i = 1; i < data.length; i++) {
      spendingDifference += data[i].spent - data[i-1].spent;
      count++;
    }
    
    double avgDifference = count > 0 ? spendingDifference / count : 0;
    
  if (avgDifference > 500) {
      return 'Your spending has been increasing recently. Consider reviewing your budget.';
    } else if (avgDifference < -500) {
      return 'Your spending has been decreasing recently. Great job managing your expenses!';
    } else {
      return 'Your spending has been relatively stable in recent months.';
    }
  }
  
  String _getTopSpendingInsight(List<CategoryBreakdown> data) {
    if (data.isEmpty) return 'No spending data available';
    
    // Sort categories by amount spent (descending)
    data.sort((a, b) => b.amount.compareTo(a.amount));
    
    if (data.length >= 2) {
      final topCategory = data[0];
      final secondCategory = data[1];
      
      final topPercentage = (topCategory.amount / data.fold(0.0, (sum, item) => sum + item.amount)) * 100;
      
      return 'Your highest spending category is ${topCategory.category} (${topPercentage.toStringAsFixed(1)}%), followed by ${secondCategory.category}.';
    } else if (data.length == 1) {
      return 'Your only spending category is ${data[0].category}.';
    } else {
      return 'No spending data available';
    }
  }
  
  String _getTransactionFrequencyInsight(List<Transaction> transactions) {
    if (transactions.isEmpty) return 'No transaction data available';
    
    // Count transactions by day of week
    Map<int, int> dayOfWeekCounts = {};
    for (var transaction in transactions) {
      final dayOfWeek = transaction.date.weekday;
      if (dayOfWeekCounts.containsKey(dayOfWeek)) {
        dayOfWeekCounts[dayOfWeek] = dayOfWeekCounts[dayOfWeek]! + 1;
      } else {
        dayOfWeekCounts[dayOfWeek] = 1;
      }
    }
    
    // Find the most common day of week
    int? mostCommonDay;
    int maxCount = 0;
    dayOfWeekCounts.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommonDay = day;
      }
    });
    
    if (mostCommonDay != null) {
      final dayName = _getDayName(mostCommonDay!);
      return 'You make most of your transactions on $dayName.';
    } else {
      return 'Your transactions are evenly distributed throughout the week.';
    }
  }
  
  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Unknown';
    }
  }
  
  String _getPersonalizedTip(List<Transaction> transactions, List<CategoryBreakdown> categories) {
    if (categories.isEmpty) return 'Start categorizing your transactions to get personalized insights';
    
    // Find highest spending category
    categories.sort((a, b) => b.amount.compareTo(a.amount));
    final topCategory = categories[0].category;
    
    switch (topCategory) {
      case 'Food':
        return 'Consider meal planning to reduce your food expenses';
      case 'Transport':
        return 'Look into carpooling or public transport options to save on transportation costs';
      case 'Utilities':
        return 'Check for energy-saving opportunities to reduce your utility bills';
      case 'Bills':
        return 'Review your subscription services to eliminate unused memberships';
      case 'Friends':
        return 'Set a budget for social activities to manage your entertainment expenses';
      case 'Family':
        return 'Consider creating a shared family budget to track household expenses';
      default:
        return 'Focus on your ${topCategory.toLowerCase()} spending to improve your financial health';
    }
  }
}

class _StatisticItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatisticItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _InsightTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  
  const _InsightTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class CategoryBreakdown {
  final String category;
  final double amount;
  
  CategoryBreakdown(this.category, this.amount);
}

class MonthlyTransactionData {
  final String month;
  final double spent;
  final double received;
  
  MonthlyTransactionData(this.month, this.spent, this.received);
}
class TransactionDetailsScreen extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionDetailsScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with amount and transaction type
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getTypeColor(transaction.type).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getTypeIcon(transaction.type),
                      color: _getTypeColor(transaction.type),
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'KSh ${NumberFormat('#,###.00').format(transaction.amount)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      height: 1.2,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTransactionTypeText(transaction.type),
                    style: TextStyle(
                      color: _getTypeColor(transaction.type),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy, hh:mm a').format(transaction.date),
                    style: const TextStyle(
                      color: Color(0xFF757575),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Transaction details
            const Text(
              'TRANSACTION DETAILS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
                letterSpacing: 0.8,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailRow('Recipient', transaction.recipient),
                  _buildDivider(),
                  _buildDetailRow('Category', transaction.category),
                  _buildDivider(),
                  _buildDetailRow('Reference', transaction.reference),
                  _buildDivider(),
                  _buildDetailRow('Transaction ID', transaction.id),
                  _buildDivider(),
                  _buildDetailRow('Balance', 'KSh ${NumberFormat('#,###.00').format(_getBalance(transaction))}'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // M-Pesa Message
            const Text(
              'M-PESA MESSAGE',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF757575),
                letterSpacing: 0.8,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF9F9F9),
                border: Border.all(color: const Color(0xFFEEEEEE)),
              ),
              child: Text(
                _getMpesaMessage(transaction),
                style: const TextStyle(
                  height: 1.5,
                  color: Color(0xFF333333),
                  fontSize: 14,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Report issue or get help functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You will be redirected'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Label Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF0F0F0),
    );
  }
  
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'send':
        return const Color(0xFFFF6B01);
      case 'receive':
        return const Color(0xFF00AA55);
      case 'paybill':
        return const Color(0xFF1E88E5);
      case 'withdraw':
        return const Color(0xFF8E24AA);
      default:
        return const Color(0xFF757575);
    }
  }
  
  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'send':
        return Icons.arrow_upward_rounded;
      case 'receive':
        return Icons.arrow_downward_rounded;
      case 'paybill':
        return Icons.receipt_rounded;
      case 'withdraw':
        return Icons.account_balance_rounded;
      default:
        return Icons.swap_horiz_rounded;
    }
  }
  
  String _getTransactionTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'send':
        return 'Money Sent';
      case 'receive':
        return 'Money Received';
      case 'paybill':
        return 'Bill Payment';
      case 'withdraw':
        return 'Cash Withdrawal';
      default:
        return 'Transaction';
    }
  }
  
  double _getBalance(Transaction transaction) {
    // Simulated balance calculation based on transaction type
    switch (transaction.type.toLowerCase()) {
      case 'send':
        return 15432.75 - transaction.amount;
      case 'receive':
        return 15432.75 + transaction.amount;
      case 'paybill':
        return 15432.75 - transaction.amount;
      case 'withdraw':
        return 15432.75 - transaction.amount;
      default:
        return 15432.75;
    }
  }
  
  String _getMpesaMessage(Transaction transaction) {
    final String formattedAmount = NumberFormat('#,###.00').format(transaction.amount);
    final String formattedDate = DateFormat('d/M/yy h:mm a').format(transaction.date);
    final String balance = NumberFormat('#,###.00').format(_getBalance(transaction));
    final String transactionCost = NumberFormat('#,###.00').format(_getTransactionCost(transaction));
    
    switch (transaction.type.toLowerCase()) {
      case 'send':
        return 'MPWKA5RT3D Confirmed. Ksh$formattedAmount sent to ${transaction.recipient} on $formattedDate. New M-PESA balance is Ksh$balance. Transaction cost, Ksh$transactionCost. Amount you can transact within the day is 299,840.00. Pay bills free with M-PESA. SAFARICOM TRANSPARENT FOR YOU.';
      case 'receive':
        return 'MPBJ57YH8F Confirmed. You have received Ksh$formattedAmount from ${transaction.recipient} on $formattedDate. New M-PESA balance is Ksh$balance. Safaricom, Simple. Transparent. Honest.';
      case 'paybill':
        return 'MPCLK43T9G Confirmed. Ksh$formattedAmount paid to ${transaction.recipient} for account ${transaction.reference} on $formattedDate. New M-PESA balance is Ksh$balance. Transaction cost, Ksh$transactionCost.';
      case 'withdraw':
        return 'MPXYQ19F2H Confirmed. Ksh$formattedAmount withdrawn from ${transaction.recipient} Agent on $formattedDate. New M-PESA balance is Ksh$balance. Transaction cost, Ksh$transactionCost. Pay bills free with M-PESA.';
      default:
        return 'MPJK3LD0W5 Confirmed. Transaction of Ksh$formattedAmount on $formattedDate. New M-PESA balance is Ksh$balance.';
    }
  }
  
  double _getTransactionCost(Transaction transaction) {
    // Simulated transaction cost based on amount
    if (transaction.amount <= 100) {
      return 0;
    } else if (transaction.amount <= 1000) {
      return 11;
    } else if (transaction.amount <= 2500) {
      return 22;
    } else if (transaction.amount <= 5000) {
      return 33;
    } else if (transaction.amount <= 10000) {
      return 55;
    } else {
      return 77;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}