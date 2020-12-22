import 'package:flutter/material.dart';
import 'package:the_country_number_widgets/the_country_number_widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TheCountryNumberInput(
                TheCountryNumber().parseNumber(iso2Code: "IN"),
                onChanged: (tn){
                  //even you can check whether its correctly parsed, not needed but library is not even 1.0
                  if(tn.isNotANumber()){
                    return;
                  }
                  if(tn.isValidLength){
                    //do something
                  }
                },
                //custom validation
                customValidator: (tn){
                  final enteredNumber = tn.number;
                  //do something
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
