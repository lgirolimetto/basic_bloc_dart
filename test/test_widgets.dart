import 'package:basic_bloc_dart/src/bloc_builder.dart';
import 'package:flutter/material.dart';

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