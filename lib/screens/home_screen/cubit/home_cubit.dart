import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/models/section.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());

  Future<void> getHome() async {
    emit(IsLoadingState());
    try {
      List<Song> homeSongs = await ApiService.getHome();
      List<Section> top100s = await ApiService.getTop100();
      emit(GetHomeState(homeSongs: homeSongs, top100s: top100s));
    } catch (e) {
      emit(GetHomeState(homeSongs: [], top100s: []));
    }
  }
}
