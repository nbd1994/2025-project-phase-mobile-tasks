// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/common/bloc/button/button_state.dart';
// import '../../../../core/common/bloc/button/button_state_cubit.dart';
// import '../../../../core/common/widgets/button/basic_app_button.dart';
// import '../../../../core/usecases/usecase.dart';
// import '../../../../injection_container.dart';
// import '../../../../core/entities/user.dart';
// import '../../../authentication/domain/usecases/logout_usecase.dart';
// import '../../../authentication/presentation/bloc/user_display_cubit.dart';
// import '../../../authentication/presentation/bloc/user_display_state.dart';
// import '../../domain/entities/product.dart';
// import '../bloc/product_mgt_bloc.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProductMgtBloc>().add(LoadAllProductEvent());
//     });

//     return BlocListener<ButtonStateCubit, ButtonState>(
//       listener: (context, buttonState) {
//         if (buttonState is ButtonSuccessState) {
//           Navigator.pushReplacementNamed(context, '/signup');
//         }
//       },
//       child: Scaffold(
//         floatingActionButton: IconButton(
//           onPressed: () => Navigator.pushNamed(context, '/add-product'),
//           icon: const Icon(Icons.add_circle),
//           iconSize: 60,
//           color: Colors.green,
//         ),
//         body: BlocBuilder<ProductMgtBloc, ProductMgtState>(
//           builder: (context, state) {
//             if (state is ProductMgtLoadingState) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (state is ProductMgtAllProductsLoadedState) {
//               return BlocListener<ButtonStateCubit, ButtonState>(
//                 listener: (context, state) {
//                   if (state is ButtonSuccessState) {
//                     Navigator.pushReplacementNamed(context, '/signup');
//                   }
//                 },
//                 child: BlocBuilder<UserDisplayCubit, UserDisplayState>(
//                   builder: (context, s) {
//                     if (s is UserLoadingState) {
//                       return Column(
//                         children: [
//                           const _MyAppBarLoading(),
//                           const MyAvailableProductsTitle(),
//                           Expanded(
//                             child: ProductsList(products: state.products),
//                           ),
//                         ],
//                       );
//                     } else if (s is UserLoadedState) {
//                       final user = s.user;
//                       return Column(
//                         children: [
//                           _MyAppBarLoaded(user: user),
//                           const MyAvailableProductsTitle(),
//                           Expanded(
//                             child: ProductsList(products: state.products),
//                           ),
//                         ],
//                       );
//                     }
//                     return Column(
//                       children: [
//                         const _MyAppBarFailed(),
//                         const MyAvailableProductsTitle(),
//                         Expanded(child: ProductsList(products: state.products)),
//                       ],
//                     );
//                   },
//                 ),
//               );
//             } else if (state is ProductMgtErrorState) {
//               return Center(child: Text(state.message));
//             }
//             return const Center(child: Text('No Products Found'));
//           },
//         ),
//       ),
//     );
//   }
// }

// class _MyAppBarFailed extends StatelessWidget {
//   const _MyAppBarFailed({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: Utils().padding(),
//       leading: CircleAvatar(child: Image.asset('assets/images/avatar.jpg')),
//       title: Text('${DateTime(2025)}'),
//       subtitle: const Text('couldnt load user'),
//       trailing: SizedBox(
//         width: 110, // Adjust width as needed
//         child: _logout(context),
//       ),
//     );
//   }
// }

// class _MyAppBarLoading extends StatelessWidget {
//   const _MyAppBarLoading({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: Utils().padding(),
//       leading: CircleAvatar(child: Image.asset('assets/images/avatar.jpg')),
//       title: Text(DateTime(2025).year.toString()),
//       subtitle: const Text('getting user data'),
//       trailing: SizedBox(
//         width: 80, // Adjust width as needed
//         child: _logout(context),
//       ),
//     );
//   }
// }

// class _MyAppBarLoaded extends StatelessWidget {
//   final User user;
//   const _MyAppBarLoaded({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: Utils().padding(),
//       leading: CircleAvatar(child: Image.asset('assets/images/avatar.jpg')),
//       title: Text(DateTime(2025).year.toString()),
//       subtitle: Text('Hello ${user.name}'),
//       trailing: SizedBox(
//         width: 80, // Adjust width as needed
//         child: _logout(context),
//       ),
//     );
//   }
// }

// Widget _logout(BuildContext context) {
//   return Builder(
//     builder: (context) {
//       return BasicAppButton(
//         width: 250,
//         title: 'log out',
//         onPressed: () {
//           context.read<ButtonStateCubit>().execute(
//             useCase: sl<LogoutUsecase>(),
//             params: NoParams(),
//           );
//         },
//       );
//     },
//   );
// }

// class MyAvailableProductsTitle extends StatelessWidget {
//   const MyAvailableProductsTitle({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: Utils().padding(ver: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Available Products'),
//           IconButton(
//             onPressed: () => Navigator.pushNamed(context, '/search'),
//             icon: const Icon(Icons.search),
//           ),
//           OutlinedButton(onPressed:()=> Navigator.pushNamed(context, '/users'), child: const Text('users'))
//         ],
//       ),
//     );
//   }
// }

// class ProductCard extends StatelessWidget {
//   const ProductCard({super.key, required this.pdt});
//   final Product pdt;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap:
//           () => Navigator.pushNamed(
//             context,
//             '/product-details',
//             arguments: pdt.id,
//           ),
//       child: Card(
//         elevation: 2.5,
//         clipBehavior: Clip.antiAlias,
//         // elevation: ,
//         color: const Color.fromARGB(234, 236, 235, 235),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           children: [
//             Image.network(
//               pdt.imageUrl,
//               width: double.infinity,
//               height: 160.0,
//               fit: BoxFit.cover,
//             ),
//             // Container(height: 120.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text(pdt.name), Text('\$${pdt.price}')],
//             ),
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //   children: [
//             //     Text('${pdt.category} Shoes'),
//             //     const Row(children: [Icon(Icons.star), Text('(4.0)')]),
//             //   ],
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProductsList extends StatelessWidget {
//   const ProductsList({super.key, required this.products});
//   final List<Product> products;
//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       childAspectRatio: 5 / 2.7,
//       crossAxisCount: 1,
//       mainAxisSpacing: 20,
//       padding: Utils().padding(),
//       shrinkWrap: true,
//       children: List.generate(
//         products.length,
//         (int index) => ProductCard(pdt: products[index]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/common/bloc/button/button_state.dart';
import '../../../../core/common/bloc/button/button_state_cubit.dart';
import '../../../../core/common/widgets/avatar_widget.dart';
import '../../../../core/common/widgets/button/basic_app_button.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../features/authentication/presentation/bloc/user_display_cubit.dart';
import '../../../../features/authentication/presentation/bloc/user_display_state.dart';
import '../../../../injection_container.dart';
import '../../../authentication/domain/usecases/logout_usecase.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_mgt_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String _formattedDate() {
    final dt = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserDisplayCubit>().state;
    final name = userState is UserLoadedState ? userState.user.name : 'User';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductMgtBloc>().add(LoadAllProductEvent());
    });

    return BlocListener<ButtonStateCubit, ButtonState>(
      listener: (context, buttonState) {
        if (buttonState is ButtonSuccessState) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
        if (buttonState is ButtonFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(buttonState.errorMessage ?? 'Logout failed'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 48,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AvatarWidget(name: name, radius: 20.0),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formattedDate(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Hello, $name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.notifications_none),
            //   onPressed: () {},
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: _logout(context),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Available Products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Navigator.pushNamed(context, '/search'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<ProductMgtBloc, ProductMgtState>(
                  builder: (context, state) {
                    if (state is ProductMgtLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ProductMgtAllProductsLoadedState) {
                      final products = state.products;
                      return ListView.separated(
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final p = products[i];
                          return _ProductCard(product: p);
                        },
                      );
                    }
                    return const Center(child: Text('No products'));
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton(
      heroTag: 'add',
      onPressed: () => Navigator.pushNamed(context, '/add-product'),
      child: const Icon(Icons.add),
    ),
    const SizedBox(height: 12),
    FloatingActionButton(
      heroTag: 'chat',
      onPressed: () => Navigator.pushNamed(context, '/users'),
      child: const Icon(Icons.people),
    ),
  ],
),
      ),
    );
  }
}

// ...existing code...
class _ProductCard extends StatelessWidget {
  final Product product;
  const _ProductCard({required this.product, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double rating = 4.0;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/product-details',
        arguments: product.id,
      ),
      child: Card(
        color: const Color(0xFFF8F8F8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with a bit smaller height so text area is more visible
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 160, // was 180
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 160,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and price
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
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
                  const SizedBox(height: 8),

                  // Category chip + rating stars
                  Row(
                    children: [
                      // _CategoryChip(text: 'Mens'),
                      const Spacer(),
                      _RatingStars(rating: rating),
                      const SizedBox(width: 6),
                      Text(
                        '(${rating.toStringAsFixed(1)})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _RatingStars extends StatelessWidget {
  final double rating; // e.g., 4.0
  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    const total = 5;
    final filled = rating.floor();
    final half = (rating - filled) >= 0.5 ? 1 : 0;
    final empty = total - filled - half;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < filled; i++)
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFC107)),
        if (half == 1)
          const Icon(Icons.star_half_rounded, size: 16, color: Color(0xFFFFC107)),
        for (int i = 0; i < empty; i++)
          Icon(Icons.star_border_rounded, size: 16, color: Colors.grey.shade400),
      ],
    );
  }
}
// ...existing code...

Widget _logout(BuildContext context) {
  return SizedBox(
    width: 110, // or whatever fits your design
    height: 40,
    child: Builder(
      builder: (context) {
        return BasicAppButton(
          title: 'Logout',
          onPressed: () {
            context.read<ButtonStateCubit>().execute(
              useCase: sl<LogoutUsecase>(),
              params: NoParams(),
            );
          },
        );
      },
    ),
  );
}

// Widget _chatsButton(BuildContext context) {
//   return Builder(
//     builder: (context) {
//       return SizedBox(
//         height: 70.0,
//         width: 140.0,
//         child: OutlinedButton(
//           onPressed: () => Navigator.pushNamed(context, '/users'),
//           style: OutlinedButton.styleFrom(
//             foregroundColor: const Color(0xFFE53935),
//             side: const BorderSide(color: Color(0xFFE53935)),
//             minimumSize: const Size.fromHeight(48),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//           ),
//           child: const Text('People'),
//         ),
//       );
//     }
//   );
// }

class Utils {
  EdgeInsets padding({hor = 25.0, ver = 0.0}) {
    return EdgeInsets.fromLTRB(hor, ver, hor, 0.0);
  }
}
