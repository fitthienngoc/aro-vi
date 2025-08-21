// lib/screens/home/tabs/explore/screens/city_formation_history_screen.dart
//
// CityFormationHistoryScreen: Màn hình hiển thị "lịch sử hình thành" của một thành phố
// - Dùng ảnh online (Pexels CDN) giống CityGeneralInfoScreen
// - Nội dung chính là một bài viết dài (fake/placeholder nếu cần)
// - Có tóm tắt mốc thời gian + tài liệu tham khảo (URLs)

import 'package:flutter/material.dart';
import 'package:my_app/utils/cities.dart';

class CityFormationHistoryScreen extends StatelessWidget {
  final City city;

  const CityFormationHistoryScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final article = _getHistoryArticle(city.name);
    final timeline = _getHistoryTimeline(city.name);
    final sources = _getHistorySources(city.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử hình thành — ${city.name}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đầu trang (hero)
            _buildCityImage(city),

            // Nội dung
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Dẫn nhập'),
                  Text(
                    _intro(city.name),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle('Tóm tắt mốc thời gian'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: timeline.map((e) {
                      return Chip(
                        label: Text(e, style: const TextStyle(fontSize: 13)),
                        backgroundColor: Colors.blue.withOpacity(0.08),
                        side: BorderSide(color: Colors.blue.withOpacity(0.2)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle('Bài viết'),
                  ...article.map(
                    (para) => Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        para,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionTitle('Tài liệu tham khảo (tham khảo nhanh)'),
                  ...sources.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Mở: $s')));
                        },
                        child: Text(
                          s,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Chia sẻ bài viết lịch sử của ${city.name}'),
            ),
          );
        },
        child: const Icon(Icons.share),
        tooltip: 'Chia sẻ',
      ),
    );
  }

  // ===== ẢNH THÀNH PHỐ (ONLINE) =====

  static const Map<String, String> _cityImageUrlMap = {
    'Hà Nội':
        'https://images.pexels.com/photos/24768592/pexels-photo-24768592.jpeg?auto=compress&cs=tinysrgb&w=1200',
    'TP. Hồ Chí Minh':
        'https://images.pexels.com/photos/31910167/pexels-photo-31910167.jpeg?auto=compress&cs=tinysrgb&w=1200',
    'Đà Nẵng':
        'https://images.pexels.com/photos/32015496/pexels-photo-32015496.jpeg?auto=compress&cs=tinysrgb&w=1200',
    'Hải Phòng':
        'https://images.pexels.com/photos/6348812/pexels-photo-6348812.jpeg?auto=compress&cs=tinysrgb&w=1200',
    'Cần Thơ':
        'https://images.pexels.com/photos/31170208/pexels-photo-31170208.jpeg?auto=compress&cs=tinysrgb&w=1200',
  };

  static const String _fallbackCityImageUrl =
      'https://images.pexels.com/photos/18893911/pexels-photo-18893911.jpeg?auto=compress&cs=tinysrgb&w=1200';

  Widget _buildCityImage(City city) {
    final url = _cityImageUrlMap[city.name] ?? _fallbackCityImageUrl;
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
                Image.network(_fallbackCityImageUrl, fit: BoxFit.cover),
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
                city.name,
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
              Row(
                children: [
                  const Icon(Icons.history_edu, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Lịch sử hình thành',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===== UI helpers =====

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
  );

  // ===== Fake content generators =====
  // Dưới đây là nội dung tóm lược/fake. Bạn có thể thay thế bằng dữ liệu thật bất kỳ lúc nào.
  // Nếu muốn "trống", hãy trả về '...' ở các đoạn tương ứng.

  String _intro(String cityName) {
    switch (cityName) {
      case 'Hà Nội':
        return 'Hà Nội là trung tâm quyền lực qua nhiều triều đại và là thủ đô của Việt Nam hiện đại. Bài viết dưới đây tóm lược một số giai đoạn tiêu biểu trong quá trình hình thành và phát triển của thành phố.';
      case 'TP. Hồ Chí Minh':
        return 'Từ một vùng đất Khmer đến Gia Định – Sài Gòn, thành phố đã trở thành đầu tàu kinh tế và một tâm điểm lịch sử của Việt Nam cận – hiện đại.';
      case 'Đà Nẵng':
        return 'Từ cửa biển cổ, “Tourane” thời Pháp thuộc cho đến đô thị biển năng động, Đà Nẵng gắn với những biến thiên lớn của lịch sử Việt Nam.';
      case 'Hải Phòng':
        return 'Thành phố cảng lớn ở miền Bắc, Hải Phòng mang dấu ấn từ các nền văn hoá cổ đến thời kỳ thuộc địa và hiện đại hoá.';
      case 'Cần Thơ':
        return 'Từ vùng Trấn Giang đến đô thị trung tâm Đồng bằng sông Cửu Long, Cần Thơ phản ánh lịch sử khai phá phương Nam.';
      default:
        return '...';
    }
  }

  List<String> _getHistoryTimeline(String cityName) {
    switch (cityName) {
      case 'Hà Nội':
        return [
          '1010: Dời đô về Thăng Long',
          '1802: Tên “Hà Nội” xuất hiện',
          '1902–1945: Thủ phủ Đông Dương (thuộc địa Pháp)',
          '1945: Tuyên ngôn Độc lập',
          '1954: Giải phóng Thủ đô',
          '1976: Thủ đô nước CHXHCN Việt Nam',
        ];
      case 'TP. Hồ Chí Minh':
        return [
          '1698: Lập dinh Trấn Biên – Gia Định',
          '1862: Thủ phủ Nam Kỳ (thuộc địa Pháp)',
          '1954–1975: Thủ đô VNCH (Sài Gòn)',
          '30/4/1975: Sài Gòn giải phóng',
          '1976: Đổi tên TP. Hồ Chí Minh',
        ];
      case 'Đà Nẵng':
        return [
          '1858: Liên quân Pháp – Tây Ban Nha đổ bộ',
          '1888: Trở thành nhượng địa Tourane',
          '1954: Gia tăng vai trò hậu cần miền Trung',
          'Hiện đại: Đô thị trực thuộc TW',
        ];
      case 'Hải Phòng':
        return [
          'Cai Bèo (4.000–6.000 năm): Dấu tích tiền sử',
          'Thời phong kiến: Cửa biển – phòng thủ Bạch Đằng',
          '1888: Trở thành thành phố của Đông Dương thuộc Pháp',
          '1954–1975: Cửa ngõ hàng hải miền Bắc',
        ];
      case 'Cần Thơ':
        return [
          '1739: Hình thành vùng đất Trấn Giang',
          'Thế kỷ XIX–XX: Trung tâm sông nước miền Tây',
          '1966: Đại học Cần Thơ',
          'Hiện đại: TP trực thuộc TW vùng ĐBSCL',
        ];
      default:
        return ['...'];
    }
  }

  List<String> _getHistoryArticle(String cityName) {
    switch (cityName) {
      case 'Hà Nội':
        return [
          'Khởi nguồn của vùng đất Hà Nội gắn với trung tâm cổ Cổ Loa và các làng cổ dọc sông Hồng. Năm 1010, Lý Công Uẩn dời đô về Thăng Long, mở đầu thời kỳ phát triển rực rỡ của kinh đô với thành quách – cung điện – văn miếu.',
          'Trong thời thuộc địa, Hà Nội trở thành thủ phủ Liên bang Đông Dương, quy hoạch kiểu châu Âu xen kẽ khu phố cổ truyền thống. Sau Cách mạng Tháng Tám 1945 và các mốc 1954, 1976, Hà Nội khẳng định vai trò thủ đô của đất nước thống nhất.',
          'Thập niên gần đây, Hà Nội mở rộng địa giới (2008) và phát triển nhanh về hạ tầng, song vẫn bảo tồn di sản nghìn năm như Hoàng thành Thăng Long, Văn Miếu – Quốc Tử Giám.',
        ];
      case 'TP. Hồ Chí Minh':
        return [
          'Vùng đất Sài Gòn – Gia Định vốn thuộc cư dân Khmer trước khi người Việt tiến xuống phương Nam (thế kỷ XVII). Năm 1698, chính quyền chúa Nguyễn thiết lập bộ máy hành chính, đặt nền cho quá trình đô thị hóa.',
          'Thời Pháp thuộc, Sài Gòn là thủ phủ Nam Kỳ, phát triển hạ tầng cảng biển – đường sắt – kiến trúc thuộc địa. Giai đoạn 1954–1975, Sài Gòn trở thành trung tâm chính trị – kinh tế miền Nam.',
          'Ngày 30/4/1975 đánh dấu bước ngoặt lịch sử. Năm 1976, thành phố được đổi tên thành TP. Hồ Chí Minh; thời kỳ Đổi mới (từ 1986) đưa thành phố trở lại vị trí đầu tàu kinh tế.',
        ];
      case 'Đà Nẵng':
        return [
          'Đà Nẵng xuất hiện sớm như một cửa biển quan trọng của miền Trung. Năm 1858, liên quân Pháp – Tây Ban Nha nổ phát súng đầu tiên tại đây.',
          'Cuối thế kỷ XIX, Đà Nẵng (Tourane) là nhượng địa do Toàn quyền Đông Dương quản lý, cảng biển và công trình đô thị dần hình thành.',
          'Sau 1954, vị trí chiến lược khiến Đà Nẵng trở thành đầu mối quân sự – hậu cần; thời hiện đại, thành phố chuyển mình mạnh mẽ về hạ tầng, du lịch và công nghiệp dịch vụ.',
        ];
      case 'Hải Phòng':
        return [
          'Khu vực Hải Phòng ghi nhận di tồn văn hoá từ rất sớm (Cái Bèo – Hạ Long, Tràng Kênh…). Vị trí cửa ngõ biển giúp vùng đất này đóng vai trò then chốt qua các chiến thắng Bạch Đằng.',
          'Năm 1888, chính quyền Pháp thiết lập Hải Phòng là một trong những thành phố trọng yếu của Đông Dương, phát triển cảng biển – công nghiệp.',
          'Trong thời kỳ hiện đại, Hải Phòng là cửa ngõ hàng hải miền Bắc, đồng thời phát triển du lịch biển – đảo (Đồ Sơn, Cát Bà) và các khu công nghiệp, logistics.',
        ];
      case 'Cần Thơ':
        return [
          'Đất Cần Thơ (Trấn Giang) hình thành rõ nét từ năm 1739 trong tiến trình khai phá phương Nam. Môi trường sông nước tạo nên lối sống – kinh tế chợ nổi đặc trưng.',
          'Trong giai đoạn cận – hiện đại, Cần Thơ phát triển giáo dục, thương mại nông sản, hệ thống kênh rạch – bến bãi. Từ sau Đổi mới, thành phố trở thành trung tâm vùng Đồng bằng sông Cửu Long.',
          'Ngày nay, Cần Thơ giữ vai trò hạt nhân liên kết vùng, đồng thời bảo tồn văn hoá miệt vườn và chợ nổi Cái Răng.',
        ];
      default:
        return ['...', '...', '...'];
    }
  }

  List<String> _getHistorySources(String cityName) {
    // Đưa ra vài link để người đọc "tham khảo nhanh" (không bắt buộc)
    switch (cityName) {
      case 'Hà Nội':
        return [
          'https://www.britannica.com/place/Hanoi',
          'https://en.wikipedia.org/wiki/Hanoi',
        ];
      case 'TP. Hồ Chí Minh':
        return [
          'https://www.britannica.com/place/Ho-Chi-Minh-City',
          'https://en.wikipedia.org/wiki/Ho_Chi_Minh_City',
        ];
      case 'Đà Nẵng':
        return [
          'https://www.britannica.com/place/Da-Nang',
          'https://en.wikipedia.org/wiki/Da_Nang',
        ];
      case 'Hải Phòng':
        return [
          'https://heza.gov.vn/en/lich-su-hinh-thanh/',
          'https://en.wikipedia.org/wiki/Haiphong',
        ];
      case 'Cần Thơ':
        return [
          'https://www.britannica.com/place/Can-Tho',
          'https://canthotourism.vn/en/history',
        ];
      default:
        return ['https://vi.wikipedia.org/'];
    }
  }
}
