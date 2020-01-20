//
//   BEACH CLOCK
//
// Made by Tim Davidson Jan. 20, 2020
//

import 'package:flutter/material.dart';

/// Creates a Size of given aspect ratio filling given Size.
/// @param aspectRatio   Aspect ratio of output Size
/// @param size          Size to fill
/// @returns  Size with aspect ratio
Size aspectRatioIn(double aspectRatio, Size size) {    
    double w = size.width;
    double h = size.height;
    double sizeRatio = w / h;
    if (sizeRatio > aspectRatio) {
      // screen wider
      w = size.height * (aspectRatio / 1);
    } else if (sizeRatio < aspectRatio) {
      // screen taller
      h = size.width * aspectRatio;
    }

    return Size(w, h);
}