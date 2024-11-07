import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';
import 'package:get_it/get_it.dart';

extension NullableOption<T> on Option<T> {
  T? toNullable() {
    return fold(
            () => null,
            (some) => some
    );
  }
}

extension BaseBlocManagement<T> on BaseBloc<T> {
  BaseBloc<T> push() {
    return GetIt.instance.registerSingleton(this, instanceName: emitterId, dispose: (b) => b.dispose());
  }

  void pop() {
    GetIt.instance.unregister(instance: this, instanceName: emitterId);
  }
}

extension BaseBlocManagementStrings on String {
  bool isBlocRegistered<T>() {
    return GetIt.instance.isRegistered<BaseBloc<T>>(instanceName: this);
  }

  BaseBloc<T> getBloc<T>() {
    return GetIt.instance.get<BaseBloc<T>>(instanceName: this);
  }
}