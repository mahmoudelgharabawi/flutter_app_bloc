import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/service/post.service.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsLoadingState()) {
    on<PostsInitialFetchEvent>(postsInitialFetch);
    on<PostAddEvent>(postAddEvent);
  }

  FutureOr<void> postsInitialFetch(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    try {
      emit(PostsLoadingState());
      var posts = await PostsService.fetchPosts();
      emit(PostsSuccessfullyState(posts));
    } catch (e) {
      emit(PostsErrorState());
    }
  }

  FutureOr<void> postAddEvent(
      PostAddEvent event, Emitter<PostsState> emit) async {
    try {
      emit(AddingPostLoadingState());
      bool success = await PostsService.addPost();

      if (success) {
        emit(AddingPostSuccessfullyState());
      } else {
        emit(AddingPostErrorState());
      }
    } catch (e) {
      emit(AddingPostErrorState());
    }
  }
}
