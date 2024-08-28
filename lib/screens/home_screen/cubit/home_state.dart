part of 'home_cubit.dart';

sealed class HomeState {}

class InitialState extends HomeState {}

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
