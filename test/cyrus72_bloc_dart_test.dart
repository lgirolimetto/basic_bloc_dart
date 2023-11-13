import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:cyrus72_bloc_dart/cyrus72_bloc_dart.dart';
import 'package:cyrus72_bloc_dart/src/bloc_event.dart';

void main() {
  test('TEST BASE BLOC INIT', () async {
    // ARRANGE
    final loadingBlocEvent = BlocEvent.withEmissionTimeNow(dataId: '1', emitter: 'test emitter', data: const BlocLoading<String>());
    var completer = Completer();
    // ACT
    var bloc = BaseBloc(initialEvent: loadingBlocEvent);
    // ASSERT
    var subscription = bloc.dataStream.listen((event) {
      expect(event.dataId, '1');
      expect(event.emitter, 'test emitter');
      expect(event.data.runtimeType.toString(), 'BlocLoading<String>');
      completer.complete();
    });

    await completer.future;
    subscription.cancel();
    bloc.dispose();
  });

  test('TEST FAILING BLOC REQUEST', () async {
    // ARRANGE
    Future<String> failingRequest() {
      return Future(() => throw UnimplementedError());
    }

    Future<String> stringRequest() {
      return Future(() => 'Hello');
    }

    var bloc = BaseBloc<String>();
    var completer = Completer();
    // ACT
    bloc.request(request: failingRequest, initialData: const BlocLoading<String>());

    var subscription = bloc.dataStream.listen((event) {
      var _ = switch(event) {
        null => null,
        BlocEvent<String> _ => switch(event.data) {
          BlocError<String> e => [expect(e.runtimeType.toString(), 'BlocError<String>'), completer.complete()],
          _ => expect(event.data.runtimeType.toString(), 'BlocLoading<String>')
        },
      };
    });

    await completer.future;
    subscription.cancel();
    bloc.dispose();
  });

  test('TEST SUCCESSFULLY BLOC REQUEST', () async {
    // ARRANGE
    Future<String> stringRequest() {
      return Future(() => 'Hello');
    }

    var bloc = BaseBloc<String>();
    var completer = Completer();
    // ACT
    bloc.request(request: stringRequest, initialData: const BlocLoading<String>());

    var subscription = bloc.dataStream.listen((event) {
      var _ = switch(event) {
        null => null,
        BlocEvent<String> _ => switch(event.data) {
          BlocData<String> bd => [expect(bd.data, 'Hello'), completer.complete()],
          BlocLoading<String> _ => null,
          _ => fail('Unexpected event data')
        },
      };
    });

    await completer.future;
    subscription.cancel();
    bloc.dispose();
  });
}
