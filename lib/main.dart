//
//   BEACH CLOCK
//
// Made by Tim Davidson Jan. 20, 2020
//

import 'package:flutter/material.dart';
import 'beach_clock.dart';
import 'utility.dart';

void main() => runApp(App());

/// MaterialApp, so we have media context
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beach Clock',
      home: BeachClockWrapper(),
      debugShowCheckedModeBanner: false
    );
  }
}

/// Wrapper centers and sizes the Clock
class BeachClockWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 
    // In Flutter were intuitive, something like this would work
    //return AspectRatio(
    //  aspectRatio: 800 / 480,
    //  child: BeachClock(),
    //);
        
    // Set size of BeachClock()
    MediaQueryData media = MediaQuery.of(context);
    Size size = aspectRatioIn(800 / 480, media.size);
    return Center(
      child: SizedBox(
        child: BeachClock(),
        width: size.width,
        height: size.height
      )
    );

  }
}
