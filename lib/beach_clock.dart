//
//   BEACH CLOCK
//
// Made by Tim Davidson Jan. 20, 2020
//

import 'dart:async';
import 'package:flutter/services.dart';   //for set pref orientation
import 'package:flutter/widgets.dart';    // for mediaQuery to get screen size

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'utility.dart';

///
class BeachClock extends StatefulWidget {
  @override
  _BeachClockState createState() => _BeachClockState();
}

/// The state. File private.
/// Animation Controller requires a Ticker Provider
class _BeachClockState extends State<BeachClock> with SingleTickerProviderStateMixin {

  // Properties
  AnimationController _animationController;
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  // Color constants
  final Color kSkyColor = Color.fromRGBO(80, 163, 217, 1.0);
  final Color kSunColor = Color.fromRGBO(255, 221, 21, 1.0);
  final Color kCloudRedColor = Color.fromRGBO(233, 65, 60, 1.0);
  final Color kPalmsDayColor = Color.fromRGBO(38, 34, 97, 1.0);
  final Color kPalmsNightColor = Color.fromRGBO(48, 32, 53, 1.0);
  final Color kTimeDayColor = Color.fromRGBO(199, 255, 217, 0.6);
  final Color kTimeNightColor = Color.fromRGBO(249, 236, 183, 0.6);

  // Images
  Image kCloud1Image;
  Image kCloud2Image;
  Image kCloud3Image;
  Image kCloud4Image;
  Image kCloud5Image;
  Image kCloud6Image;
  Image kDayHorizonImage;
  Image kMoonImage;
  Image kNightHorizonImage;
  Image kNightSkyImage;
  Image kPalmsImage;
  Image kReflectionImage;
  Image kSunImage;
  Image kWave1Image;
  Image kWave2Image;
  Image kWave3Image;

  @override
  void initState() {

    super.initState();
    _updateTime();

    kCloud1Image = Image(image: AssetImage('assets/images/cloud1.png'));
    kCloud2Image = Image(image: AssetImage('assets/images/cloud2.png'));
    kCloud3Image = Image(image: AssetImage('assets/images/cloud3.png'));
    kCloud4Image = Image(image: AssetImage('assets/images/cloud4.png'));
    kCloud5Image = Image(image: AssetImage('assets/images/cloud5.png'));
    kCloud6Image = Image(image: AssetImage('assets/images/cloud6.png'));
    kDayHorizonImage = Image(image: AssetImage('assets/images/day_horizon.png'));
    kMoonImage = Image(image: AssetImage('assets/images/moon.png'));
    kNightHorizonImage = Image(image: AssetImage('assets/images/night_horizon.png'));
    kNightSkyImage = Image(image: AssetImage('assets/images/night_sky.png'));
    kPalmsImage = Image(image: AssetImage('assets/images/palms.png'));
    kReflectionImage = Image(image: AssetImage('assets/images/reflection.png'));
    kSunImage = Image(image: AssetImage('assets/images/sun.png'));
    kWave1Image = Image(image: AssetImage('assets/images/wave1.png'));
    kWave2Image = Image(image: AssetImage('assets/images/wave2.png'));
    kWave3Image = Image(image: AssetImage('assets/images/wave3.png'));

    _animationController = AnimationController(
      value: 0.0,
      lowerBound : 0.0,
      upperBound: 1.0,
      duration:  const Duration(minutes: 1), //within 1 minute come back multiple times (every 1/16 second)
      vsync: this,
    );
    _animationController.addListener(() {
      setState((){}); //Note: does not go through updateTime() so _dateTime not set, so build uses value..
    });               // to decide what actions to perform
    //_animationController.repeat(); //keep going
  }

  @override
  void didUpdateWidget(BeachClock oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // code after these 6 lines.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );

    });

    // Had to null check this for some reason.
    if (_animationController != null) {
      // keep animation controller in sync with teh timer, so eg Value = 0.016666 = 1 second
      _animationController.value = (_dateTime.second + (_dateTime.millisecond/1000))/60.0;
      _animationController.repeat();
    }
  }

  // --------------------------------------------------------------------------------------

  /// The big build method.
  @override
  Widget build(BuildContext context) {
    // I guess I'm doing this again. I really wanted this component to be given it's
    // size, that would be good component based ui structure design. 
    MediaQueryData media = MediaQuery.of(context);
    Size size = aspectRatioIn(800 / 480, media.size);

    // base values used for positioning
    double w = size.width;
    double h = size.height;
    double a = _animationController.value;

    // Same percentage values. I've tended to break up into 25 x 15 grid.
    double g = w / 25.0;
    double horizonY = g * 9;


    List<Widget> stack = [];

    // sun image is 138 x 138, and needs to be colored
    //Image sunImage = Image
    //stack.add(Positioned(top: horizonY, left: 0.0, width: (138.0 / 800.0) * w, child: sunImage));

    stack.add(Positioned(left: w * 0.01 * a, top: h * 0.01 * a, child: ClipRect(child: kCloud1Image)));
    stack.add(Positioned(left: w * 0.02 * a, top: h * 0.3 * a,  child: ClipRect(child: kCloud2Image)));
    stack.add(Positioned(left: w * 0.05 * a, top: h * 0.4 * a,  child: ClipRect(child: kCloud3Image)));


    // TIME TEXT
    final time =  DateFormat('h:mm').format(_dateTime);
    final fontSize = h * 0.7;
    final timeStyle = TextStyle(
      color: kTimeDayColor,
      fontFamily: 'VAGRoundedLTCYRW10-Black',
      fontSize: fontSize,
    );
    stack.add(Center(child: Text(time, style: timeStyle)));

    // HORIZON
    stack.add(Positioned(top: horizonY, left: 0.0, width: w, child: kDayHorizonImage));

    stack.add(Positioned(left: w * 0.01 * a, top: h * 0.6 * a, child: ClipRect( child: kWave1Image)));
    stack.add(Positioned(left: w * 0.05 * a, top: h * 0.7 * a, child: ClipRect( child: kWave2Image)));
    stack.add(Positioned(left: w * 0.05 * a, top: h * 0.4 * a, child: ClipRect( child: kWave3Image)));

    return Container(
      color: kSkyColor,
      child: Stack(
        children: stack,
      )
    );

  }
    
  
}


