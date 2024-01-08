part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

@immutable
sealed class PostsAddingState extends PostsState {}

final class PostsLoadingState extends PostsState {}

final class PostsErrorState extends PostsState {}

final class PostsSuccessfullyState extends PostsState {
  final List<Post> posts;
  PostsSuccessfullyState(this.posts);
}

final class AddingPostLoadingState extends PostsAddingState {}

final class AddingPostSuccessfullyState extends PostsAddingState {}

final class AddingPostErrorState extends PostsAddingState {}
