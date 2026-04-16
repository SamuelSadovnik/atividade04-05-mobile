import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/widgets/product_form_fields.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key, this.initialProduct});

  final Product? initialProduct;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;

  bool get _isEditing => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialProduct?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.initialProduct?.price.toString() ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialProduct?.description ?? '',
    );
    _imageController = TextEditingController(
      text: widget.initialProduct?.image ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final parsedPrice =
        double.parse(_priceController.text.trim().replaceAll(',', '.'));

    final product = Product(
      id: widget.initialProduct?.id,
      name: _nameController.text.trim(),
      price: parsedPrice,
      description: _descriptionController.text.trim(),
      image: _imageController.text.trim(),
      category: widget.initialProduct?.category ?? 'general',
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar produto' : 'Cadastrar produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ProductFormFields(
                nameController: _nameController,
                priceController: _priceController,
                descriptionController: _descriptionController,
                imageController: _imageController,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: Icon(_isEditing ? Icons.save_outlined : Icons.add),
                  label: Text(_isEditing ? 'Salvar alteracoes' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
