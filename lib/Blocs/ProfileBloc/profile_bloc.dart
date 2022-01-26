import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Network/network_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

NetworkService _apiService = NetworkService();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>(
      (event, emit) async {
        if (event is GetUserProfileEvent) {
          emit.call(ProfileLoading());
          final ApiResponseModel _profRes = await _apiService.getUserProfile();

          if (_profRes.statusCode == 200) {
            final _res = _profRes.responseJson!.data;
            print(_res['name']);
            emit.call(
              ProfileLoaded(
                name: _res['name'].toString(),
                email: _res['email'].toString(),
              ),
            );
          } else {
            emit.call(ProfileLoaded(name: 'User', email: ''));
          }
        }
      },
    );
  }
}
