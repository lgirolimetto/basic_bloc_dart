
import 'package:basic_functional_dart/basic_functional_dart.dart';

sealed class BaseBlocData<T> {
  final String emitter;
  final DateTime emissionTime;

  BaseBlocData({this.emitter = '', DateTime? emissionTime}) : emissionTime = emissionTime ?? DateTime.now();
}

class BlocLoading<T> extends BaseBlocData<T> {
  BlocLoading({super.emitter, super.emissionTime});
}

class BlocData<T> extends BaseBlocData<T> {
  final String id;
  final T value;
  BlocData(this.value, {this.id = '', super.emitter, super.emissionTime});
}

class BlocError<T> extends BaseBlocData<T> {
  final Option<Object> error;
  final Option<StackTrace> stackTrace;
  BlocError(this.error, this.stackTrace, {super.emitter, super.emissionTime});
}

class NoData<T> extends BaseBlocData<T> {
  NoData({super.emitter, super.emissionTime});
}