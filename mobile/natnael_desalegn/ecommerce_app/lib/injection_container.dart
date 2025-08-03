import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/product_mgt/data/datasources/product_mgt_local_data_source.dart';
import 'features/product_mgt/data/datasources/product_mgt_remote_data_source.dart';
import 'features/product_mgt/data/repositories/product_mgt_repository_impl.dart';
import 'features/product_mgt/domain/repositories/product_mgt_repository.dart';
import 'features/product_mgt/domain/usecases/delete_product.dart';
import 'features/product_mgt/domain/usecases/get_all_products.dart';
import 'features/product_mgt/domain/usecases/get_product.dart';
import 'features/product_mgt/domain/usecases/insert_product.dart';
import 'features/product_mgt/domain/usecases/update_product.dart';
import 'features/product_mgt/presentation/bloc/product_mgt_bloc.dart';
import 'utils/input_converter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - ProductMgt
  sl.registerFactory(
    () => ProductMgtBloc(
      insertProduct: sl(),
      deleteProduct: sl(),
      updateProduct: sl(),
      getAllProducts: sl(),
      getProduct: sl(),
      inputConverter: sl(),
    ),
  );
  //usecases
  sl.registerLazySingleton(() => InsertProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // repository
  sl.registerLazySingleton<ProductMgtRepository>(
    () => ProductMgtRepositoryImpl(
      productMgtRemoteDataSouce: sl(),
      productMgtLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //data sources
  sl.registerLazySingleton<ProductMgtLocalDataSource>(() => ProductMgtLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<ProductMgtRemoteDataSource>(() => ProductMgtRemoteDataSourceImpl(client: sl()));


  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());
}
