import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_manager/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _body(context),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Seção do Perfil
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Perfil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Editar Perfil'),
                subtitle: const Text('Alterar informações pessoais'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade em desenvolvimento'),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Alterar Senha'),
                subtitle: const Text('Modificar sua senha de acesso'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showChangePasswordDialog(context);
                },
              ),
            ],
          ),
        ),
        // Seção de Notificações
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Notificações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text('Notificações Push'),
                subtitle: const Text('Receber notificações no dispositivo'),
                value: true,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Notificações ativadas' : 'Notificações desativadas',
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.email),
                title: const Text('Notificações por Email'),
                subtitle: const Text('Receber emails sobre novos produtos'),
                value: false,
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value ? 'Emails ativados' : 'Emails desativados',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // Seção de Privacidade
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Privacidade e Segurança',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Política de Privacidade'),
                subtitle: const Text('Leia nossa política de privacidade'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showPrivacyPolicy(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Termos de Uso'),
                subtitle: const Text('Consulte os termos de uso'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showTermsOfUse(context);
                },
              ),
            ],
          ),
        ),
        // Seção de Conta
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Conta',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Ajuda e Suporte'),
                subtitle: const Text('Obtenha ajuda ou entre em contato'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showHelpDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Sair da Conta',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Fazer logout do aplicativo'),
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha atual',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<AuthProvider>(context, listen: false);
              final ok = await provider.updatePasswordWithReauth(
                currentPassController.text.trim(),
                newPassController.text.trim(),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(ok ? 'Senha alterada com sucesso!' : (provider.errorMessage ?? 'Erro ao alterar senha')),
                    backgroundColor: ok ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Esta é nossa política de privacidade. Aqui você encontrará informações sobre como coletamos, usamos e protegemos seus dados pessoais...\n\n'
            '1. Coleta de Dados\n'
            '2. Uso de Informações\n'
            '3. Compartilhamento\n'
            '4. Segurança\n'
            '5. Seus Direitos',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfUse(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Termos de Uso'),
        content: const SingleChildScrollView(
          child: Text(
            'Termos e Condições de Uso do Inventory Manager\n\n'
            '1. Aceitação dos Termos\n'
            '2. Descrição do Serviço\n'
            '3. Responsabilidades do Usuário\n'
            '4. Conteúdo Proibido\n'
            '5. Limitação de Responsabilidade',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda e Suporte'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Como podemos ajudar você?'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text('suporte@fabads.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 8),
                Text('(11) 9999-9999'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule),
                SizedBox(width: 8),
                Text('Seg-Sex: 9h às 18h'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Redirecionando para o suporte...'),
                ),
              );
            },
            child: const Text('Contatar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Provider.of<AuthProvider>(context, listen: false).logout();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}