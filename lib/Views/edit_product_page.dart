import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
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
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null) {
        final tempImage = File(picked.path);

        // Get persistent app directory
        final appDir = await getApplicationDocumentsDirectory();

        // Create shorter filename using timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final extension = path.extension(picked.path);
        final fileName = 'img_$timestamp$extension';

        // Copy image to persistent location
        final savedImage = await tempImage.copy('${appDir.path}/$fileName');

        setState(() {
          _imageFile = savedImage;
        });

        print("Image saved locally at: ${savedImage.path}");
      }
    } catch (e) {
      print(" Error picking or saving image: $e");
    }
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
                          : File(widget.image).existsSync()
                              ? FileImage(File(widget.image))
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

                      final provider =
                          Provider.of<ProductProvider>(context, listen: false);

                      // Replace commas with dots before parsing to double
                      final rawPrice =
                          priceController.text.trim().replaceAll(',', '.');
                      final parsedPrice = double.tryParse(rawPrice) ?? 0.0;

                      await provider.updateProduct(
                        productId: widget.productId,
                        name: nameController.text,
                        unityPrice: parsedPrice,
                        nutritionDetails: descriptionController.text,
                        imageUrl: _imageFile != null
                            ? _imageFile!.path
                            : widget.image,
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
