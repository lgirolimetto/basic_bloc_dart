import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';
import 'package:flutter/cupertino.dart';


class BlocStreamBuilder<T> extends StatefulWidget {
  final String emitterId;
  final Widget child;
  final Future<Validation<T>> Function()? getData;
  const BlocStreamBuilder({super.key, required this.emitterId, required this.child, this.getData});

  @override
  State<BlocStreamBuilder<T>> createState() => _BlocStreamBuilderStateGetIt<T>();
}

class _BlocStreamBuilderStateGetIt<T> extends State<BlocStreamBuilder<T>> {
  late final bool isRegistered;
  late final BaseBloc<T> bloc;

  @override
  void initState() {
    isRegistered = widget.emitterId.isBlocRegistered<T>();
    if(isRegistered) {
      bloc = widget.emitterId.getBloc<T>();
      debugPrint('[BlocBuilder] -> Using an already existing bloc with name: ${bloc.emitterId} and type: $T');
    }
    else {
      bloc = BaseBloc<T>(emitterId: widget.emitterId).push();
      debugPrint('[BlocBuilder] -> Create a new Bloc with name: ${bloc.emitterId} of type: $T');
    }

    if(widget.getData != null) {
      bloc.validatedRequest(request: widget.getData!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    if(!isRegistered) {
      bloc.pop();
      debugPrint('[BlocBuilder] -> Disposing bloc with name: ${bloc.emitterId} and type: $T');
    }

    super.dispose();
  }
}

