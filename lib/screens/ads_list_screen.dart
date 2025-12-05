// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:inventory_manager/utils/dialog_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdsListScreen extends StatelessWidget {
  const AdsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Faça login para ver seus anúncios.'));
    }

    final query = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('produtos')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar produtos'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final ad = doc.data();
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Text(
                      '🛒',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    ad['title'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ad['description'] ?? ''),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ad['category'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'R\$ ${(ad['price'] ?? 0).toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('usuarios')
                            .doc(uid)
                            .collection('favoritos')
                            .doc(doc.id)
                            .snapshots(),
                        builder: (context, favSnapshot) {
                          final isFav = favSnapshot.hasData && favSnapshot.data!.exists;
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : null,
                            ),
                            onPressed: () async {
                              await _toggleFavorite(context, uid, doc.id, ad);
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showAdOptions(context, uid, doc.id, ad);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    _showAdDetails(context, ad);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-ad');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, String uid, String productId, Map<String, dynamic> ad) async {
    final favs = FirebaseFirestore.instance.collection('usuarios').doc(uid).collection('favoritos');
    final favDoc = favs.doc(productId);
    final exists = await favDoc.get();
    if (exists.exists) {
      await favDoc.delete();
      DialogHelper.showSnackBar(context, 'Produto removido dos favoritos');
    } else {
      await favDoc.set({
        'productId': productId,
        'title': ad['title'],
        'category': ad['category'],
        'price': ad['price'],
        'addedAt': DateTime.now().toUtc().toIso8601String(),
      });
      DialogHelper.showSnackBar(context, 'Produto adicionado aos favoritos');
    }
  }

  void _showAdDetails(BuildContext context, Map<String, dynamic> ad) {
    DialogHelper.showInfoDialog(
      context,
      ad['title'],
      '${ad['description']}\n\nPreço: R\$ ${(ad['price'] ?? 0).toStringAsFixed(2)}\nCategoria: ${ad['category']}',
    );
  }

  void _showAdOptions(BuildContext context, String uid, String productId, Map<String, dynamic> ad) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final titleController = TextEditingController(text: ad['title']);
        final descController = TextEditingController(text: ad['description']);
        final priceController = TextEditingController(text: (ad['price'] ?? 0).toString());
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Produto'),
                onTap: () async {
                  Navigator.pop(context);
                  final updated = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Editar Produto'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
                              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
                              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Preço')),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Salvar')),
                        ],
                      );
                    },
                  );
                  if (updated == true) {
                    await FirebaseFirestore.instance
                        .collection('usuarios').doc(uid).collection('produtos').doc(productId)
                        .update({
                      'title': titleController.text.trim(),
                      'titleLowercase': titleController.text.trim().toLowerCase(),
                      'description': descController.text.trim(),
                      'price': double.tryParse(priceController.text.trim()) ?? ad['price'],
                      'updatedAt': DateTime.now().toUtc().toIso8601String(),
                    });
                    DialogHelper.showSnackBar(context, 'Produto atualizado com sucesso!');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);
                  final confirm = await DialogHelper.showConfirmDialog(
                    context,
                    'Confirmar Exclusão',
                    'Tem certeza que deseja excluir este produto?',
                  );
                  if (confirm == true) {
                    await FirebaseFirestore.instance
                        .collection('usuarios').doc(uid).collection('produtos').doc(productId)
                        .delete();
                    DialogHelper.showSnackBar(context, 'Produto excluído com sucesso!');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtros'),
          content: const Text('Ordene e filtre usando a busca dedicada.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
              child: const Text('Abrir Busca'),
            ),
          ],
        );
      },
    );
  }
}
