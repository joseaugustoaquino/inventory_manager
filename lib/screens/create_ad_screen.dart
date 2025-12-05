import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';

class CreateAdScreen extends StatefulWidget {
  const CreateAdScreen({super.key});

  @override
  State<CreateAdScreen> createState() => _CreateAdScreenState();
}

class _CreateAdScreenState extends State<CreateAdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _barcodeController = TextEditingController();
  String _selectedCategory = 'Eletrônicos';
  bool _isLoading = false;

  final List<String> _categories = [
    'Eletrônicos',
    'Veículos',
    'Imóveis',
    'Moda',
    'Casa e Jardim',
    'Esportes',
    'Outros'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _createAd() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userProducts = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .collection('produtos');

      final now = DateTime.now().toUtc();
      await userProducts.add({
        'title': _titleController.text.trim(),
        'titleLowercase': _titleController.text.trim().toLowerCase(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'category': _selectedCategory,
        'categoryLowercase': _selectedCategory.toLowerCase(),
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produto criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar produto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _buscarProdutoPorBarcode() async {
    final err = Validators.validateBarcode(_barcodeController.text);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    try {
      final data = await ApiService.fetchProductByBarcode(_barcodeController.text);
      if (data == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produto não encontrado')));
        }
        return;
      }
      final categoriesText = (data['categories'] ?? '').toString();
      final firstCategory = categoriesText
          .split(',')
          .map((s) => s.trim())
          .firstWhere((c) => c.isNotEmpty, orElse: () => _selectedCategory);
      final matchedCategory = _categories.contains(firstCategory) ? firstCategory : _selectedCategory;

      setState(() {
        _titleController.text = data['name']?.toString() ?? _titleController.text;
        _selectedCategory = matchedCategory;
        _descriptionController.text = data['description']?.toString() ?? _descriptionController.text;
      });


      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados preenchidos a partir do código de barras')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro na consulta: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Produto'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _body(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _barcodeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Código de barras (EAN/UPC)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code_2),
                  ),
                  validator: Validators.validateBarcode,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _buscarProdutoPorBarcode,
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Título do Produto',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um título';
              }
              if (value.length < 5) {
                return 'Título deve ter pelo menos 5 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.category),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma descrição';
              }
              if (value.length < 20) {
                return 'Descrição deve ter pelo menos 20 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Preço (R\$)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira um preço';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Por favor, insira um preço válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _createAd,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Criar Produto'),
          ),
        ],
      ),
    );
  }
}