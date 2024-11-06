import 'package:basic_bloc_dart/src/bloc_builder.dart';
import 'package:flutter/material.dart';

class EmitterAStringWidget extends StatelessWidget {
  const EmitterAStringWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocStreamBuilder<String>(
      emitterId: 'Emitter A',
      child: SizedBox(),
    );
  }

}

class EmitterAIntWidget extends StatelessWidget {
  const EmitterAIntWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const BlocStreamBuilder<int>(
      emitterId: 'Emitter A',
      child: SizedBox(),
    );
  }
}

class EmitterNestedWidgets extends StatelessWidget {
  const EmitterNestedWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocStreamBuilder<String>(
        emitterId: 'Emitter A',
        child: Container(
          color: Colors.blue,
          child: const Column(
            children: [
              BlocStreamBuilder<int>(
                emitterId: 'Emitter A',
                child: Divider()
              ),
              BlocStreamBuilder<String>(
                  emitterId: 'Emitter A',
                  child: Divider()
              ),
              BlocStreamBuilder<String>(
                  emitterId: 'Emitter B',
                  child: Divider()
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmitterNestedWidgetsGetIt extends StatelessWidget {
  const EmitterNestedWidgetsGetIt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocStreamBuilderGetIt<String>(
        emitterId: 'Emitter A',
        child: Container(
          color: Colors.blue,
          child: const Column(
            children: [
              BlocStreamBuilderGetIt<int>(
                  emitterId: 'Emitter A',
                  child: Divider()
              ),
              BlocStreamBuilderGetIt<String>(
                  emitterId: 'Emitter A',
                  child: Divider()
              ),
              BlocStreamBuilderGetIt<String>(
                  emitterId: 'Emitter B',
                  child: Divider()
              ),
            ],
          ),
        ),
      ),
    );
  }
}