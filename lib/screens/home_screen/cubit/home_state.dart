part of 'home_cubit.dart';

sealed class HomeState {}

class InitialState extends HomeState {}

// class GetHomeState extends HomeState {
//   final List<Song> homeSongs;

//   GetHomeState(this.homeSongs);
// }

// class GetTop100State extends HomeState {
//   final List<Section> top100s;

//   GetTop100State(this.top100s);
// }

class IsLoadingState extends HomeState {}

class GetHomeState extends HomeState {
  final List<Song> homeSongs;
  final List<Section> top100s;

  GetHomeState({
    this.homeSongs = const [],
    this.top100s = const [],
  });

  GetHomeState copyWith({
    List<Song>? homeSongs,
    List<Section>? top100s,
  }) {
    return GetHomeState(
      homeSongs: homeSongs ?? this.homeSongs,
      top100s: top100s ?? this.top100s,
    );
  }
}
