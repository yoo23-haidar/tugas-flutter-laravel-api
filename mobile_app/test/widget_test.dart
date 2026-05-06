import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:mobile_app/main.dart';

void main() { 
  testWidgets('App should start on Login page', (WidgetTester tester) async { 
    // Build our app and trigger a frame. 
    await tester.pumpWidget(MyApp()); 

    // Verify that the Login page is displayed
    expect(find.text('Login'), findsWidgets); 
    expect(find.text('Register'), findsWidgets); 
  }); 
}
