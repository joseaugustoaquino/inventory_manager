import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_manager/providers/auth_provider.dart';
import 'package:inventory_manager/screens/ads_list_screen.dart';
import 'package:inventory_manager/screens/favorites_screen.dart';
import 'package:inventory_manager/screens/settings_screen.dart';
import 'package:inventory_manager/screens/statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AdsListPage(),
    const FavoritesPage(),
    const StatisticsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}

// Página inicial do app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child:  _body(context),
            )
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-ad');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final uid = authProvider.currentUser?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saudação do usuário
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    authProvider.currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${authProvider.currentUser?.name ?? 'Usuário'}!'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Bem-vindo ao Fab Ads',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Ações rápidas
        const Text(
          'Ações Rápidas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildQuickActionCard(
              context,
              'Criar Produto',
              Icons.add_circle,
              Colors.green,
              () => Navigator.pushNamed(context, '/create-ad'),
            ),
            _buildQuickActionCard(
              context,
              'Ver Produto',
              Icons.list,
              Colors.blue,
              () => Navigator.pushNamed(context, '/ads-list'),
            ),
            _buildQuickActionCard(
              context,
              'Favoritos',
              Icons.favorite,
              Colors.red,
              () => Navigator.pushNamed(context, '/favorites'),
            ),
            _buildQuickActionCard(
              context,
              'Estatísticas',
              Icons.bar_chart,
              Colors.purple,
              () => Navigator.pushNamed(context, '/statistics'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Resumo de atividades
        const Text(
          'Resumo de Atividades',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: uid == null
                  ? _buildSummaryCard(
                      'Meus Produtos',
                      '0',
                      Icons.ads_click,
                      Colors.orange,
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(uid)
                          .collection('produtos')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildSummaryCard(
                            'Meus Produtos',
                            '—',
                            Icons.ads_click,
                            Colors.orange,
                          );
                        }
                        if (!snapshot.hasData) {
                          return _buildSummaryCard(
                            'Meus Produtos',
                            '…',
                            Icons.ads_click,
                            Colors.orange,
                          );
                        }
                        final count = snapshot.data!.docs.length;
                        return _buildSummaryCard(
                          'Meus Produtos',
                          count.toString(),
                          Icons.ads_click,
                          Colors.orange,
                        );
                      },
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: uid == null
                  ? _buildSummaryCard(
                      'Favoritos',
                      '0',
                      Icons.favorite,
                      Colors.red,
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('usuarios')
                          .doc(uid)
                          .collection('favoritos')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return _buildSummaryCard(
                            'Favoritos',
                            '—',
                            Icons.favorite,
                            Colors.red,
                          );
                        }
                        if (!snapshot.hasData) {
                          return _buildSummaryCard(
                            'Favoritos',
                            '…',
                            Icons.favorite,
                            Colors.red,
                          );
                        }
                        final count = snapshot.data!.docs.length;
                        return _buildSummaryCard(
                          'Favoritos',
                          count.toString(),
                          Icons.favorite,
                          Colors.red,
                        );
                      },
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Páginas wrapper para o BottomNavigationBar
class AdsListPage extends StatelessWidget {
  const AdsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdsListScreen();
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesScreen();
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatisticsScreen();
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}
