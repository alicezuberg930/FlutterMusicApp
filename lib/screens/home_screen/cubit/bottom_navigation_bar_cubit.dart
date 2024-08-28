import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavBarStates> {
  BottomNavigationBarCubit() : super(BottomNavBarStates(index: 0));

  setBottomNavigationIndexState(int index) {
    emit(BottomNavBarStates(index: index));
  }
}
