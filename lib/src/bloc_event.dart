import 'package:basic_bloc_dart/basic_bloc_dart.dart';

class BlocEvent<T> {
  final BaseBlocData<T> data;
  final String emitter;
  final DateTime emissionTime;
  final String dataId;

  const BlocEvent({required this.dataId, required this.emitter, required this.data, required this.emissionTime});

  /// Create a Bloc event with emission time equals to DateTime.now()
  BlocEvent.withEmissionTimeNow({required this.dataId, required this.emitter, required this.data}) : emissionTime = DateTime.now();
  /// Create a Bloc event with emission time equals to DateTime.now() and other fields initialized to an empty string
  BlocEvent.simple(this.data) : emissionTime = DateTime.now(), emitter = '', dataId = '';
}