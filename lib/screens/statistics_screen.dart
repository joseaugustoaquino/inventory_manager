import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estatísticas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final isMedium = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInventoryStats(isWide: isWide, isMedium: isMedium),
                    const SizedBox(height: 24),
                    _buildCategoryDistribution(isWide: isWide),
                    const SizedBox(height: 24),
                    _buildLowStockList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInventoryStats({required bool isWide, required bool isMedium}) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('produtos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;
        int totalProdutos = docs.length;
        int quantidadeTotal = 0;
        double valorTotal = 0;
        int baixoEstoque = 0;

        for (final d in docs) {
          final data = d.data() as Map<String, dynamic>;
          final q = (data['quantity'] ?? 0) as int;
          final price = ((data['price'] ?? 0) as num).toDouble();
          final threshold = (data['minStock'] ?? 5) as int;

          quantidadeTotal += q;
          valorTotal += q * price;
          if (q <= threshold) baixoEstoque++;
        }

        final children = [
          _buildStatCard(title: 'Produtos', value: '$totalProdutos', icon: Icons.inventory_2_outlined),
          _buildStatCard(title: 'Quantidade total', value: '$quantidadeTotal', icon: Icons.format_list_numbered),
          _buildStatCard(title: 'Valor total', value: 'R\$ ${valorTotal.toStringAsFixed(2)}', icon: Icons.attach_money),
          _buildStatCard(title: 'Baixo estoque', value: '$baixoEstoque', icon: Icons.warning_amber_rounded, color: Colors.orange),
        ];

        if (isWide) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: children,
          );
        } else if (isMedium) {
          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: children,
          );
        } else {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: children.map((c) => SizedBox(width: MediaQuery.of(context).size.width - 32, child: c)).toList(),
          );
        }
      },
    );
  }

  Widget _buildCategoryDistribution({required bool isWide}) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Distribuição por Categoria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(uid)
                  .collection('produtos')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Sem dados de categorias no momento.');
                }

                final counts = <String, int>{};
                for (final d in snapshot.data!.docs) {
                  final data = d.data() as Map<String, dynamic>;
                  final cat = (data['category'] ?? 'Sem categoria') as String;
                  counts[cat] = (counts[cat] ?? 0) + 1;
                }

                final total = counts.values.fold<int>(0, (a, b) => a + b);
                final items = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

                return Column(
                  children: items.map((e) {
                    final pct = total > 0 ? (e.value / total) : 0.0;
                    return _buildCategoryBar(label: e.key, count: e.value, ratio: pct);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLowStockList() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Itens com baixo estoque', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc(uid)
                  .collection('produtos')
                  .where('quantity', isLessThanOrEqualTo: 5) // ajuste se usar 'minStock'
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('Nenhum item com baixo estoque.');
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    final title = (data['title'] ?? 'Sem título') as String;
                    final q = (data['quantity'] ?? 0) as int;
                    final min = (data['minStock'] ?? 5) as int;
                    return ListTile(
                      leading: const Icon(Icons.inventory_2),
                      title: Text(title),
                      subtitle: Text('Quantidade: $q • Mínimo: $min'),
                      trailing: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: (color ?? Theme.of(context).colorScheme.primary).withValues(alpha: 0.12),
            child: Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar({required String label, required int count, required double ratio}) {
    final pctText = '${(ratio * 100).toStringAsFixed(1)}%';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(height: 14, decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8))),
                FractionallySizedBox(
                  widthFactor: ratio,
                  child: Container(height: 14, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(8))),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 120, child: Text('$label ($pctText)', overflow: TextOverflow.ellipsis)),
          const SizedBox(width: 8),
          Text('$count'),
        ],
      ),
    );
  }
}