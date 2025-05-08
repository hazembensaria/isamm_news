import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MainImageSkeletonz extends StatelessWidget {
  const MainImageSkeletonz({super.key});

  @override
  Widget build(BuildContext context) {
    return   Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
  }
}