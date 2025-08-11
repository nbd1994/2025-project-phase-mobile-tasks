import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_mgt_bloc.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? _productId;
  int? _selectedSize;
  final List<int> _sizes = const [39, 40, 41, 42, 43, 44];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_productId == null) {
      final arg = ModalRoute.of(context)!.settings.arguments as String;
      _productId = arg;
      // Trigger load once
      context.read<ProductMgtBloc>().add(GetSingleProductEvent(arg));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocBuilder<ProductMgtBloc, ProductMgtState>(
          builder: (context, state) {
            if (state is ProductMgtLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            // Expecting a single product state
            if (state is ProductMgtSingleProductLoadedState) {
              final p = state.product;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _DetailsCard(
                  product: p,
                  sizes: _sizes,
                  selectedSize: _selectedSize,
                  onSizeSelected: (v) => setState(() => _selectedSize = v),
                  onDelete: () {
                    // Fire delete and go back
                    context.read<ProductMgtBloc>().add(DeleteProductEvent(p.id));
                    Navigator.pop(context);
                  },
                  onUpdate: () {
                    // Navigate to your edit/add screen; pass product if your screen supports it
                    Navigator.pushNamed(context, '/add-product', arguments: p);
                  },
                ),
              );
            }

            if (state is ProductMgtErrorState) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('Product not found'));
          },
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final Product product;
  final List<int> sizes;
  final int? selectedSize;
  final ValueChanged<int> onSizeSelected;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const _DetailsCard({
    required this.product,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        shadows: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image with rounded top corners and back button overlay
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _BackButton(),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category & rating row (omitted per your note: no data for category/rating)
                // SizedBox(height: 8),

                // Title + price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Size title
                const Text(
                  'Size:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Sizes row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sizes
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _SizeChip(
                              label: s.toString(),
                              selected: selectedSize == s,
                              onTap: () => onSizeSelected(s),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  product.description.isNotEmpty
                      ? product.description
                      : 'No description provided.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 20),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE53935),
                          side: const BorderSide(color: Color(0xFFE53935)),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: onDelete,
                        child: const Text('DELETE'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF007AFF),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: onUpdate,
                        child: const Text('UPDATE'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.9),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.popAndPushNamed(context, '/'),
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SizeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF3B82F6) : Colors.white;
    final fg = selected ? Colors.white : Colors.black87;
    return Material(
      color: bg,
      elevation: selected ? 2 : 0,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: selected
                ? null
                : Border.all(color: Colors.black12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}