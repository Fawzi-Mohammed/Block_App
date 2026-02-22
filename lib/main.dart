import 'package:block_app/controllers/cubit/product_cubit.dart';
import 'package:block_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        scaffoldBackgroundColor: const Color(0xFFF2F5F7),
      ),
      home: const ProductsPage(),
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit()..getProductData(),
      child: const _ProductsView(),
    );
  }
}

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAF4F3), Color(0xFFF6F7F8)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              final stateView = switch (state) {
                ProductLoading() => const _LoadingView(
                  key: ValueKey('loading_state'),
                ),
                ProductLoaded(:final products) => _LoadedView(
                  key: const ValueKey('loaded_state'),
                  products: products,
                  isRefreshing: false,
                ),
                ProductRefreshing(:final products) => _LoadedView(
                  key: const ValueKey('loaded_state'),
                  products: products,
                  isRefreshing: true,
                ),
                ProductError(:final errorMessage) => _ErrorView(
                  key: const ValueKey('error_state'),
                  errorMessage: errorMessage,
                  onRetry: () => context.read<ProductCubit>().getProductData(),
                ),
              };

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: child,
                    ),
                  );
                },
                child: stateView,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final List<ProductModel> products;
  final bool isRefreshing;

  const _LoadedView({
    super.key,
    required this.products,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products available right now.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Products',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              IconButton.filledTonal(
                tooltip: isRefreshing ? 'Refreshing...' : 'Refresh',
                onPressed: isRefreshing
                    ? null
                    : () => context.read<ProductCubit>().refreshProducts(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: isRefreshing
                      ? const SizedBox(
                          key: ValueKey('refresh_loader'),
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        )
                      : const Icon(
                          Icons.refresh_rounded,
                          key: ValueKey('refresh_icon'),
                        ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ProductCubit>().refreshProducts(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _AnimatedListEntry(
                index: index,
                child: _ProductCard(product: products[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                color: const Color(0xFFF2F5F7),
                child: Image.network(
                  product.image,
                  width: 96,
                  height: 96,
                  fit: BoxFit.contain,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }

                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                  errorBuilder: (_, error, stackTrace) => const SizedBox(
                    width: 96,
                    height: 96,
                    child: Icon(Icons.image_not_supported_outlined),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F4F1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      product.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF0F766E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF0F766E),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating.rate} (${product.rating.count})',
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: Colors.black87),
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

class _LoadingView extends StatelessWidget {
  const _LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(height: 14),
          Text('Loading products...'),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const _ErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cleanedMessage = errorMessage.replaceFirst('Exception: ', '');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutBack,
              tween: Tween(begin: 0.85, end: 1),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 42,
                  color: Color(0xFFBE123C),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'We could not load products right now. Please try again.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              cleanedMessage,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black45),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedListEntry extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedListEntry({required this.index, required this.child});

  @override
  State<_AnimatedListEntry> createState() => _AnimatedListEntryState();
}

class _AnimatedListEntryState extends State<_AnimatedListEntry> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    final rawDelay = widget.index * 70;
    final delayMs = rawDelay > 420 ? 420 : rawDelay;
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _isVisible ? Offset.zero : const Offset(0, 0.06),
      duration: const Duration(milliseconds: 430),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 430),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
