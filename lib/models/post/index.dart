import 'package:flutter/material.dart';
import 'dart:math';

class Post {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final String location;
  final PostType type;

  Post({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.location,
    required this.type,
  });

  /// Tạo danh sách bài đăng mẫu (fake feed)
  static List<Post> generateSamplePosts() {
    final random = Random();

    final List<Map<String, dynamic>> postData = [
      {
        'authorName': 'Nguyễn Văn A',
        'content':
            'Vịnh Hạ Long - Kỳ quan thiên nhiên thế giới với hơn 1.600 hòn đảo đá vôi, tạo nên khung cảnh tuyệt đẹp. Đây là điểm du lịch không thể bỏ qua khi đến Việt Nam. Hôm nay mình đã có cơ hội khám phá vẻ đẹp của vịnh từ trên du thuyền, thật sự choáng ngợp!',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Ha_Long_Bay.jpg/1024px-Ha_Long_Bay.jpg',
        'location': 'Vịnh Hạ Long, Quảng Ninh',
        'type': PostType.travel,
      },
      {
        'authorName': 'Trần Thị B',
        'content':
            'Phở - Món ăn đặc trưng của Việt Nam, đã trở thành một phần văn hóa ẩm thực được yêu thích trên toàn thế giới. Phở Hà Nội với nước dùng trong, vị thanh nhẹ và bánh phở mỏng. Còn phở Nam thì đậm đà, ngọt thịt hơn. Các bạn thích phở kiểu nào hơn?',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Pho-Beef-Noodles-2008.jpg/1200px-Pho-Beef-Noodles-2008.jpg',
        'location': 'Hà Nội',
        'type': PostType.food,
      },
      {
        'authorName': 'Lê Văn C',
        'content':
            'Cố đô Huế - Kinh đô của triều Nguyễn với hệ thống di tích lịch sử văn hóa đặc sắc. Đại Nội, lăng tẩm các vua, chùa Thiên Mụ... tất cả đều mang đậm dấu ấn lịch sử và văn hóa truyền thống. Hôm nay mình đã tham quan Đại Nội và thực sự ấn tượng với kiến trúc cung đình độc đáo.',
        'imageUrl':
            'https://reviewvilla.vn/wp-content/uploads/2022/06/Co-Do-Hue-19.jpg',
        'location': 'Huế, Thừa Thiên Huế',
        'type': PostType.history,
      },
      {
        'authorName': 'Phạm Thị D',
        'content':
            'Hội An - Phố cổ xinh đẹp với những ngôi nhà mái ngói rêu phong, đèn lồng đầy màu sắc. Vào buổi tối, khi ánh đèn lồng thắp sáng, cả phố cổ như một bức tranh cổ tích. Mình đã có một buổi tối tuyệt vời, thả đèn hoa đăng trên sông Hoài và thưởng thức ẩm thực địa phương.',
        'imageUrl':
            'https://hoiana.com/wp-content/uploads/2025/05/hoi-an-6520902_1280.webp',
        'location': 'Hội An, Quảng Nam',
        'type': PostType.culture,
      },
      {
        'authorName': 'Hoàng Văn E',
        'content':
            'Cao nguyên đá Đồng Văn - Công viên địa chất toàn cầu với những khối đá vôi kỳ vĩ và ruộng bậc thang tuyệt đẹp. Đây là nơi sinh sống của nhiều dân tộc thiểu số với văn hóa độc đáo. Hôm nay mình đã chinh phục đỉnh Mã Pì Lèng, ngắm nhìn dòng sông Nho Quế xanh ngắt uốn lượn giữa núi đá.',
        'imageUrl':
            'https://elitetour.com.vn/files/images/Blogs/pho-co-dong-van.jpg',
        'location': 'Đồng Văn, Hà Giang',
        'type': PostType.travel,
      },
      {
        'authorName': 'Nguyễn Thị F',
        'content':
            'Bánh mì Việt Nam - Sự kết hợp hoàn hảo giữa ẩm thực Pháp và Việt Nam. Ổ bánh mì giòn tan bên ngoài, mềm bên trong, kết hợp với các loại nhân đa dạng. Món ăn đường phố này đã được CNN bình chọn là một trong những món sandwich ngon nhất thế giới.',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/19/B%C3%A1nh_m%C3%AC.jpg/1024px-B%C3%A1nh_m%C3%AC.jpg',
        'location': 'Sài Gòn, TP. Hồ Chí Minh',
        'type': PostType.food,
      },
      {
        'authorName': 'Trần Văn G',
        'content':
            'Nhã nhạc cung đình Huế - Di sản văn hóa phi vật thể của nhân loại. Âm nhạc cung đình thời Nguyễn với các nhạc cụ truyền thống và điệu múa uyển chuyển. Hôm nay mình đã được thưởng thức một buổi biểu diễn tại Đại Nội, thật sự là một trải nghiệm văn hóa đáng nhớ.',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Nh%C3%A3_nh%E1%BA%A1c_cung_%C4%91%C3%ACnh_Hu%E1%BA%BF.JPG/1024px-Nh%C3%A3_nh%E1%BA%A1c_cung_%C4%91%C3%ACnh_Hu%E1%BA%BF.JPG',
        'location': 'Huế, Thừa Thiên Huế',
        'type': PostType.culture,
      },
      {
        'authorName': 'Lê Thị H',
        'content':
            'Thành cổ Quảng Trị - Chứng tích lịch sử của 81 ngày đêm chiến đấu anh dũng trong chiến tranh. Di tích này mang đậm dấu ấn của lịch sử đấu tranh giành độc lập dân tộc. Hôm nay mình đã đến thăm và thắp hương tưởng niệm các anh hùng liệt sĩ.',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/29._-_Quang_Tri_Citadel_and_City_Fall_1967.jpg/1024px-29._-_Quang_Tri_Citadel_and_City_Fall_1967.jpg',
        'location': 'Quảng Trị',
        'type': PostType.history,
      },
      {
        'authorName': 'Phạm Văn I',
        'content':
            'Vườn quốc gia Phong Nha - Kẻ Bàng, di sản thiên nhiên thế giới với hệ thống hang động kỳ vĩ. Sơn Đoòng - hang động lớn nhất thế giới nằm tại đây. Hôm nay mình đã khám phá hang Thiên Đường với những nhũ đá tuyệt đẹp, như lạc vào một thế giới thần tiên.',
        'imageUrl':
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Phong_Nha-Ke_Bang_cave3.jpg/1024px-Phong_Nha-Ke_Bang_cave3.jpg',
        'location': 'Quảng Bình',
        'type': PostType.travel,
      },
      {
        'authorName': 'Hoàng Thị K',
        'content':
            'Cơm tấm Sài Gòn - Món ăn đặc trưng của người Nam Bộ. Hạt cơm tấm dẻo thơm, sườn nướng đậm đà, chả trứng béo ngậy, kèm đồ chua và nước mắm chua ngọt. Một bữa sáng hoàn hảo của người Sài Gòn. Hôm nay mình đã thưởng thức tại một quán cơm tấm lâu đời ở quận 3, thật tuyệt vời!',
        'imageUrl': 'https://i.ytimg.com/vi/72HGFxZTt-Q/hqdefault.jpg',
        'location': 'TP. Hồ Chí Minh',
        'type': PostType.food,
      },
    ];

    return postData.map((data) {
      return Post(
        id: UniqueKey().toString(),
        authorName: data['authorName'] as String,
        authorAvatarUrl: _randomAvatarUrl(),
        content: data['content'] as String,
        imageUrl: data['imageUrl'] as String?,
        createdAt: DateTime.now().subtract(
          Duration(hours: random.nextInt(72) + 1),
        ),
        likes: random.nextInt(500) + 50,
        comments: random.nextInt(100) + 5,
        shares: random.nextInt(50) + 2,
        location: data['location'] as String,
        type: data['type'] as PostType,
      );
    }).toList();
  }

  static String _randomAvatarUrl() {
    final r = Random().nextInt(100000);
    // pravatar: ảnh avatar giả lập ổn định và nhanh
    return 'https://i.pravatar.cc/150?u=$r';
  }
}

enum PostType { travel, food, culture, history }

extension PostTypeExtension on PostType {
  IconData get icon {
    switch (this) {
      case PostType.travel:
        return Icons.landscape;
      case PostType.food:
        return Icons.restaurant;
      case PostType.culture:
        return Icons.theater_comedy;
      case PostType.history:
        return Icons.history_edu;
    }
  }

  String get label {
    switch (this) {
      case PostType.travel:
        return 'Du lịch';
      case PostType.food:
        return 'Ẩm thực';
      case PostType.culture:
        return 'Văn hóa';
      case PostType.history:
        return 'Lịch sử';
    }
  }

  Color get color {
    switch (this) {
      case PostType.travel:
        return Colors.blue;
      case PostType.food:
        return Colors.orange;
      case PostType.culture:
        return Colors.purple;
      case PostType.history:
        return Colors.brown;
    }
  }
}
