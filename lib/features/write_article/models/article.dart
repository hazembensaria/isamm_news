class Article {
  // Article properties
  final String id;
  final String title;
  final DateTime timestamp;
  final List<Map<String, dynamic>> content;
  final List<String> tags;
  final String? imageUrl;
  final int commentsCount;
  final int likesCount;

  // Constructor
  Article({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.content,
    required this.tags,
    required this.commentsCount,
    required this.likesCount,
    this.imageUrl,
  });

  // Factory method to create an Article from Firestore document data
  factory Article.fromFirestore(Map<String, dynamic> data, String id) {
    return Article(
      likesCount: data["likeCount"] ?? 0,
      commentsCount: data["commentsCount"] ?? 0,
      imageUrl: data['image'] ?? '',
      id: id,
      title: data['title'] ?? '',
      timestamp: data['timestamp'].toDate() ?? '',
      content: List<Map<String, dynamic>>.from(
        (data['content'] as List<dynamic>)
            .map((item) => Map<String, dynamic>.from(item)),
      ),
      //  content : [],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  // Convert Article to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'timestamp': timestamp,
      'content': content,
      'tags': tags,
      'image': imageUrl,
    };
  }

  /// Method to create a copy of the article with updated fields
  Article copyWith({
    String? id,
    String? title,
    String? imageUrl,
    List<Map<String, dynamic>>? content,
    DateTime? timestamp,
    List<String>? tags,
    int? commentsCount,
    int? likesCount,
  }) {
    return Article(
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? this.tags,
    );
  }

  // Example of other helper functions
  // Function to add a new tag
  void addTag(String tag) {
    tags.add(tag);
  }

  // Function to remove a tag
  void removeTag(String tag) {
    tags.remove(tag);
  }
}
