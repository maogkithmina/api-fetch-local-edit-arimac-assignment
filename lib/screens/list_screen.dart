import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/post_provider.dart';
import '../widgets/error_widget.dart';
import 'details_screen.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch posts when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Posts List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: _buildBody(postsState),
    );
  }

  Widget _buildBody(PostsState state) {
    // Loading state
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching posts...'),
          ],
        ),
      );
    }

    // Error state
    if (state.errorMessage != null) {
      return CustomErrorWidget(
        errorMessage: state.errorMessage!,
        onRetry: () {
          ref.read(postsProvider.notifier).fetchPosts();
        },
      );
    }

    // Empty state
    if (state.posts.isEmpty) {
      return const Center(child: Text('No posts available'));
    }

    // Data state - List of posts
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 196, 230, 245),
              child: Text(
                '${post.id}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            title: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsScreen(postId: post.id),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
