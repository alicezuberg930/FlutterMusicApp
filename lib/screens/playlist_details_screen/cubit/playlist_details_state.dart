part of 'playlist_details_cubit.dart';

class PlaylistDetailsState {}

class PlaylistDetailsInitial extends PlaylistDetailsState {}

class PlaylistDetailsLoadingState extends PlaylistDetailsState {}

class GetPlaylistDetailsState extends PlaylistDetailsState {
  Playlist? playlist;
  String? totalTime;

  GetPlaylistDetailsState({this.playlist, this.totalTime});
}
