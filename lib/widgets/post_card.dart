import 'package:flutter/material.dart';
import 'package:my_app/models/post/index.dart';
import 'package:timeago/timeago.dart' as timeago;


class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Định dạng thời gian đăng bài (vd: 2 giờ trước)
    final timeAgo = timeago.format(post.createdAt, locale: 'vi');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, tên tác giả, thời gian và loại bài viết
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.authorAvatarUrl),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            timeAgo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.public, size: 14, color: Colors.grey[600]),
                        ],
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    post.type.label,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: post.type.color,
                  avatar: Icon(post.type.icon, color: Colors.white, size: 14),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),

          // Địa điểm
          if (post.location.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  Text(
                    post.location,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Nội dung bài viết
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(post.content, style: const TextStyle(fontSize: 16)),
          ),

          // Hình ảnh (nếu có)
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                post.imageUrl!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 250,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: 250,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Không thể tải hình ảnh',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Thống kê tương tác
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.thumb_up, size: 16, color: Colors.blue[400]),
                const SizedBox(width: 4),
                Text(
                  '${post.likes}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  '${post.comments} bình luận',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(width: 8),
                Text(
                  '${post.shares} chia sẻ',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[300]),

          // Các nút tương tác
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.thumb_up_outlined, color: Colors.grey[700]),
                  label: Text(
                    'Thích',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey[700],
                  ),
                  label: Text(
                    'Bình luận',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share_outlined, color: Colors.grey[700]),
                  label: Text(
                    'Chia sẻ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
