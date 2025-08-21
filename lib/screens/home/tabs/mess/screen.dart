// Tab Mess - nơi nhắn tin
import 'package:flutter/material.dart';

class MessTab extends StatelessWidget {
  const MessTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: const [
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
            name: 'Nguyễn Văn A',
            lastMessage: 'Bạn khỏe không? Hôm nay mình có lịch họp lúc 2h chiều nhé',
            time: '12:30',
            isOnline: true,
            unreadCount: 3,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
            name: 'Trần Thị B',
            lastMessage: 'Đã gửi một hình ảnh',
            time: '11:45',
            isOnline: false,
            unreadCount: 0,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
            name: 'Lê Văn C',
            lastMessage: 'Ok bạn, hẹn gặp lại sau nhé!',
            time: 'Hôm qua',
            isOnline: true,
            unreadCount: 0,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/women/4.jpg',
            name: 'Phạm Thị D',
            lastMessage: 'Bạn đã nhận được tài liệu mình gửi chưa?',
            time: 'Hôm qua',
            isOnline: false,
            unreadCount: 1,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/men/5.jpg',
            name: 'Hoàng Văn E',
            lastMessage: 'Chào bạn, mình muốn hỏi về dự án mới',
            time: 'T2',
            isOnline: false,
            unreadCount: 0,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/women/6.jpg',
            name: 'Nhóm Dự án XYZ',
            lastMessage: 'Nguyễn Văn A: Mọi người nhớ nộp báo cáo nhé',
            time: 'T2',
            isOnline: true,
            unreadCount: 5,
            isGroup: true,
          ),
          _ChatListTile(
            avatar: 'https://randomuser.me/api/portraits/men/7.jpg',
            name: 'Trương Văn F',
            lastMessage: 'Đã gửi một file',
            time: 'CN',
            isOnline: false,
            unreadCount: 0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  final String avatar;
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unreadCount;
  final bool isGroup;

  const _ChatListTile({
    required this.avatar,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.unreadCount,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(avatar),
          ),
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: unreadCount > 0 ? Colors.blue : Colors.grey,
              fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          if (isGroup)
            const Icon(
              Icons.group,
              size: 14,
              color: Colors.grey,
            ),
          Expanded(
            child: Text(
              lastMessage,
              style: TextStyle(
                color: unreadCount > 0 ? Colors.black87 : Colors.grey,
                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      onTap: () {},
    );
  }
}