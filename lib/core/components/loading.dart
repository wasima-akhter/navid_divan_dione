import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.w,
      width: 5.w,
      child: CircularProgressIndicator(
        color: Colors.blue,
        strokeWidth: 1,
      ),
    );
  }
}
