import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';

class PostSection extends StatelessWidget {
  final List<Post> posts;
  const PostSection({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 12.0),
            child: Text(
              'Trip Feed',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5),
            ),
          ),
          SizedBox(
            height: 125.0, // Увеличено для предотвращения Bottom Overflow
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 4);
              },
            ),
          ),
        ],
      ),
    );
  }
}
