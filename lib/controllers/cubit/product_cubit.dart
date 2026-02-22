import 'package:block_app/repos/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:block_app/models/product_model.dart';
import 'package:equatable/equatable.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductLoading());
  final ProductRepo productRepo = ProductRepo();

  Future<void> getProductData() async {
    emit(ProductLoading());
    await _loadProducts();
  }

  Future<void> refreshProducts() async {
    final currentState = state;

    if (currentState is ProductRefreshing) {
      return;
    }

    if (currentState is ProductLoaded) {
      emit(ProductRefreshing(products: currentState.products));
      await _loadProducts();
      return;
    }

    await getProductData();
  }

  Future<void> _loadProducts() async {
    try {
      final List<ProductModel> products = await productRepo.getData();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(errorMessage: e.toString()));
    }
  }
}
