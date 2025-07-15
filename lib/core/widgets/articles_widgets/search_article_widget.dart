import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/articles/articles_cubit.dart';

class SearchArticleWidget extends StatelessWidget {
  const SearchArticleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final articlesSearchController = TextEditingController();

    return DecoratedBox(
      decoration: BoxDecoration(color: theme.searchViewTheme.backgroundColor),
      child: ListTile(
        title: TextField(
          controller: articlesSearchController,
          decoration: InputDecoration(
            hint: Text('Найти статью', style: theme.textTheme.bodyLarge),
          ),
          onChanged: (value) async {
            final articlesCubit = context.read<ArticlesCubit>();
            value.trim().isEmpty
                ? await articlesCubit.loadAllArticles()
                : await articlesCubit.loadArticlesByName(
                    articlesSearchController.text,
                  );
          },
        ),
        trailing: const Icon(Icons.search),
      ),
    );
  }
}
