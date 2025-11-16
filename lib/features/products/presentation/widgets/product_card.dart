
import 'package:flutter/widgets.dart';
import 'package:teslo_shop/features/products/products.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageView(images: product.images),
        Text(product.title),
        SizedBox(height: 15)
      ],
    );
  }
}

class _ImageView extends StatelessWidget {
  final List<String> images;
  const _ImageView({required this.images});

  @override
  Widget build(BuildContext context) {
    
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
        fit: BoxFit.cover,
        height: 250,
        ),
      );
    }


    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        image: NetworkImage(images.first),
        placeholder: AssetImage('assets/loaders/bottle-loader.gif'), 
        )
    );
  }
}