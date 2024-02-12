import 'package:basic_bloc_dart/src/bloc_event.dart';

class GeneralBlocData extends BlocEvent<Map<String, dynamic>> {
  const GeneralBlocData({required super.dataId, required super.emitter, required super.data, required super.emissionTime});
  GeneralBlocData.emitNow({required super.dataId, required super.emitter, required super.data}) : super.withEmissionTimeNow();
  GeneralBlocData.simpleEmitNow(super.data) : super.simple();
}