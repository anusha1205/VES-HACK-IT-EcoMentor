import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/news.dart';
import '../../services/news_service.dart';
import '../../widgets/error_widget.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Latest'),
                Tab(text: 'Bookmarked'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                _LatestNewsTab(),
                _BookmarkedNewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestNewsTab extends StatefulWidget {
  const _LatestNewsTab();

  @override
  State<_LatestNewsTab> createState() => _LatestNewsTabState();
}

class _LatestNewsTabState extends State<_LatestNewsTab> {
  final NewsService _newsService = NewsService();
  final ScrollController _scrollController = ScrollController();
  DocumentSnapshot? _lastDocument;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      // Load more logic will be handled by the StreamBuilder
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<News>>(
      stream: _newsService.getLatestNews(lastDocument: _lastDocument),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Unable to load news at the moment',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _lastDocument = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final news = snapshot.data!;

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _lastDocument = null;
            });
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: news.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == news.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final newsItem = news[index];
              return _NewsCard(news: newsItem);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _BookmarkedNewsTab extends StatelessWidget {
  const _BookmarkedNewsTab();

  @override
  Widget build(BuildContext context) {
    final newsService = NewsService();

    return StreamBuilder<List<News>>(
      stream: newsService.getBookmarkedNews(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const CustomErrorWidget();
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final news = snapshot.data!;

        if (news.isEmpty) {
          return Center(
            child: Text(
              'No bookmarked news yet',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: news.length,
          itemBuilder: (context, index) => _NewsCard(news: news[index]),
        );
      },
    );
  }
}

class _NewsCard extends StatefulWidget {
  final News news;

  const _NewsCard({required this.news});

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> {
  bool _isExpanded = false;

  Future<void> _launchURL() async {
    if (widget.news.url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article URL not available'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      await url_launcher.launchUrl(
        Uri.parse(widget.news.url),
        mode: url_launcher.LaunchMode.externalApplication,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open article'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: _launchURL,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: widget.news.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.news.readTime} min read',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.news.source,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '•',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          timeago.format(widget.news.publishedDate),
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.news.headline,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.news.summary,
                          maxLines: _isExpanded ? null : 3,
                          overflow: _isExpanded ? null : TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        if (widget.news.summary.length > 150) ...[
                          const SizedBox(height: 4),
                          Text(
                            _isExpanded ? 'Show less' : 'Read more',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...widget.news.tags.map((tag) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Chip(
                                label: Text(tag),
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.1),
                                labelStyle: TextStyle(color: AppColors.primary),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _BookmarkButton(
                        newsId: widget.news.id,
                        isBookmarked: widget.news.isBookmarked,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () {
                          // TODO: Implement share functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final String newsId;
  final bool isBookmarked;

  const _BookmarkButton({
    required this.newsId,
    required this.isBookmarked,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border_outlined,
        color: isBookmarked ? AppColors.primary : null,
      ),
      onPressed: () {
        NewsService().toggleBookmark(newsId, !isBookmarked);
      },
    );
  }
}
