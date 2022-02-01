import 'package:flutter/material.dart';
import 'package:jenkins_board/model/job.dart';
import 'package:jenkins_board/utils/extensions.dart';

class SelectJob extends StatelessWidget {
  final Job job;
  final bool selected;
  final VoidCallback onTap;
  const SelectJob(this.job,
      {required this.selected, required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: context.accentColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.name,
                    style: context.headline6,
                  ),
                  if (job.description != null)
                    Text(
                      job.description!,
                      style: context.headline6,
                    ),
                  Text(
                    job.url,
                    style: context.sutitle2,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: selected
                  ? Icon(
                      Icons.favorite,
                      color: context.accentColor,
                    )
                  : Icon(
                      Icons.favorite_border,
                      color: context.accentColor,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
