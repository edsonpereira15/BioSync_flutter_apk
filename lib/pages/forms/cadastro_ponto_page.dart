import 'package:flutter/material.dart';

class CadastroPontoPage extends StatefulWidget {
  const CadastroPontoPage({super.key});

  @override
  State<CadastroPontoPage> createState() => _CadastroPontoPageState();
}

class _CadastroPontoPageState extends State<CadastroPontoPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  String? selectedCategory;

  final List<String> categorias = ['Papel', 'Plástico', 'Vidro', 'Metal', 'Eletrônicos'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Novo Ponto de Descarte'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome do Local'),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.black54, fontSize: 16),
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Endereço'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              hint: const Text('Categoria Principal'),
              items: categorias.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (val) => setState(() => selectedCategory = val),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  print("Ponto criado: ${nameController.text}");
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ponto registrado!')),
                  );
                },
                child: const Text('Cadastrar Ponto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}