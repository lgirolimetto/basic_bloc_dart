import 'package:basic_bloc_dart/src/base_bloc.dart';
import 'package:basic_bloc_dart/src/bloc_data.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';

abstract class IBaseBloc<T> {
  Stream<BaseBlocData<T>> get dataStream;

  Option<BlocData<T>> get lastEmittedData;
  void emitBlocData(BaseBlocData<T> data, {String? dataId});
  void emitData(T data, {String? dataId});
  void updateData(T data, {String? dataId});
  void emitEmptyData({String? dataId});
  void emitLoading();
  void emitError({Object? error, StackTrace? trace});
  void request({required BlocRequest<T> request, BaseBlocData<T>? initialData});
  void requestWithValidation({required ValidationBlocRequest<T> request, BaseBlocData<T>? initialData});
  void dispose();
}