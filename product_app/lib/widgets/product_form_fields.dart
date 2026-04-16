import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  const ProductFormFields({
    super.key,
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.imageController,
  });

  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final TextEditingController imageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nome'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o nome do produto';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Preco'),
          validator: (value) {
            final parsed = double.tryParse((value ?? '').replaceAll(',', '.'));
            if (parsed == null || parsed < 0) {
              return 'Informe um preco valido';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: descriptionController,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Descricao'),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe a descricao';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: imageController,
          decoration: const InputDecoration(labelText: 'URL da imagem (opcional)'),
        ),
      ],
    );
  }
}
