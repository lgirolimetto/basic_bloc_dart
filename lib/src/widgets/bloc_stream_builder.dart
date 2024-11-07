import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:flutter/material.dart';

class BlocStreamBuilder<T> extends StatelessWidget {
  final BaseBloc<T> bloc;
  final Widget? loadingWidget;
  final Widget? noDataWidget;
  final Widget Function(BuildContext context, T data) buildChildWidget;
  final Widget Function({required BuildContext context, Object? error, StackTrace? stackTrace})? buildErrorWidget;

  const BlocStreamBuilder({
    super.key,
    required this.bloc,
    required this.buildChildWidget,
    this.buildErrorWidget,
    this.loadingWidget,
    this.noDataWidget
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.dataStream,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return switch(snapshot.data) {
                BlocData<T> data => buildChildWidget(context, data.value),
                BlocLoading<T> _ => loadingWidget ?? const SizedBox(),
                BlocError<T> be => buildErrorWidget?.call(
                                    context: context,
                                    error: be.error.toNullable(),
                                    stackTrace: be.stackTrace.toNullable()) ?? const SizedBox(),
                _ => noDataWidget ?? const SizedBox(),
            };
          }
          else if(snapshot.hasError) {
            return buildErrorWidget?.call(
                    context: context,
                    error: snapshot.error,
                    stackTrace: snapshot.stackTrace) ?? const SizedBox();
          }
          else {
            return loadingWidget ?? const SizedBox();
          }
        }
    );
  }
}