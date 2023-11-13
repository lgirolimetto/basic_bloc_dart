
import 'package:cyrus72_functional_dart/cyrus72_functional_dart.dart';

sealed class BaseBlocData<T> {
  const BaseBlocData();
}

class BlocLoading<T> extends BaseBlocData<T> {
  const BlocLoading();
}

class BlocData<T> extends BaseBlocData<T> {
  final T data;
  const BlocData(this.data);
}

class BlocError<T> extends BaseBlocData<T> {
  final Option<Object> error;
  final Option<StackTrace> stackTrace;
  const BlocError(this.error, this.stackTrace);
}

class NoData<T> extends BaseBlocData<T> {
  const NoData();
}