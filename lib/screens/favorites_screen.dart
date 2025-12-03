import 'package:flutter/material.dart';
import '../utils/dialog_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Dados estáticos de favoritos
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': '2',
      'title': 'Notebook Dell',
      'price': 'R\$ 2.800,00',
      'category': 'Informática',
      'image': '💻',
      'rating': 4.5,
    },
    {
      'id': '4',
      'title': 'Sofá 3 Lugares',
      'price': 'R\$ 800,00',
      'category': 'Móveis',
      'image': '🛋️',
      'rating': 4.8,
    },
    {
      'id': '6',
      'title': 'Smart TV 55"',
      'price': 'R\$ 1.900,00',
      'category': 'Eletrônicos',
      'image': '📺',
      'rating': 4.7,
    },
    {
      'id': '7',
      'title': 'Mesa de Jantar',
      'price': 'R\$ 650,00',
      'category': 'Móveis',
      'image': '🪑',
      'rating': 4.3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _favorites.isNotEmpty ? _clearAllFavorites : null,
          ),
        ],
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum favorito ainda',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione produtos aos favoritos para vê-los aqui',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Center(
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
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = _favorites[index];
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
                                child: Center(
                                  child: Text(
                                    favorite['image'],
                                    style: const TextStyle(fontSize: 48),
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
                                      favorite['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      favorite['category'],
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
                                            favorite['price'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                            Text(
                                              favorite['rating'].toString(),
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
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
                                      onPressed: () => _removeFavorite(index),
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
            ),
    );
  }

  void _showFavoriteDetails(Map<String, dynamic> favorite) {
    DialogHelper.showInfoDialog(
      context,
      favorite['title'],
      'Preço: ${favorite['price']}\nCategoria: ${favorite['category']}\nAvaliação: ${favorite['rating']} estrelas',
    );
  }

  void _removeFavorite(int index) async {
    final favorite = _favorites[index];
    final confirm = await DialogHelper.showConfirmDialog(
      context,
      'Remover Favorito',
      'Deseja remover "${favorite['title']}" dos favoritos?',
    );
    
    if (confirm == true) {
      setState(() {
        _favorites.removeAt(index);
      });
      if (mounted) {
        DialogHelper.showSnackBar(
          context,
          'Removido dos favoritos',
        );
      }
    }
  }

  void _shareFavorite(Map<String, dynamic> favorite) {
    DialogHelper.showSnackBar(
      context,
      'Compartilhando: ${favorite['title']}',
    );
  }

  void _clearAllFavorites() async {
    final confirm = await DialogHelper.showConfirmDialog(
      context,
      'Limpar Favoritos',
      'Deseja remover todos os favoritos?',
    );
    
    if (confirm == true) {
      setState(() {
        _favorites.clear();
      });
      
      if (mounted) { 
        DialogHelper.showSnackBar(
          context,
          'Todos os favoritos foram removidos',
        );
      }
    }
  }
}