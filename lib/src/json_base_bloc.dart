
import 'package:basic_bloc_dart/src/base_bloc.dart';

class JsonBaseBloc extends BaseBloc<Map<String, dynamic>> {
  JsonBaseBloc({super.data, super.dataId, required super.emitterId});
}