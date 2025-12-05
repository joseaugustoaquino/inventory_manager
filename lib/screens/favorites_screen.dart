import 'package:flutter/material.dart';
import '../utils/dialog_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return const Center(child: Text('Faça login para ver favoritos.'));
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> favsStream = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('favoritos')
        .orderBy('addedAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: favsStream,
            builder: (context, snapshot) {
              final hasItems = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
              return IconButton(
                icon: const Icon(Icons.clear_all),
                onPressed: hasItems ? () => _clearAllFavorites(uid) : null,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: favsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar favoritos'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data!.docs;
          if (favorites.isEmpty) {
            return const Center(child: Text('Nenhum favorito ainda'));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favoriteDoc = favorites[index];
                  final favorite = favoriteDoc.data();
                  return Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => _showFavoriteDetails(favorite),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '⭐',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    favorite['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    favorite['category'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'R\$ ${(favorite['price'] ?? 0).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey, width: 0.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () => _removeFavorite(uid, favoriteDoc.id),
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'Remover',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () => _shareFavorite(favorite),
                                    icon: const Icon(
                                      Icons.share,
                                      size: 16,
                                    ),
                                    label: const Text(
                                      'Compartilhar',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFavoriteDetails(Map<String, dynamic> favorite) {
    DialogHelper.showInfoDialog(
      context,
      favorite['title'],
      'Preço: R\$ ${(favorite['price'] ?? 0).toStringAsFixed(2)}\nCategoria: ${favorite['category']}',
    );
  }

  Future<void> _removeFavorite(String uid, String favId) async {
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('favoritos')
        .doc(favId)
        .delete();
    if (mounted) {
      DialogHelper.showSnackBar(context, 'Removido dos favoritos');
    }
  }

  void _shareFavorite(Map<String, dynamic> favorite) {
    DialogHelper.showSnackBar(
      context,
      'Compartilhando: ${favorite['title']}',
    );
  }

  Future<void> _clearAllFavorites(String uid) async {
    final confirm = await DialogHelper.showConfirmDialog(
      context,
      'Limpar Favoritos',
      'Deseja remover todos os favoritos?',
    );
    
    if (confirm == true) {
      final favs = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('favoritos');
      final snapshot = await favs.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      if (mounted) { 
        DialogHelper.showSnackBar(
          context,
          'Todos os favoritos foram removidos',
        );
      }
    }
  }
}