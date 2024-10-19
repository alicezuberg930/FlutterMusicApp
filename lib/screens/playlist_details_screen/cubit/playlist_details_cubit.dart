import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/models/playlist.dart';
import 'package:flutter_music_app/models/song.dart';
import 'package:flutter_music_app/services/api_service.dart';

part 'playlist_details_state.dart';

class PlaylistDetailsCubit extends Cubit<PlaylistDetailsState> {
  PlaylistDetailsCubit() : super(PlaylistDetailsInitial());

  Future<void> getPlaylistDetails({required String encodeId}) async {
    emit(PlaylistDetailsLoadingState());
    try {
      Playlist? playlist = await ApiService.getPlaylist(encodeId: encodeId);
      String totalTime = "";
      if (playlist != null) {
        int seconds = 0;
        for (Song song in playlist.songs) {
          seconds += song.duration!;
        }
        totalTime = "${(seconds / 3600).floor()} hours ${(seconds % 60).floor()} minutes";
      }
      emit(GetPlaylistDetailsState(playlist: playlist, totalTime: totalTime));
    } catch (e) {
      emit(GetPlaylistDetailsState(playlist: null, totalTime: null));
    }
  }
}
