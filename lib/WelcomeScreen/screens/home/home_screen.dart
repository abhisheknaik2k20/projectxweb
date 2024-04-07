import 'package:flutter/material.dart';
import 'package:projectxweb/WelcomeScreen/constants.dart';
import 'package:projectxweb/WelcomeScreen/models/Blog.dart';

import '../../responsive.dart';
import 'components/blog_post.dart';
import 'components/categories.dart';
import 'components/recent_posts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: List.generate(
              blogPosts.length,
              (index) => BlogPostCard(blog: blogPosts[index]),
            ),
          ),
        ),
        if (!Responsive.isMobile(context)) SizedBox(width: kDefaultPadding),
        if (!Responsive.isMobile(context))
          const Expanded(
            child: Column(
              children: [
                SizedBox(height: kDefaultPadding),
                Categories(),
                SizedBox(height: kDefaultPadding),
                RecentPosts(),
              ],
            ),
          ),
      ],
    );
  }
}
