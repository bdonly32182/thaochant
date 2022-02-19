import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ListViewSkeleton extends StatelessWidget {
  ListViewSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SkeletonLoader(
        builder: ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Container(
                width: width * 1,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.teal.shade200,
                    Colors.tealAccent.shade400,
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
