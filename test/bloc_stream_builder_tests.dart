import 'package:basic_bloc_dart/src/bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_widgets.dart';

void main() {
  testWidgets('Test BlocBuilder',
          (WidgetTester tester) async {

        //Arrange - Pump MyApp() widget to tester
        await tester.pumpWidget(const EmitterNestedWidgets());

        //Act - Find button by type
        var fab = find.byType(BlocBuilder<String>);

        //Assert - Check that button widget is present
        expect(fab, findsExactly(2));

      });

  testWidgets('Test BlocBuilderGetIT',
          (WidgetTester tester) async {

        //Arrange - Pump MyApp() widget to tester
        await tester.pumpWidget(const EmitterNestedWidgetsGetIt());

        // //Act - Find button by type
        // var fab = find.byType(BlocBuilder<String>);
        //
        // //Assert - Check that button widget is present
        // expect(fab, findsExactly(2));

      });
}