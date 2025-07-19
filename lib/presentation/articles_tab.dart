import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shmr_finance_app/domain/bloc/articles/articles_cubit.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';
import 'package:shmr_finance_app/presentation/pages/articles_page.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticlesCubit>(
      create: (context) =>
          ArticlesCubit(categoryRepository: context.read<CategoryRepository>())
            ..loadAllArticles(),
      child: const ArticlesPage(),
    );
  }
}
