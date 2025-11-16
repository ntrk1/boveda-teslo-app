

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/products.dart';

class ProductsMapper {
  static  Product productJsonToEntity(Map<String, dynamic> json) => Product(
    description: json['description'],
    id: json['id'],
    title: json['title'],
    price: double.parse(json['price'].toString()),
    slug: json['slug'],
    stock: json['stock'],
    sizes: List<String>.from(json['sizes'].map((size) => size)),
    gender: json['gender'],
    tags: List<String>.from(json['tags'].map((tag) => tag)),
    images: List<String>.from(
      json['images'].map( 
        (image) => image.startsWith('http')
          ? image
          : '${ Enviroment.apiUrl }/files/product/$image',
      )
    ), 
    user: UserMapper.userJsonToEntity( json['user'] ),
    );
}

