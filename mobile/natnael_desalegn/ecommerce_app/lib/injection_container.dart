import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'core/common/bloc/button/button_state_cubit.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/authentication/data/datasources/auth_api_service.dart';
import 'features/authentication/data/datasources/auth_local_service.dart';
import 'features/authentication/data/repositories/authentication_repository_impl.dart';
import 'features/authentication/domain/repositories/authentication_repository.dart';
import 'features/authentication/domain/usecases/get_user_usecase.dart';
import 'features/authentication/domain/usecases/is_loggedin_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/signin_usecase.dart';
import 'features/authentication/domain/usecases/signup_usecase.dart';
import 'features/authentication/presentation/bloc/user_display_cubit.dart';
import 'features/chat/data/datasources/chat_api_service.dart';
import 'features/chat/data/datasources/chat_socket_service.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/create_chat_with_user_usecase.dart';
import 'features/chat/domain/usecases/get_all_users_usecase.dart';
import 'features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'features/chat/domain/usecases/get_my_chats_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
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




  //Features - authentication
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<AuthApiService>(() => AuthApiServiceImpl());
  sl.registerLazySingleton<AuthenticationRepository>(() =>AuthenticationRepositoryImpl());
  sl.registerLazySingleton<AuthLocalService>(()=> AuthLocalServiceImpl());

  //usecases
  sl.registerLazySingleton(() => SignupUsecase());
  sl.registerLazySingleton(() => IsLoggedinUsecase());
  sl.registerLazySingleton(() => GetUserUsecase());
  sl.registerLazySingleton(() => LogoutUsecase());
  sl.registerLazySingleton(() => SigninUsecase());

  //bloc
  sl.registerFactory(() => ButtonStateCubit());
  sl.registerFactory(() => UserDisplayCubit());



  //Features Chat

  sl.registerLazySingleton<ChatSocketService>(() => ChatSocketServiceImpl());
    sl.registerLazySingleton<ChatApiService>(() => ChatApiServiceImpl());

  // Repo
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(api: sl(), socket: sl()));

  // Usecases
  sl.registerLazySingleton(() => CreateChatWithUserUsecase(sl()));
  sl.registerLazySingleton(() => GetMyChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetChatMessagesUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUsecase(sl()));

}
