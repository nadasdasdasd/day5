import 'package:day4/helper/network_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

// State
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiSuccess extends ApiState {
  final Response response;

  ApiSuccess(this.response);
}

class ApiFailure extends ApiState {
  final String error;

  ApiFailure(this.error);
}

// Cubit
class ApiCubit extends Cubit<ApiState> {
  final NetworkService networkService;

  ApiCubit(this.networkService) : super(ApiInitial());

  void fetchData(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    emit(ApiLoading());
    try {
      final response =
          await networkService.get(endpoint, queryParameters: queryParameters);
      emit(ApiSuccess(response));
    } catch (e) {
      emit(ApiFailure(e.toString()));
    }
  }
}
