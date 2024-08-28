part of 'search_cubit.dart';

class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchResultState extends SearchState {
  Search? searchResult;

  SearchResultState({this.searchResult});
}
