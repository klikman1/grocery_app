import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductProvider.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProductPage> {
  // Holds the selected image
  File? uploadedImage;

  // Text controllers for product details
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _nutritionController = TextEditingController();
  final _stockQuantityController = TextEditingController(); // Added stock quantity controller

  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free memory
    _nameController.dispose();
    _priceController.dispose();
    _nutritionController.dispose();
    _stockQuantityController.dispose(); // Dispose stock quantity controller
    super.dispose();
  }

  // Function to pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        uploadedImage = File(pickedImage.path); // Update uploaded image
      });
    }
  }

  // Function to handle form submission
  void onSubmitProduct() {
    if (_formKey.currentState!.validate()) {
      // Retrieve form inputs
      final pName = _nameController.text;
      final pUnityPrice = double.parse(_priceController.text);
      final pNutritionDetails = _nutritionController.text;
      final pStockQuantity = int.parse(_stockQuantityController.text); // Parse stock quantity
      final pImageUrl = uploadedImage?.path;

      // Access the product provider
      final provider = Provider.of<ProductProvider>(context, listen: false);

      // Add product to the provider
      provider.createProduct(
        pName,
        pStockQuantity, // Use stock quantity from input
        pUnityPrice,
        pNutritionDetails,
        pImageUrl ??
            "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/450px-No_image_available.svg.png", // Provide default image
      );

      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added!')),
      );
      Navigator.pop(context); // Return to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Links the form to the formKey
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image upload section
                    GestureDetector(
                      onTap: pickImageFromGallery, // Opens gallery on tap
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
                    // Input fields section
                    Expanded(
                      child: Column(
                        children: [
                          // Product name field
                          TextFormField(
                            controller: _nameController,
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
                          // Stock quantity field (replacing category dropdown)
                          TextFormField(
                            controller: _stockQuantityController,
                            decoration: const InputDecoration(
                              labelText: "Stock Quantity",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty || int.tryParse(value) == null) {
                                return "Please enter a valid stock quantity";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          // Price field
                          TextFormField(
                            controller: _priceController,
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
                // Nutrition details or ingredients field
                TextFormField(
                  controller: _nutritionController,
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
                // Submit button
                Center(
                  child: ElevatedButton(
                    onPressed: onSubmitProduct,
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
