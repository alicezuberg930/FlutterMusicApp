import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/models/artist.dart';
import 'package:flutter_music_app/services/api_service.dart';

part 'artist_details_state.dart';

class ArtistDetailsCubit extends Cubit<ArtistDetailsCubitState> {
  ArtistDetailsCubit() : super(ArtistDetailsInitalState());

  Future<void> getArtistDetails({required String name}) async {
    emit(ArtistDetailsLoadingState());
    try {
      Artist? artist = await ApiService.getArtist(name: name);
      emit(GetArtistDetailsState(artist: artist));
    } catch (e) {
      emit(GetArtistDetailsState(artist: null));
    }
  }
}
