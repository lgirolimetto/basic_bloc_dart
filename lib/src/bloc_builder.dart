import 'package:basic_bloc_dart/basic_bloc_dart.dart';
import 'package:basic_functional_dart/basic_functional_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class BlocBuilder<T> extends InheritedWidget {
  final BaseBloc<T> bloc;
  const BlocBuilder({
    super.key,
    required this.bloc,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class _PlaceholderBuilder extends InheritedWidget {
  const _PlaceholderBuilder({
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}

class BlocStreamBuilder<T> extends StatefulWidget {
  final String emitterId;
  final Widget child;
  const BlocStreamBuilder({super.key, required this.emitterId, required this.child});

  @override
  State<BlocStreamBuilder<T>> createState() => _BlocStreamBuilderState<T>();
}

class _BlocStreamBuilderState<T> extends State<BlocStreamBuilder<T>> {
  BaseBloc<T>? bloc;
  InheritedElement? ie;

  @override
  void didChangeDependencies() {
    ie = context.getElementForInheritedWidgetOfExactType<BlocBuilder<T>>();
    if(ie != null) {
      var b = (ie!.widget as BlocBuilder<T>).bloc;
      if(b.emitterId == widget.emitterId) {
        bloc = b;
        debugPrint('[BlocBuilder] -> Using an already existing bloc with name: ${b.emitterId} and type: $T');
      }
      else {
        while((ie = ie!.getElementForInheritedWidgetOfExactType<BlocBuilder<T>>()) != null) {
          var b = (ie!.widget as BlocBuilder<T>).bloc;
          if(b.emitterId == widget.emitterId) {
            bloc = b;
            debugPrint('[BlocBuilder] -> Using an already existing bloc with name: ${b.emitterId} and type: $T');
            break;
          }

          ie = ie!.getElementForInheritedWidgetOfExactType<_PlaceholderBuilder>();
        }
      }
    }

    if(bloc == null) {
      bloc = BaseBloc<T>(emitterId: widget.emitterId);
      debugPrint('[BlocBuilder] -> Create a new Bloc with name: ${bloc!.emitterId} of type: $T');
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // If we don't rely on an Ancestor Bloc Builder, we build a new one
    if(ie == null) {
      return _PlaceholderBuilder(
        child: BlocBuilder(bloc: bloc!, child: widget.child)
      );
    }

    return widget.child;
  }

  @override
  void dispose() {
    // If we don't rely on an Ancestor Bloc Builder, dispose the bloc!
    if(ie == null) {
      debugPrint('[BlocBuilder] -> Disposing bloc with name: ${bloc!.emitterId} and type: $T');
      bloc?.dispose();
    }
    super.dispose();
  }
}

class BlocStreamBuilderGetIt<T> extends StatefulWidget {
  final String emitterId;
  final Widget child;
  final Future<Validation<T>> Function()? getData;
  const BlocStreamBuilderGetIt({super.key, required this.emitterId, required this.child, this.getData});

  @override
  State<BlocStreamBuilderGetIt<T>> createState() => _BlocStreamBuilderStateGetIt<T>();
}

class _BlocStreamBuilderStateGetIt<T> extends State<BlocStreamBuilderGetIt<T>> {
  late final bool isAlreadyRegistered;
  late final BaseBloc<T> bloc;

  @override
  void initState() {
    isAlreadyRegistered = GetIt.instance.isRegistered<BaseBloc<T>>(instanceName: widget.emitterId);
    if(isAlreadyRegistered) {
      bloc = GetIt.instance.get<BaseBloc<T>>(instanceName: widget.emitterId);
    }
    else {
      bloc = GetIt.instance.registerSingleton(BaseBloc(emitterId: widget.emitterId), instanceName: widget.emitterId, dispose: (b) => b.dispose());
    }

    if(widget.getData != null) {
      bloc.requestWithValidation(request: widget.getData!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    if(!isAlreadyRegistered) {
      GetIt.instance.unregister(instance: bloc, instanceName: widget.emitterId);
    }

    super.dispose();
  }
}

