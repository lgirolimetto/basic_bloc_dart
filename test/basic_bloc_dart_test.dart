import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('TEST BASE BLOC INIT', () async {
    // ARRANGE
    var completer = Completer();
    // ACT
    var bloc = BaseBloc(data: 'Test Data', dataId: '1', emitterId: 'test emitter');
    // ASSERT
    var subscription = bloc.dataStream.listen((data) {
      switch(data) {
        case BlocData<String> data:
          expect(data.id, '1');
          expect(data.emitter, 'test emitter');
          expect(data.value, 'Test Data');
          break;
        default:
          fail('BlocData expected');
      }

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

    var bloc = BaseBloc<String>(emitterId: 'emitter');
    var completer = Completer();
    // ACT
    bloc.request(request: failingRequest, initialData: BlocLoading<String>());

    var subscription = bloc.dataStream.listen((data) {
      var _ =  switch(data) {
          BlocError<String> e => [expect(e.runtimeType.toString(), 'BlocError<String>'), completer.complete()],
          _ => expect(data.runtimeType.toString(), 'BlocLoading<String>')
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

    var bloc = BaseBloc<String>(emitterId: 'emitter');
    var completer = Completer();
    // ACT
    bloc.request(request: stringRequest, initialData: BlocLoading<String>());

    var subscription = bloc.dataStream.listen((data) {
      var _ = switch(data) {
          BlocData<String> bd => [expect(bd.value, 'Hello'), completer.complete()],
          BlocLoading<String> _ => null,
          _ => fail('Unexpected event data')
      };
    });

    await completer.future;
    subscription.cancel();
    bloc.dispose();
  });
}
