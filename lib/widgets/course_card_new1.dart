import 'package:flutter/material.dart';
import 'package:learning_app/models/course_info_model.dart';
import 'package:intl/intl.dart';

class CourseCardNew1 extends StatelessWidget {
  final CourseInfoModel course;
  final VoidCallback onTap;

  const CourseCardNew1({super.key, required this.course, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final pricing = course.pricing;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Hero(
                tag: course.id,
                child: Image.network(
                  course.bannerImageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 5, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTag(course.languageTag),
                      const SizedBox(width: 6),
                      _buildTag(course.categoryTag),
                    ],
                  ),

                  const SizedBox(height: 5),
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Text(
                    "Enrollment closes on "
                    "${DateFormat('dd MMM').format(course.enrollmentEndDate)}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        pricing.isFree
                            ? "Free"
                            : "${pricing.currency} ${pricing.price.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (!pricing.isFree)
                        Text(
                          "${pricing.currency} ${(pricing.price * 1.5).toStringAsFixed(0)}",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
