// lib/screens/home/tabs/explore/screens/city_cuisine_screen.dart
//
// CityCuisineScreen: Màn hình "Ẩm thực đặc sản" theo từng thành phố
// - Ảnh hero online (Pexels CDN) giống các screen trước (không dùng Wikipedia).
// - Danh sách món đặc sản (fake), có ảnh, mô tả ngắn, gợi ý nơi ăn.
// - Hỗ trợ nhiều thành phố: Hà Nội, TP.HCM, Đà Nẵng, Hải Phòng, Cần Thơ.
// - Nếu chưa có dữ liệu: hiển thị '...' và ảnh fallback.

import 'package:flutter/material.dart';
import 'package:my_app/utils/cities.dart';

class CityCuisineScreen extends StatelessWidget {
  final City city;
  const CityCuisineScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final dishes = _getDishes(city.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ẩm thực đặc sản — ${city.name}'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildHero(city),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Giới thiệu nhanh'),
                Text(
                  _intro(city.name),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 24),
                _sectionTitle('Món tiêu biểu'),
                if (dishes.isEmpty)
                  const Text('...', style: TextStyle(fontSize: 16))
                else
                  ...dishes.map((d) => _DishCard(dish: d)),

                const SizedBox(height: 24),
                _sectionTitle('Mẹo ăn uống'),
                Text(
                  _tips(city.name),
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 24),
                _sectionTitle('Khi nào nên thử?'),
                _TagWrap(items: _bestSeasons(city.name)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== Hero image =====
  static const Map<String, String> _cityImageUrlMap = {
    'Hà Nội':
        'https://images.pexels.com/photos/13986727/pexels-photo-13986727.jpeg?auto=compress&cs=tinysrgb&w=1200', // street food VN
    'TP. Hồ Chí Minh':
        'https://images.pexels.com/photos/17315330/pexels-photo-17315330.jpeg?auto=compress&cs=tinysrgb&w=1200', // Saigon food
    'Đà Nẵng':
        'https://images.pexels.com/photos/16007283/pexels-photo-16007283.jpeg?auto=compress&cs=tinysrgb&w=1200', // coastal food vibes
    'Hải Phòng':
        'https://images.pexels.com/photos/3298649/pexels-photo-3298649.jpeg?auto=compress&cs=tinysrgb&w=1200', // seafood table
    'Cần Thơ':
        'https://images.pexels.com/photos/1765005/pexels-photo-1765005.jpeg?auto=compress&cs=tinysrgb&w=1200', // floating market produce
  };
  static const String _fallbackHero =
      'https://images.pexels.com/photos/3184192/pexels-photo-3184192.jpeg?auto=compress&cs=tinysrgb&w=1200'; // generic vietnamese dish

  Widget _buildHero(City city) {
    final url = _cityImageUrlMap[city.name] ?? _fallbackHero;
    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder:
                'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
            image: url,
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) =>
                Image.network(_fallbackHero, fit: BoxFit.cover),
          ),
        ),
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              stops: const [0.6, 1.0],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ẩm thực ${city.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Đặc sản địa phương & gợi ý thưởng thức',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ===== Intro / Tips / Best seasons (fake) =====
  String _intro(String city) {
    switch (city) {
      case 'Hà Nội':
        return 'Ẩm thực Hà Nội tinh tế, thiên về vị thanh – nhẹ, nhấn vào nước dùng và gia vị truyền thống.';
      case 'TP. Hồ Chí Minh':
        return 'Đa dạng, phóng khoáng, kết hợp ba miền và ẩm thực đường phố sôi động gần như 24/7.';
      case 'Đà Nẵng':
        return 'Đậm đà vị miền Trung, nhiều món hải sản và mì – bún đặc trưng, ăn kèm rau sống.';
      case 'Hải Phòng':
        return 'Nổi tiếng hải sản; món nước cay – đậm, sợi bánh đa gạo đỏ đặc trưng.';
      case 'Cần Thơ':
        return 'Đậm chất miền Tây: ngọt – béo, nguyên liệu vườn – sông phong phú, chợ nổi sáng sớm.';
      default:
        return '...';
    }
  }

  String _tips(String city) {
    switch (city) {
      case 'Hà Nội':
        return 'Đi buổi sáng cho phở/bún thang; tránh giờ cao điểm trưa; thử quán lâu năm trong phố cổ.';
      case 'TP. Hồ Chí Minh':
        return 'Khám phá hẻm ẩm thực; tối muộn nhiều quán vẫn mở; hỏi giá trước với hải sản.';
      case 'Đà Nẵng':
        return 'Hải sản nên ghé quán gần bờ biển; mì Quảng ăn kèm rau và bánh tráng mè.';
      case 'Hải Phòng':
        return 'Bánh đa cua đúng vị cay – đậm; gọi thêm dăm bông, chả lá lốt nếu thích.';
      case 'Cần Thơ':
        return 'Đi chợ nổi Cái Răng từ 5–7h sáng; thử cà phê “sóng sánh” trên ghe.';
      default:
        return '...';
    }
  }

  List<String> _bestSeasons(String city) {
    switch (city) {
      case 'Hà Nội':
        return ['Thu (10–11)', 'Xuân (3–4)'];
      case 'TP. Hồ Chí Minh':
        return ['Quanh năm', 'Mùa khô (12–4)'];
      case 'Đà Nẵng':
        return ['2–5', '9–10'];
      case 'Hải Phòng':
        return ['Thu (10–11)', 'Hè (6–8)'];
      case 'Cần Thơ':
        return ['Mùa trái cây (5–8)', 'Mùa khô (12–4)'];
      default:
        return ['...'];
    }
  }

  // ===== Dish model + data =====
  List<_Dish> _getDishes(String city) {
    switch (city) {
      case 'Hà Nội':
        return [
          _Dish(
            name: 'Phở bò',
            imageUrl:
                'https://images.pexels.com/photos/13915198/pexels-photo-13915198.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Nước dùng trong, vị thanh; bánh phở mỏng; ăn kèm quẩy, chanh và ớt tươi.',
            where:
                'Phố cổ, khu Hoàn Kiếm; quán lâu năm quanh Hàng Vải/Hàng Điếu (fake).',
            tags: const ['Sáng', 'Nóng', 'Hà Nội'],
          ),
          _Dish(
            name: 'Bún chả',
            imageUrl:
                'https://images.pexels.com/photos/13915197/pexels-photo-13915197.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Thịt nướng than hoa, chả viên, nước chấm pha; ăn kèm bún sợi nhỏ và rau thơm.',
            where: 'Khu Hàng Mành, Hàng Quạt, Đội Cấn (fake).',
            tags: const ['Trưa', 'Đặc sản', 'Nướng'],
          ),
          _Dish(
            name: 'Chả cá',
            imageUrl:
                'https://images.pexels.com/photos/13573627/pexels-photo-13573627.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Cá tẩm nghệ – thì là, ăn nóng trên chảo, kèm bún – lạc – mắm tôm.',
            where: 'Phố Chả Cá, Lò Đúc (fake).',
            tags: const ['Tối', 'Bàn nóng', 'Cá'],
          ),
        ];
      case 'TP. Hồ Chí Minh':
        return [
          _Dish(
            name: 'Cơm tấm',
            imageUrl:
                'https://images.pexels.com/photos/15503607/pexels-photo-15503607.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Sườn nướng, bì, chả; mỡ hành, dưa chua; nước mắm pha chua ngọt.',
            where: 'Quận 1–3, Phú Nhuận; quán lề đường đêm (fake).',
            tags: const ['Đêm', 'Đậm đà', 'Sườn nướng'],
          ),
          _Dish(
            name: 'Hủ tiếu',
            imageUrl:
                'https://images.pexels.com/photos/18859408/pexels-photo-18859408.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Nước trong ngọt xương; topping đa dạng (xương, tim, gan, tôm, mực).',
            where: 'Quận 5–6 (khu người Hoa), quán sáng sớm (fake).',
            tags: const ['Sáng', 'Nước', 'Khu Hoa'],
          ),
          _Dish(
            name: 'Bánh mì Sài Gòn',
            imageUrl:
                'https://images.pexels.com/photos/16263378/pexels-photo-16263378.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Ổ giòn rụm, pate – chả – thịt nguội – đồ chua – rau; sốt bơ/maiyonaise.',
            where: 'Góc ngã tư trung tâm, xe đẩy vỉa hè (fake).',
            tags: const ['Mang đi', 'Nhanh', 'Giá rẻ'],
          ),
        ];
      case 'Đà Nẵng':
        return [
          _Dish(
            name: 'Mì Quảng',
            imageUrl:
                'https://images.pexels.com/photos/18859414/pexels-photo-18859414.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Sợi mì bản rộng, nước “chan vừa”; tôm – thịt – trứng; bánh tráng mè, rau sống.',
            where: 'Hải Châu, Sơn Trà (fake).',
            tags: const ['Rau sống', 'Miền Trung'],
          ),
          _Dish(
            name: 'Bún chả cá Đà Nẵng',
            imageUrl:
                'https://images.pexels.com/photos/13915196/pexels-photo-13915196.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc: 'Chả cá thu/ói; nước dùng thanh – cay nhẹ; ăn kèm hành, rau.',
            where: 'Gần cầu Rồng, tuyến ven sông Hàn (fake).',
            tags: const ['Nước', 'Cá', 'Đậm'],
          ),
          _Dish(
            name: 'Ốc/bò nướng',
            imageUrl:
                'https://images.pexels.com/photos/3297807/pexels-photo-3297807.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Đồ nướng than, sốt bơ tỏi/sate; nhâm nhi cùng rau răm – muối ớt.',
            where: 'Vỉa hè ven biển Mỹ Khê (fake).',
            tags: const ['Nướng', 'Biển đêm'],
          ),
        ];
      case 'Hải Phòng':
        return [
          _Dish(
            name: 'Bánh đa cua',
            imageUrl:
                'https://images.pexels.com/photos/13915200/pexels-photo-13915200.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Sợi bánh đa đỏ; nước cua ngọt; topping chả lá lốt/giò/bề bề.',
            where: 'Quận Lê Chân/Hồng Bàng (fake).',
            tags: const ['Cay nhẹ', 'Đặc trưng'],
          ),
          _Dish(
            name: 'Nem cua bể',
            imageUrl:
                'https://images.pexels.com/photos/7031708/pexels-photo-7031708.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Cuốn to nhân cua – thịt – mộc nhĩ, chiên giòn; chấm nước mắm tỏi ớt.',
            where: 'Các quán hải sản khu phố cổ (fake).',
            tags: const ['Chiên', 'Hải sản'],
          ),
          _Dish(
            name: 'Hải sản tươi',
            imageUrl:
                'https://images.pexels.com/photos/3217152/pexels-photo-3217152.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Tôm, cua, bề bề, cá mùa; chế biến nhanh giữ vị ngọt tự nhiên.',
            where: 'Khu Đồ Sơn, Cát Bà (fake).',
            tags: const ['Hải sản', 'Theo mùa'],
          ),
        ];
      case 'Cần Thơ':
        return [
          _Dish(
            name: 'Bánh cống',
            imageUrl:
                'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Bột gạo chiên khuôn, nhân đậu xanh – tôm; ăn kèm rau sống và nước mắm chua ngọt.',
            where: 'Quận Ninh Kiều, các quán xế chiều (fake).',
            tags: const ['Giòn', 'Quần tụ'],
          ),
          _Dish(
            name: 'Lẩu mắm',
            imageUrl:
                'https://images.pexels.com/photos/16263367/pexels-photo-16263367.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Nước lẩu mắm cá linh/cá sặc, rau đồng đa dạng; vị đậm, rất “miền Tây”.',
            where: 'Quán gia đình ven sông (fake).',
            tags: const ['Lẩu', 'Đậm đà'],
          ),
          _Dish(
            name: 'Chuối nếp nướng',
            imageUrl:
                'https://images.pexels.com/photos/13887621/pexels-photo-13887621.jpeg?auto=compress&cs=tinysrgb&w=1200',
            desc:
                'Chuối quấn xôi nếp, nướng than; rưới nước cốt dừa, đậu phộng.',
            where: 'Chợ đêm Ninh Kiều (fake).',
            tags: const ['Tráng miệng', 'Đường phố'],
          ),
        ];
      default:
        return const [];
    }
  }
}

// ===== Widgets phụ =====

class _DishCard extends StatelessWidget {
  final _Dish dish;
  const _DishCard({required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh món ăn
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: FadeInImage.assetNetwork(
                placeholder:
                    'https://images.pexels.com/photos/30706917/pexels-photo-30706917.jpeg?auto=compress&cs=tinysrgb&w=800',
                image: dish.imageUrl,
                fit: BoxFit.cover,
                imageErrorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
              ),
            ),
          ),

          // Nội dung
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dish.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dish.desc,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.place, size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dish.where,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _TagWrap(items: dish.tags),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagWrap extends StatelessWidget {
  final List<String> items;
  const _TagWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (t) => Chip(
              label: Text(t),
              backgroundColor: Colors.orange.withOpacity(0.1),
              side: BorderSide(color: Colors.orange.withOpacity(0.3)),
            ),
          )
          .toList(),
    );
  }
}

// ===== Data class nội bộ =====

class _Dish {
  final String name;
  final String imageUrl;
  final String desc;
  final String where;
  final List<String> tags;

  const _Dish({
    required this.name,
    required this.imageUrl,
    required this.desc,
    required this.where,
    required this.tags,
  });
}
