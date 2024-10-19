import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/models/song.dart';

part 'playlist_search_state.dart';

class PlaylistSearchCubit extends Cubit<PlaylistSearchState> {
  PlaylistSearchCubit(songs) : super(SearchPlaylistState(songs: songs)) {
    currentSongs = songs;
  }

  List<Song>? currentSongs;

  searchPlaylist({required String query}) {
    List<Song> songs = currentSongs!
        .where((song) => song.title!.toLowerCase().contains(query.toLowerCase()) || song.artistsNames!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(SearchPlaylistState(songs: songs));
  }
}
