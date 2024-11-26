import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductBox extends StatelessWidget {
  const ProductBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      shadowColor: Colors.black87,
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      margin: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {},
        child: Column(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: const NetworkImage(
                  "https://images.rawpixel.com/image_png_800/"
                  "czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcGYtczg3LW1uLTI1LTAxLnBuZw.png"),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300, // Set a specific height
            ),
            Container(
              padding: const EdgeInsets.all(10.0), // Add padding
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "This some data, a very very very long data",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "This is the price of the meal €",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Text(
                    "This is the nutrition about the product",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black87),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {},
                      child: const Text("Add to cart"),),
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*


return Center(
      child: Container(
        height: 300,
        width: 200,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Colors.blueGrey,
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(4, 4),
                blurRadius: 15.0,
                spreadRadius: 1.0),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Product price",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Product price",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Product price",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
 */
