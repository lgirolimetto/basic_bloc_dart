import 'package:cyrus72_bloc_dart/src/base_bloc.dart';
import 'package:cyrus72_bloc_dart/src/bloc_data.dart';
import 'package:cyrus72_bloc_dart/src/bloc_event.dart';
import 'package:cyrus72_functional_dart/cyrus72_functional_dart.dart';

abstract class IBaseBloc<T> {
  Stream<BlocEvent<T>> get dataStream;

  Option<BlocEvent<T>> get lastEmittedEvent;
  Option<BlocData<T>> get lastEmittedData;
  void add(BlocEvent<T> event);
  void emitData({required BaseBlocData<T> data, String? emitter});
  void emitEmptyData({String? emitter});
  void emitLoading({String? emitter});
  void emitError({Object? error, StackTrace? trace, String? emitter});
  void request({required BlocRequest<T> request, BaseBlocData<T>? initialData = const BlocLoading(), String? emitter});
  void dispose();
}