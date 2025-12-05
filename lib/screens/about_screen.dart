import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo e nome do app
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.ads_click,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inventory Manager',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Versão 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Objetivo do aplicativo
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_rounded,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Objetivo do Aplicativo',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'O Inventory Manager é uma plataforma inovadora para criação, gerenciamento e visualização de estoque. '
                      'Nosso objetivo é facilitar a conexão entre anunciantes e consumidores, oferecendo uma '
                      'experiência intuitiva e eficiente para todos os usuários.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Equipe de desenvolvimento
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Equipe de Desenvolvimento',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTeamMember(
                      context,
                      'João Silva',
                      'Desenvolvedor Full Stack',
                      Icons.code,
                    ),
                    const SizedBox(height: 12),
                    _buildTeamMember(
                      context,
                      'Maria Santos',
                      'Designer UI/UX',
                      Icons.design_services,
                    ),
                    const SizedBox(height: 12),
                    _buildTeamMember(
                      context,
                      'Pedro Costa',
                      'Gerente de Projeto',
                      Icons.manage_accounts,
                    ),
                    const SizedBox(height: 12),
                    _buildTeamMember(
                      context,
                      'Ana Oliveira',
                      'Analista de Qualidade',
                      Icons.verified,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Funcionalidades
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.new_releases_rounded,
                          color: Colors.blue,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Principais Funcionalidades',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFeature(context, 'Criação de produto personalizados'),
                    _buildFeature(context, 'Busca avançada de produtos'),
                    _buildFeature(context, 'Sistema de favoritos'),
                    _buildFeature(context, 'Gerenciamento de perfil'),
                    _buildFeature(context, 'Listagem organizada de conteúdo'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Copyright
            Center(
              child: Text(
                '© ${DateTime.now().year} Inventory Manager. Todos os direitos reservados.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTeamMember(BuildContext context, String name, String role, IconData icon) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                role,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildFeature(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}