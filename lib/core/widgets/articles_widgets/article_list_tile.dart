import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';

class ArticleListTile extends StatelessWidget {
  const ArticleListTile({required this.article, super.key});

  final Category article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(article.emoji, style: const TextStyle(fontSize: 18)),
      ),
      title: Text(article.name, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
