import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  final String name;
  final double price;
  final String description;
  final String image;

  const EditProductPage({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  State<StatefulWidget> createState() {
    return EditProductPageState();
  }
}

class EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  // Show bottom sheet with options to choose image source
  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text("Take a photo"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text("Choose from gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    priceController = TextEditingController(text: widget.price.toString());
    descriptionController = TextEditingController(text: widget.description);
  }

  // Pick image from Gallery or Camera
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showImageSourceOptions(context),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage(widget.image) as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              //------------------Product's name text field--------------------
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Product Name"),
              ),

              //------------------Product's price text field-------------------
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Price (€) "),
              ),

              //------------------Product's description text field-------------
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description/ Nutrition details"),
              ),
              SizedBox(height: 20),

              //------------------------ Save changes -------------------------
              ElevatedButton(
                onPressed: () async {
                  final provider =
                      Provider.of<ProductProvider>(context, listen: false);

                  await provider.updateProduct(
                    productId: widget.productId,
                    name: nameController.text,
                    unityPrice: double.tryParse(priceController.text) ?? 0.0,
                    nutritionDetails: descriptionController.text,
                    imageUrl:
                        _imageFile != null ? _imageFile!.path : widget.image,
                  );

                  Navigator.pop(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
