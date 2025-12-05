import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

enum SortCriteria { dateDesc, titleAsc, priceAsc }

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  SortCriteria _sort = SortCriteria.dateDesc;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Query<Map<String, dynamic>> _buildQuery(String uid, String q) {
    final base = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('produtos');

    Query<Map<String, dynamic>> query;
    final qLower = q.toLowerCase();
    query = base.where('titleLowercase', isGreaterThanOrEqualTo: qLower)
                .where('titleLowercase', isLessThanOrEqualTo: '$qLower\uf8ff');

    switch (_sort) {
      case SortCriteria.dateDesc:
        query = query.orderBy('titleLowercase').orderBy('createdAt', descending: true);
        break;
      case SortCriteria.titleAsc:
        query = query.orderBy('titleLowercase', descending: false);
        break;
      case SortCriteria.priceAsc:
        query = query.orderBy('titleLowercase').orderBy('price', descending: false);
        break;
    }
    return query;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text('Faça login para pesquisar.')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Produtos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          PopupMenuButton<SortCriteria>(
            onSelected: (value) {
              setState(() {
                _sort = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortCriteria.dateDesc,
                child: Text('Mais recentes'),
              ),
              const PopupMenuItem(
                value: SortCriteria.titleAsc,
                child: Text('Título (A-Z)'),
              ),
              const PopupMenuItem(
                value: SortCriteria.priceAsc,
                child: Text('Preço (crescente)'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Pesquisar por título',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _controller.text.trim().isEmpty
                ? const Center(child: Text('Digite para pesquisar...'))
                : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _buildQuery(uid, _controller.text.trim()).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Erro na pesquisa'));
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final results = snapshot.data!.docs;
                      if (results.isEmpty) {
                        return const Center(child: Text('Nenhum resultado'));
                      }
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final ad = results[index].data();
                          return ListTile(
                            title: Text(ad['title'] ?? ''),
                            subtitle: Text(ad['category'] ?? ''),
                            trailing: Text('R\$ ${(ad['price'] ?? 0).toStringAsFixed(2)}'),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}