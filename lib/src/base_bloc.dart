import 'package:cyrus72_bloc_dart/src/bloc_data.dart';
import 'package:cyrus72_bloc_dart/src/bloc_event.dart';
import 'package:cyrus72_functional_dart/cyrus72_functional_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cyrus72_bloc_dart/src/i_base_bloc.dart';

typedef BlocRequest<T> = Future<T> Function();

class BaseBloc<T> implements IBaseBloc<T> {
  final _dataSubject = BehaviorSubject<BlocEvent<T>>();
  @override
  Stream<BlocEvent<T>> get dataStream => _dataSubject.stream;

  BaseBloc({BlocEvent<T>? initialEvent}) {
    if(initialEvent case final ev?) {
      add(ev);
    }
  }

  @override
  Option<BlocEvent<T>> get lastEmittedEvent => _dataSubject.hasValue ? Some(_dataSubject.value) : None<BlocEvent<T>>();

  @override
  Option<BlocData<T>> get lastEmittedData {
    if(_dataSubject.hasValue) {
      return switch(_dataSubject.value.data) {
        BlocData<T> bd => Some(bd),
        _ => None<BlocData<T>>()
      };
    }
    return None<BlocData<T>>();
  }

  @override
  void add(BlocEvent<T> event) {
    _dataSubject.add(event);
  }

  @override
  void emitData({required BaseBlocData<T> data, String? emitter}) {
    final ev = BlocEvent.withEmissionTimeNow(dataId: '', emitter: emitter ?? '', data: data);
    _dataSubject.add(ev);
  }

  @override
  void emitEmptyData({String? emitter}) {
    emitData(data: NoData<T>(), emitter: emitter);
  }

  @override
  void emitLoading({String? emitter}) {
    emitData(data: BlocLoading<T>(), emitter: emitter);
  }

  @override
  void emitError({Object? error, StackTrace? trace, String? emitter}) {
    emitData(
        data: BlocError<T>(
                      error == null
                          ? None<Object>()
                          : Some(error),
                      trace == null
                          ? None<StackTrace>()
                          : Some(trace),
                      ),
        emitter: emitter);
  }

  @override
  Future<void> request({required BlocRequest<T> request, BaseBlocData<T>? initialData, String? emitter}) {
    if(initialData case final data?) {
      emitData(data: data, emitter: emitter);
    }

    return request()
            .then((value) => switch(value) {
              null => emitEmptyData(emitter: emitter),
              List l => l.isEmpty ? emitEmptyData(emitter: emitter) : emitData(data: BlocData(l as T), emitter: emitter),
              T data => emitData(data: BlocData(data), emitter: emitter),
            })
            .onError((error, stackTrace)
                => emitError(error: error, trace: stackTrace, emitter: emitter))
            .catchError((e) {
              if(e is Error) {
                emitError(error: e, trace: e.stackTrace, emitter: emitter);
              }
              else if(e is Exception) {
                emitError(error: e, emitter: emitter);
              }
            });

  }

  @override
  void dispose() {
    _dataSubject.close();
  }
}