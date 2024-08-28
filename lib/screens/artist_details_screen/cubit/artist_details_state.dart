part of 'artist_details_cubit.dart';

class ArtistDetailsCubitState {}

class ArtistDetailsInitalState extends ArtistDetailsCubitState {}

class ArtistDetailsLoadingState extends ArtistDetailsCubitState {}

class GetArtistDetailsState extends ArtistDetailsInitalState {
  Artist? artist;

  GetArtistDetailsState({this.artist});
}
