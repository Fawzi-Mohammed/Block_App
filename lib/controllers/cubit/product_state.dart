part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductLoading extends ProductState {
  @override
  List<Object> get props => [];
}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;

  const ProductLoaded({required this.products});
  @override
  List<Object> get props => [products];
}

final class ProductRefreshing extends ProductState {
  final List<ProductModel> products;

  const ProductRefreshing({required this.products});
  @override
  List<Object> get props => [products];
}

final class ProductError extends ProductState {
  final String errorMessage;

  const ProductError({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
