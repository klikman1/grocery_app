import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:techno_mobile/firebaseAPI/FireStorageService.dart';
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

  final _storageService = Firestorageservice();
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

  // Pick Image from Gallery or Camera and
  // Save image that's coming from Camera
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        _imageFile = file;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    priceController = TextEditingController(text: widget.price.toString());
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context)
                .unfocus(), // Dismiss keyboard when tapping outside
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ------------------ Image picker ------------------
                  GestureDetector(
                    onTap: () => _showImageSourceOptions(context),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : widget.image.isNotEmpty
                              ? NetworkImage(widget.image)
                              : const AssetImage("assets/placeholder.png")
                                  as ImageProvider,
                      child: const Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ------------------ Name Field ------------------
                  TextField(
                    controller: nameController,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration:
                        const InputDecoration(labelText: "Product Name"),
                  ),

                  // ------------------ Price Field ------------------

                  TextField(
                    controller: priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: "Price (€)"),
                  ),

                  // ------------------ Description Field ------------------
                  TextField(
                    controller: descriptionController,
                    textInputAction: TextInputAction.done,
                    maxLines: 3,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                        labelText: "Description / Nutrition details"),
                  ),

                  const SizedBox(height: 20),

                  // ------------------ Save Button ------------------
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty ||
                          priceController.text.trim().isEmpty) {
                        return;
                      }

                      final provider = Provider.of<ProductProvider>(context, listen: false);

                      // Replace commas with dots 
                      final rawPrice = priceController.text.trim().replaceAll(',', '.');
                      final parsedPrice = double.tryParse(rawPrice) ?? 0.0;

                      String downloadUrl = widget.image;

                      // Upload a new image if one was picked
                      if (_imageFile != null) {
                        final uploadedUrl =
                            await _storageService.uploadImageToFirebase(
                          _imageFile!,
                          customName: nameController.text
                              .replaceAll(' ', '_')
                              .toLowerCase(),
                        );

                        if (uploadedUrl == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Image upload failed')),
                          );
                          return;
                        }

                        downloadUrl = uploadedUrl;
                      }

                      await provider.updateProduct(
                        productId: widget.productId,
                        name: nameController.text,
                        unityPrice: parsedPrice,
                        nutritionDetails: descriptionController.text,
                        imageUrl: downloadUrl,
                      );

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
