import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'features/product_mgt/data/models/product_model.dart';
import 'features/product_mgt/presentation/bloc/product_mgt_bloc.dart';
import 'features/product_mgt/presentation/pages/home_page.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductMgtBloc, ProductMgtState>(
      listener: (context, state) {
        if (state is ProductMgtLoadingState) {
          const Center(child: CircularProgressIndicator());
        } else if (state is ProductMgtErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ProductMgtAllProductsLoadedState) {
          // Success: pop or show a success message
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: Utils().padding(hor: 0.0, ver: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: Utils().padding(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Text('Add Product'),
                      const SizedBox(width: 30),
                    ],
                  ),
                ),
                Padding(padding: Utils().padding(ver: 10.0), child: MyForm()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum InputType { image, name, price, category, description }

class MyForm extends StatefulWidget {
  const MyForm({super.key});
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  // _MyFormState({super.key});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionConroller = TextEditingController();
  final _priceController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(onTap:_pickImage, child:MyImageInputField(imagePath: _imagePath,)),
          MyTextInput(
            myInputType: InputType.name,
            myConroller: _nameController,
          ),
          MyTextInput(
            myInputType: InputType.category,
            myConroller: _categoryController,
          ),
          MyTextInput(
            myInputType: InputType.price,
            myConroller: _priceController,
          ),
          MyTextInput(
            myInputType: InputType.description,
            myConroller: _descriptionConroller,
          ),

Padding(
  padding: Utils().padding(ver: 20.0),
  child: SizedBox(
    width: double.infinity,
    child: FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final product = ProductModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameController.text,
            price: double.tryParse(_priceController.text) ?? 0.0,
            imageUrl: _imagePath ?? '',
            description: _descriptionConroller.text,
          );
          context.read<ProductMgtBloc>().add(
            CreateProductEvent(product),
          );
        }
      },
      child: const Text(
        'ADD',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  const MyTextInput({
    super.key,
    required this.myInputType,
    required this.myConroller,
  });
  final InputType myInputType;
  final TextEditingController myConroller;

  String _getLabel() {
    switch (myInputType) {
      case InputType.name:
        return 'Name';
      case InputType.category:
        return 'Category';
      case InputType.description:
        return 'Description';
      case InputType.image:
        return 'Image';
      case InputType.price:
        return 'Price';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils().padding(ver: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getLabel()),
          Padding(
            padding: Utils().padding(ver: 10.0, hor: 0.0),
            child: TextFormField(
              controller: myConroller,
              maxLines: myInputType == InputType.description ? 6 : null,
              keyboardType:
                  myInputType == InputType.description
                      ? TextInputType.multiline
                      : null,
              decoration: InputDecoration(
                suffixIcon:
                    myInputType == InputType.price
                        ? const Icon(Icons.attach_money)
                        : null,
                filled: true,
                fillColor: const Color.fromARGB(255, 244, 244, 244),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyImageInputField extends StatelessWidget {
final String? imagePath;
  const MyImageInputField({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Utils().padding(),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 244, 244, 244),
        ),
        height: 150.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          imagePath != null ? Image.file(File(imagePath!), height: 100.0) : const Icon(Icons.image_search_outlined),
            Padding(
              padding: Utils().padding(ver: 10.0),
              child: Text(imagePath != null ? 'Image Selected' : 'Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}
