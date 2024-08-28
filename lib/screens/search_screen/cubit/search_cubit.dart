import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_app/models/search.dart';
import 'package:flutter_music_app/services/api_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> search({required String query}) async {
    emit(SearchLoadingState());
    try {
      Search? searchResult = await ApiService.search(query: query);
      emit(SearchResultState(searchResult: searchResult));
    } catch (e) {
      emit(SearchResultState());
    }
  }
}
