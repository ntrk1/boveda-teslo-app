

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class HypoProductScreen extends ConsumerWidget {
  final String productId;
  const HypoProductScreen({super.key, required this.productId});

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto actualizado'))
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(hypoProductProvider(productId));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('data'),
          actions: [
            IconButton(
              
              onPressed: () async {
                
                final photoPath = await CameraGalleryImpl().selecPhoto();
                if (photoPath == null) return;
             //   photoPath;
                 ref.read(productFormProvider(productState.product!).notifier)
                 .updateProductImage(photoPath);
              }, 
              icon: Icon(Icons.browse_gallery_outlined)),
            IconButton(onPressed: () async {
              final photoPath = await CameraGalleryImpl().takePhoto();
              if (photoPath == null) return;
         //     photoPath;
               ref.read(productFormProvider(productState.product!).notifier)
                 .updateProductImage(photoPath);
            }, 
            icon: Icon(Icons.camera_alt_rounded)
            )
          ],
        ),
        body: productState.isLoading
        ? FullScreenLoader()
        : _ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
          onPressed: () async  {
            if (productState.product == null) return;
            final result = await ref.read(productFormProvider(productState.product!).notifier)
            .onFormSubmit();
            if (!result || !context.mounted) return;
            showSnackBar(context);
          },
          child: Icon(Icons.save_alt_outlined),
          ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {

  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productForm = ref.watch(productFormProvider(product));

    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
    
          SizedBox(
            height: 250,
            width: 600,
            child: _ImageGallery(images: productForm.images ),
          ),
    
          const SizedBox( height: 10 ),
          Center(child: Text( productForm.title.value, style: textStyles.titleSmall )),
          const SizedBox( height: 10 ),
          _ProductInformation( product: product ),
          
        ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

    final productForm = ref.watch(productFormProvider(product));

    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15 ),
          Text('Producto'),
          CustomProductField( 
            isTopField: true,
            initialValue: productForm.title.value,
            onChanged: ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          Text('Slug'),
          CustomProductField( 
            isTopField: true,
            initialValue: productForm.slug.value,
            onChanged: ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          Text('Precio'),
          CustomProductField( 
            isBottomField: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product)
            .notifier).onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15 ),
          const Text('Extras'),

          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged: ref.read(productFormProvider(product).notifier).onSizeChanged
             ),
          const SizedBox(height: 5 ),
          _GenderSelector( 
            selectedGender: productForm.gender,
            onGenderChanged: ref.read(productFormProvider(product).notifier).onGenderChanged,
             ),
          

          const SizedBox(height: 15 ),
          Text('Existencias'),
          CustomProductField( 
            isTopField: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product)
            .notifier).onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.inStock.errorMessage,
          ),
          Text('Descrripción'),
          CustomProductField( 
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref.read(productFormProvider(product).notifier).onDescriptionChanged,
          ),
          Text('Tags'),
          CustomProductField( 
            isBottomField: true,
            maxLines: 2,
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: ref.read(productFormProvider(product).notifier).onTagsChanged,

          ),


          const SizedBox(height: 100 ),
        ],
      ),
    );
  }
}


class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];
  final void Function(List<String> selectedSizes) onSizesChanged;
  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged
    });


  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size, 
          label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(), 
      selected: Set.from( selectedSizes ),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChanged(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const['men','women','kid'];
  final void Function(String selectedGender) onGenderChanged;
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged
    });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon( genderIcons[ genders.indexOf(size) ] ),
            value: size, 
            label: Text(size, style: const TextStyle(fontSize: 12))
          );
        }).toList(), 
        selected: { selectedGender },
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          onGenderChanged(newSelection.first);
        },
      ),
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          ),
      );
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.7
      ),
      children: images.map((e){

        late ImageProvider imageProvider;
        if (e.startsWith('http')) {
          imageProvider = NetworkImage(e);
        } else {
          imageProvider = FileImage(File(e));
        }


          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/loaders/bottle-loader.gif'), 
                image: imageProvider
                )
            ),
          );
      }).toList(),
    );
  }
}