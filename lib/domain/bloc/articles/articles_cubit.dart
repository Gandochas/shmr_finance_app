import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:shmr_finance_app/domain/models/category/category.dart';
import 'package:shmr_finance_app/domain/repositories/category_repository.dart';

sealed class ArticlesState {
  const ArticlesState();
}

final class ArticlesLoadingState extends ArticlesState {
  const ArticlesLoadingState();
}

final class ArticlesErrorState extends ArticlesState {
  const ArticlesErrorState(this.errorMessage);

  final String errorMessage;
}

final class ArticlesIdleState extends ArticlesState {
  ArticlesIdleState(this.articles);

  final List<Category> articles;
}

final class ArticlesCubit extends Cubit<ArticlesState> {
  ArticlesCubit({required CategoryRepository categoryRepository})
    : _categoryRepository = categoryRepository,
      super(const ArticlesLoadingState());

  final CategoryRepository _categoryRepository;

  Future<void> loadAllArticles() async {
    emit(const ArticlesLoadingState());

    try {
      final articles = await _categoryRepository.getAll();

      emit(ArticlesIdleState(articles));
    } on Object {
      emit(const ArticlesErrorState('Failed to load the articles'));
      rethrow;
    }
  }

  Future<void> loadArticlesByName(
    String searchQuery, [
    int minSimilarity = 60,
  ]) async {
    emit(const ArticlesLoadingState());

    try {
      final articles = await _categoryRepository.getAll();
      final query = searchQuery.toLowerCase().trim();
      final neededArticles = articles
          .where(
            (element) =>
                partialRatio(query, element.name.toLowerCase()) >=
                minSimilarity,
          )
          .toList();

      neededArticles.sort(
        (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      );
      emit(ArticlesIdleState(neededArticles));
    } on Object {
      emit(const ArticlesErrorState('Failed to search the articles'));
      rethrow;
    }
  }
}
