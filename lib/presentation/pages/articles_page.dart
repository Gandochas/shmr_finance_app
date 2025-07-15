import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/core/widgets/articles_widgets/article_list_tile.dart';
import 'package:shmr_finance_app/core/widgets/articles_widgets/search_article_widget.dart';
import 'package:shmr_finance_app/domain/bloc/articles/articles_cubit.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ArticlesCubit, ArticlesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: Text('Мои статьи', style: theme.appBarTheme.titleTextStyle),
            centerTitle: true,
          ),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  const SearchArticleWidget(),
                  Builder(
                    builder: (context) {
                      return switch (state) {
                        ArticlesLoadingState() => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                        ArticlesErrorState() => Center(
                          child: Text(state.errorMessage),
                        ),
                        ArticlesIdleState(:final articles) => Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final article = articles[index];
                              return ArticleListTile(article: article);
                            },

                            separatorBuilder: (context, index) =>
                                Divider(color: theme.dividerColor, height: 1),

                            itemCount: articles.length,
                          ),
                        ),
                      };
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
