import 'dart:async';

import 'package:basic_bloc_dart/src/bloc_data.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:basic_bloc_dart/src/i_base_bloc.dart';

typedef BlocRequest<T> = Future<T> Function();
typedef ValidationBlocRequest<T> = Future<Validation<T>> Function();

class BaseBloc<T> implements IBaseBloc<T> {
  StreamSubscription? _request;

  final String emitterId;
  final _dataSubject = BehaviorSubject<BaseBlocData<T>>();

  @override
  Stream<BaseBlocData<T>> get dataStream => _dataSubject.stream;

  BaseBloc({T? data, String dataId = '', required this.emitterId}) {
    emitBlocData(data != null
                  ? BlocData(data, id: dataId, emitter: emitterId)
                  : NoData()
    );
  }

  BaseBloc.withLoading({this.emitterId = ''}) {
    emitBlocData(BlocLoading(emitter: emitterId));
  }

  @override
  Option<BlocData<T>> get lastEmittedData {
    if(_dataSubject.hasValue) {
      return switch(_dataSubject.value) {
        BlocData<T> bd => Some(bd),
        _ => None<BlocData<T>>()
      };
    }
    return None<BlocData<T>>();
  }


  @override
  void updateData(T data, {String? dataId}) {
    lastEmittedData.fold(
            () => emitBlocData(BlocData(data), dataId: dataId),
            (some) {
          if(some.value != data) {
            emitBlocData(BlocData(data));
          }
        });
  }

  @override
  void emitData(T data, {String? dataId}) {
    emitBlocData(BlocData(data));
  }

  @override
  void emitBlocData(BaseBlocData<T> data, {String? dataId}) {
    _dataSubject.add(data);
  }

  @override
  void emitEmptyData({String? dataId}) {
    emitBlocData(NoData<T>());
  }

  @override
  void emitLoading() {
    emitBlocData(BlocLoading<T>());
  }

  @override
  void emitError({Object? error, StackTrace? trace}) {
    emitBlocData(
        BlocError<T>(
                      error == null
                          ? None<Object>()
                          : Some(error),
                      trace == null
                          ? None<StackTrace>()
                          : Some(trace),
                      ),
        );
  }

  @override
  void request({required BlocRequest<T> request, BaseBlocData<T>? initialData}) {
    if(initialData case final data?) {
      emitBlocData(data);
    }

    _request?.cancel();
    _request = request()
        .asStream()
        .handleError((err, stackTrace) => emitError(error: err, trace: stackTrace))
        .listen((val) => switch(val) {
              null => emitEmptyData(),
              List l => l.isEmpty ? emitEmptyData() : emitBlocData(BlocData(l as T)),
              T data => emitBlocData(BlocData(data)),
            });
  }

  @override
  void validatedRequest({required ValidationBlocRequest<T> request, BaseBlocData<T>? initialData}) {
    if(initialData case final data?) {
      emitBlocData(data);
    }

    _request?.cancel();
    _request = request()
            .asStream()
            .listen((val) =>
              val.fold(
                (failure) => emitError(error: failure),
                (val) => switch(val) {
                  null => emitEmptyData(),
                  Unit _ => emitEmptyData(),
                  List l => l.isEmpty ? emitEmptyData() : emitBlocData(BlocData(l as T)),
                  T data => emitBlocData(BlocData(data)),
                }
            ));
  }

  @override
  void dispose() {
    _request?.cancel();
    _dataSubject.close();
  }
}