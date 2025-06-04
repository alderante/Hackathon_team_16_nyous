import 'package:flutter/material.dart';

// Custom Clipper Class
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path(); // Create a Path object to draw the shape.

    // Draw the triangle:
    path.lineTo(size.width, 0); // Line from top-left to top-right.
    path.lineTo(size.width / 2, size.height); // Line to the bottom-center.
    path.close(); // Close the path (connects back to the start).

    return path; // Return the completed shape.
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // No need to redraw the shape unless it changes.
  }
}
