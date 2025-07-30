import 'package:flutter/material.dart';

import 'home_page.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Utils().padding(hor: 0, ver: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: Utils().padding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: ()=>Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back)
                    ),
                    const Text('Add Product'),
                    const SizedBox(width: 30),
                  ],
                ),
              ),
              Padding(
                padding: Utils().padding(ver: 10),
                child: MyForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum InputType { image, name, price, category, description }

class MyForm extends StatelessWidget {
  MyForm({super.key});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionConroller = TextEditingController();
  final _priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyImageInputField(),
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
            padding: Utils().padding(ver: 10),
            child: const Center(
              child: FilledButton(onPressed: null, child: Text('Add')),
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
      padding: Utils().padding(ver: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getLabel()),
          Padding(
            padding: Utils().padding(ver: 10, hor: 0),
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
  const MyImageInputField({super.key});

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
            const Icon(Icons.image_search_outlined),
            Padding(
              padding: Utils().padding(ver: 10),
              child: const Text('Upload Image'),
            )
          ],
        ),
      ),
    );
  }
}
