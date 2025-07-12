import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeCubit<T extends dynamic> on Cubit<T> {
  @override
  void emit(T state) {
    if (isClosed) {
      return;
    }
    super.emit(state);
  }
}
