import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewProductPage extends StatefulWidget {
  NewProductPage({super.key});

  final formKey = GlobalKey<FormState>();
  final _categories = ['Beverages', 'Snacks', 'Dairy', 'Fruits'];

  @override
  State<StatefulWidget> createState() {
    return _NewProductState();
  }
}

class _NewProductState extends State<NewProductPage> {
  @override
  Widget build(BuildContext context) {
    File? uploadedImage;
    String? _selectedCategory;
    
    Future pickImageFromGallery() async {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImage != null){
        setState(() {
          uploadedImage = File(returnedImage.path);
        });
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Upload Section
                  GestureDetector(
                    onTap: pickImageFromGallery,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: uploadedImage != null
                          ? Image.file(uploadedImage!, fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo, size: 40),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // Input Fields
                  Expanded(
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Product Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a product name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Category",
                          ),
                          items: widget._categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        // Price Field
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Price",
                            prefixText: "€ ",

                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.tryParse(value) == null) {
                              return "Please enter a valid price";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Nutrition Details or Ingredients
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nutrition Details / Ingredients",
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter nutrition details or ingredients";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Product added!')),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  
}
