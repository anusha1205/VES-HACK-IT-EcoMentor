import 'package:cloud_firestore/cloud_firestore.dart';

class News {
  final String id;
  final String headline;
  final String summary;
  final String imageUrl;
  final String source;
  final DateTime publishedDate;
  final int readTime;
  final List<String> tags;
  final bool isBookmarked;
  final String url;

  News({
    required this.id,
    required this.headline,
    required this.summary,
    required this.imageUrl,
    required this.source,
    required this.publishedDate,
    this.readTime = 2, // Default 2 minutes read time
    this.tags = const ['climate'],
    this.isBookmarked = false,
    required this.url,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      headline: json['headline'] as String,
      summary: json['summary'] as String,
      imageUrl: json['imageUrl'] as String,
      source: json['source'] as String,
      publishedDate: (json['publishedDate'] as Timestamp).toDate(),
      readTime: json['readTime'] as int? ?? 2,
      tags: List<String>.from(json['tags'] ?? ['climate']),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'headline': headline,
      'summary': summary,
      'imageUrl': imageUrl,
      'source': source,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'readTime': readTime,
      'tags': tags,
      'isBookmarked': isBookmarked,
      'url': url,
    };
  }

  News copyWith({
    String? id,
    String? headline,
    String? summary,
    String? imageUrl,
    String? source,
    DateTime? publishedDate,
    int? readTime,
    List<String>? tags,
    bool? isBookmarked,
    String? url,
  }) {
    return News(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      summary: summary ?? this.summary,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      publishedDate: publishedDate ?? this.publishedDate,
      readTime: readTime ?? this.readTime,
      tags: tags ?? this.tags,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      url: url ?? this.url,
    );
  }
}
