import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductProvider.dart';


class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() {
    return CreateProductPageState();
  }
}

class CreateProductPageState extends State<CreateProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        _imageFile = file;
      });
    }
  }

  void showImageSourceChoices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Take a photo"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Choose from gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> createProduct(BuildContext context) async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim().replaceAll(',', '.');
    final price = double.tryParse(priceText) ?? 0.0;
    final description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final provider = Provider.of<ProductProvider>(context, listen: false);

    await provider.createProduct(name, 1, price, description, _imageFile!.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product created')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Dismiss keyboard when tapping outside
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("New Product")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                // ------------------ Image picker ------------------
                GestureDetector(
                  onTap: () => showImageSourceChoices(context),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: Colors.grey[200],
                    child: _imageFile == null
                        ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                // ------------------ Name Field ------------------
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 12),

                // ------------------ Price Field ------------------
                TextField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Price (€)",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 12),

                // ------------------ Description Field ------------------
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description / Nutrition details",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 20),

                // ------------------ Save Button ------------------
                ElevatedButton.icon(
                  onPressed: () => createProduct(context),
                  icon: const Icon(Icons.save),
                  label: const Text("Create Product"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
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
