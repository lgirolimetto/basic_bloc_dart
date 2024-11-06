import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';

extension NullableOption<T> on Option<T> {
  T? toNullable() {
    return fold(
            () => null,
            (some) => some
    );
  }
}

class BlocService<T> {
  final BaseBloc<T> bloc;

  const BlocService(this.bloc);

  T? getNullableLastEmittedData() {
    return bloc.lastEmittedData.toNullable()?.value;
  }
}