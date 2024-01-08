import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_bloc/bloc/posts_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(create: (context) => PostsBloc(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PostsPage(),
    );
  }
}

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    BlocProvider.of<PostsBloc>(context).add(PostsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<PostsBloc>(context).add(PostAddEvent());
        },
        child: Icon(Icons.send),
      ),
      appBar: AppBar(
        title: const Text('Posts Page'),
      ),
      body: BlocConsumer(
          bloc: BlocProvider.of<PostsBloc>(context),
          listenWhen: (previous, current) => current is PostsAddingState,
          buildWhen: (previous, current) => current is! PostsAddingState,
          builder: (ctx, state) {
            if (state is PostsLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PostsSuccessfullyState) {
              return Center(
                child: Text(
                  state.posts.length.toString(),
                ),
              );
            } else if (state is PostsErrorState) {
              return Center(
                child: Text(
                  'error',
                ),
              );
            }
            return const SizedBox.shrink();
          },
          listener: (context, state) {
            if (state is AddingPostLoadingState) {
              CoolAlert.show(
                context: context,
                type: CoolAlertType.loading,
              );
            } else if (state is AddingPostSuccessfullyState) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      title: 'data sended Successfully')
                  .then((value) => BlocProvider.of<PostsBloc>(context)
                      .add(PostsInitialFetchEvent()));
            } else if (state is AddingPostErrorState) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              CoolAlert.show(
                  context: context,
                  type: CoolAlertType.error,
                  title: 'error in send data');
            }
          }),
    );
  }
}
