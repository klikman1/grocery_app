import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import '../Provider/ProductProvider.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState(){
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

  // Pick image from Gallery or Camera and
  // Save image that's coming from Camera
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);

      // Save the image to gallery if it was taken from the camera
      if (source == ImageSource.camera) {
        try {
          SaverGallery.saveImage(file.readAsBytesSync(), fileName: picked.path, skipIfExists: false);
          print("Save to gallery");
        } catch (e) {
          print("Error saving image to gallery: $e");
        }
      }
      setState(() {
        _imageFile = file;
      });
    }
  }

  // Show bottom sheet with options to choose image source
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

  // Create a product form
  Future<void> createProduct(BuildContext context) async {
    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text) ?? 0.0;
    final description = descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty || _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    final provider = Provider.of<ProductProvider>(context, listen: false);

    await provider.createProduct(name, 1, price, description,  _imageFile!.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Product")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => showImageSourceChoices(context),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                  backgroundColor: Colors.grey[200],
                  child: _imageFile == null
                      ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                      : null,
                ),
              ),

              const SizedBox(height: 20),
              //------------------Product's name text field--------------------
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),
              //------------------Product's price text field-------------------
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (€)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),
              //------------------Product's description text field-------------
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description / Nutrition details",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              //------------------------ Save product -------------------------
              ElevatedButton.icon(
                onPressed: () => createProduct(context),
                icon: const Icon(Icons.save),
                label: const Text("Create Product"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
