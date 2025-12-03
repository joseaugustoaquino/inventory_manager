// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:inventory_manager/utils/dialog_helper.dart';

class AdsListScreen extends StatelessWidget {
  const AdsListScreen({super.key});

  // Dados estáticos para demonstração
  final List<Map<String, dynamic>> _ads = const [
    {
      'id': '1',
      'title': 'iPhone 14 Pro Max',
      'description': 'Smartphone Apple em perfeito estado',
      'price': 'R\$ 4.500,00',
      'category': 'Eletrônicos',
      'image': '📱',
      'isFavorite': false,
    },
    {
      'id': '2',
      'title': 'Notebook Dell Inspiron',
      'description': 'Notebook para trabalho e estudos',
      'price': 'R\$ 2.800,00',
      'category': 'Informática',
      'image': '💻',
      'isFavorite': true,
    },
    {
      'id': '3',
      'title': 'Bicicleta Mountain Bike',
      'description': 'Bicicleta aro 29, 21 marchas',
      'price': 'R\$ 1.200,00',
      'category': 'Esportes',
      'image': '🚴',
      'isFavorite': false,
    },
    {
      'id': '4',
      'title': 'Sofá 3 Lugares',
      'description': 'Sofá confortável para sala',
      'price': 'R\$ 800,00',
      'category': 'Móveis',
      'image': '🛋️',
      'isFavorite': true,
    },
    {
      'id': '5',
      'title': 'Tênis Nike Air Max',
      'description': 'Tênis esportivo tamanho 42',
      'price': 'R\$ 350,00',
      'category': 'Calçados',
      'image': '👟',
      'isFavorite': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              DialogHelper.showInfoDialog(
                context,
                'Busca',
                'Funcionalidade de busca será implementada em breve!',
              );
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
      body: _ads.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum produto encontrado',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _ads.length,
              itemBuilder: (context, index) {
                final ad = _ads[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        ad['image'],
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      ad['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ad['description']),
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
                                ad['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              ad['price'],
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
                        IconButton(
                          icon: Icon(
                            ad['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                            color: ad['isFavorite'] ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            _toggleFavorite(context, ad);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _showAdOptions(context, ad);
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-ad');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleFavorite(BuildContext context, Map<String, dynamic> ad) {
    final isFavorite = ad['isFavorite'];
    final message = isFavorite
        ? 'Produto removido dos favoritos'
        : 'Produto adicionado aos favoritos';
    
    DialogHelper.showSnackBar(context, message);
  }

  void _showAdDetails(BuildContext context, Map<String, dynamic> ad) {
    DialogHelper.showInfoDialog(
      context,
      ad['title'],
      '${ad['description']}\n\nPreço: ${ad['price']}\nCategoria: ${ad['category']}',
    );
  }

  void _showAdOptions(BuildContext context, Map<String, dynamic> ad) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar Produto'),
                onTap: () {
                  Navigator.pop(context);
                  DialogHelper.showSnackBar(
                    context,
                    'Funcionalidade de edição em desenvolvimento',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartilhar'),
                onTap: () {
                  Navigator.pop(context);
                  DialogHelper.showSnackBar(
                    context,
                    'Produto compartilhado com sucesso!',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  Navigator.pop(context);

                  await DialogHelper.showConfirmDialog(
                    context,
                    'Confirmar Exclusão',
                    'Tem certeza que deseja excluir este produto?',
                  ).then((value) {
                    if (value == true) {
                      DialogHelper.showSnackBar(
                        context,
                        'Produto excluído com sucesso!',
                      );
                    }
                  });
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Eletrônicos'),
                leading: Radio(value: 1),
              ),
              ListTile(
                title: const Text('Informática'),
                leading: Radio(value: 2),
              ),
              ListTile(
                title: const Text('Esportes'),
                leading: Radio(value: 3),
              ),
              ListTile(
                title: const Text('Móveis'),
                leading: Radio(value: 4),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                DialogHelper.showSnackBar(
                  context,
                  'Filtros aplicados com sucesso!',
                );
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }
}