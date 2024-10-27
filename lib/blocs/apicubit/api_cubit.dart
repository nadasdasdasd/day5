import 'package:day4/helper/network_service.dart';
import 'package:day4/models/dictionary_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

// State
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiSuccess extends ApiState {
  final DictionaryResponse response;

  ApiSuccess(this.response);
}

class ApiFailure extends ApiState {
  final String error;

  ApiFailure(this.error);
}

// Cubit
// class ApiCubit extends Cubit<ApiState> {
//   final NetworkService networkService;

//   ApiCubit(this.networkService) : super(ApiInitial());

//   void fetchData(String endpoint,
//       {Map<String, dynamic>? queryParameters}) async {
//     emit(ApiLoading());
//     try {
//       final response =
//           await networkService.get(endpoint, queryParameters: queryParameters);
//       emit(ApiSuccess(response));
//     } catch (e) {
//       emit(ApiFailure(e.toString()));
//     }
//   }
// }

class ApiCubit extends Cubit<ApiState> {
  final NetworkService _networkService;

  ApiCubit(this._networkService) : super(ApiInitial());

  Future<void> fetchData(String endpoint) async {
    emit(ApiLoading());
    try {
      final response = await _networkService.get(endpoint);
      print('response is hi$response');

      // Parse the response to DictionaryResponse
      final dictionaryResponse = DictionaryResponse.fromJson(response.data[0]);

      emit(ApiSuccess(
          dictionaryResponse)); // Emit success state with the response
    } on DioError catch (e) {
      // Handle DioError specifically for more granular error handling
      print('error woyy $e');
      emit(ApiFailure(e.message!));
    } catch (e) {
      // Catch any other errors
      emit(ApiFailure('Something went wrong: $e'));
    }
  }
}
