import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post.dart';
import '../repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

// State class for posts
class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? errorMessage;

  const PostsState({
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  PostsState copyWith({
    List<Post>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Notifier for managing posts state
class PostsNotifier extends StateNotifier<PostsState> {
  final PostRepository _repository;

  PostsNotifier(this._repository) : super(const PostsState());

  // Fetch posts from API
  Future<void> fetchPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final posts = await _repository.fetchPosts();
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Update a post locally
  void updatePost(int postId, String newTitle, String newBody) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(title: newTitle, body: newBody);
      }
      return post;
    }).toList();

    state = state.copyWith(posts: updatedPosts);
  }

  // Get a single post by ID
  Post? getPostById(int id) {
    try {
      return state.posts.firstWhere((post) => post.id == id);
    } catch (e) {
      return null;
    }
  }
}

// Provider for posts state
final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  final repository = ref.read(postRepositoryProvider);
  return PostsNotifier(repository);
});
