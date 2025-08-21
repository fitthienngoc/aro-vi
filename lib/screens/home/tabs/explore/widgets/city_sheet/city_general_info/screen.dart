// lib/screens/home/tabs/explore/screens/city_general_info_screen.dart
//
// CityGeneralInfoScreen: Màn hình hiển thị thông tin chung của một thành phố
// Dùng ảnh online (Pexels CDN) + dữ liệu fake cho demo.

import 'package:flutter/material.dart';
import 'package:my_app/utils/cities.dart';

class CityGeneralInfoScreen extends StatelessWidget {
  final City city;

  const CityGeneralInfoScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông tin về ${city.name}'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đại diện thành phố (online)
            _buildCityImage(city),

            // Thông tin tổng quan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Tổng quan'),
                  _buildGeneralInfo(city),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Điểm nổi bật'),
                  Text(
                    _getCityHighlights(city.name),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Món đặc trưng'),
                  Text(
                    _getCitySignatureFoods(city.name),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Vị trí địa lý'),
                  _buildLocationInfo(city),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Kinh tế'),
                  _buildEconomyInfo(city),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Dân số'),
                  _buildPopulationInfo(city),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Khí hậu'),
                  _buildClimateInfo(city),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Giao thông'),
                  _buildTransportationInfo(city),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mở bản đồ chi tiết của thành phố (demo)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mở bản đồ chi tiết của ${city.name}')),
          );
        },
        child: const Icon(Icons.map),
        tooltip: 'Xem bản đồ',
      ),
    );
  }

  // ===== ẢNH THÀNH PHỐ (ONLINE) =====

  // Map tên TP -> URL ảnh Pexels CDN
  // Bạn có thể thay link nếu muốn ảnh khác, chỉ cần giữ đúng pattern CDN.
  static const Map<String, String> _cityImageUrlMap = {
    // Hà Nội (West Lake skyline, đêm)
    'Hà Nội':
        'https://images.pexels.com/photos/24768592/pexels-photo-24768592.jpeg?auto=compress&cs=tinysrgb&w=1200',
    // TP.HCM (skyline ban đêm, Landmark 81)
    'TP. Hồ Chí Minh':
        'https://images.pexels.com/photos/31910167/pexels-photo-31910167.jpeg?auto=compress&cs=tinysrgb&w=1200',
    // Đà Nẵng (Cầu Rồng)
    'Đà Nẵng':
        'https://images.pexels.com/photos/32015496/pexels-photo-32015496.jpeg?auto=compress&cs=tinysrgb&w=1200',
    // Hải Phòng (Cát Bà / vịnh Lan Hạ)
    'Hải Phòng':
        'https://images.pexels.com/photos/6348812/pexels-photo-6348812.jpeg?auto=compress&cs=tinysrgb&w=1200',
    // Cần Thơ (Chợ nổi Cái Răng)
    'Cần Thơ':
        'https://images.pexels.com/photos/31170208/pexels-photo-31170208.jpeg?auto=compress&cs=tinysrgb&w=1200',
  };

  // URL fallback chung (cảnh Việt Nam tổng quát nếu TP chưa có ảnh)
  static const String _fallbackCityImageUrl =
      'https://images.pexels.com/photos/18893911/pexels-photo-18893911.jpeg?auto=compress&cs=tinysrgb&w=1200';

  // Widget hiển thị ảnh đại diện của thành phố (network)
  Widget _buildCityImage(City city) {
    final url = _getCityImageUrl(city.name);

    return Stack(
      children: [
        // Ảnh thành phố (online)
        SizedBox(
          height: 220,
          width: double.infinity,
          child: FadeInImage.assetNetwork(
            placeholder:
                'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png', // nên có 1 ảnh nhỏ
            image: url,
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) {
              // Fallback nếu URL lỗi
              return Image.network(_fallbackCityImageUrl, fit: BoxFit.cover);
            },
          ),
        ),

        // Gradient overlay để text dễ đọc
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

        // Caption: tên TP + toạ độ
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
                  const Icon(Icons.place, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '(${city.latLng.latitude.toStringAsFixed(4)}, ${city.latLng.longitude.toStringAsFixed(4)})',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getCityImageUrl(String cityName) {
    return _cityImageUrlMap[cityName] ?? _fallbackCityImageUrl;
  }

  // ===== UI Helpers =====

  Widget _buildSectionTitle(String title) {
    return Padding(
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
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  // ===== DỮ LIỆU FAKE =====
  // Trong thực tế sẽ lấy từ API/DB. Ở đây chỉ fake để demo UI.

  Widget _buildGeneralInfo(City city) {
    final overview = _getCityOverview(city.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(overview, style: const TextStyle(fontSize: 16, height: 1.5)),
        const SizedBox(height: 16),
        _buildInfoRow('Tên gọi khác', _getCityAlternateNames(city.name)),
        _buildInfoRow('Diện tích', _getCityArea(city.name)),
        _buildInfoRow('Thành lập', _getCityFoundingDate(city.name)),
        _buildInfoRow('Mã hành chính', _getCityAdminCode(city.name)),
      ],
    );
  }

  Widget _buildLocationInfo(City city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getCityLocationDescription(city.name),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Vùng miền', _getCityRegion(city.name)),
        _buildInfoRow('Giáp ranh', _getCityBorders(city.name)),
        _buildInfoRow('Địa hình', _getCityTerrain(city.name)),
      ],
    );
  }

  Widget _buildEconomyInfo(City city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getCityEconomyDescription(city.name),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Ngành chủ lực', _getCityMainIndustries(city.name)),
        _buildInfoRow('GDP', _getCityGDP(city.name)),
        _buildInfoRow('Thu nhập bình quân', _getCityAverageIncome(city.name)),
      ],
    );
  }

  Widget _buildPopulationInfo(City city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Dân số', _getCityPopulation(city.name)),
        _buildInfoRow('Mật độ', _getCityPopulationDensity(city.name)),
        _buildInfoRow('Dân tộc', _getCityEthnicGroups(city.name)),
      ],
    );
  }

  Widget _buildClimateInfo(City city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getCityClimateDescription(city.name),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildInfoRow(
          'Nhiệt độ trung bình',
          _getCityAverageTemperature(city.name),
        ),
        _buildInfoRow('Lượng mưa', _getCityRainfall(city.name)),
        _buildInfoRow(
          'Mùa du lịch lý tưởng',
          _getCityBestTravelSeason(city.name),
        ),
      ],
    );
  }

  Widget _buildTransportationInfo(City city) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getCityTransportationDescription(city.name),
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        _buildInfoRow('Sân bay', _getCityAirports(city.name)),
        _buildInfoRow('Ga tàu', _getCityTrainStations(city.name)),
        _buildInfoRow('Bến xe', _getCityBusStations(city.name)),
      ],
    );
  }

  // ===== Fake data helpers =====

  String _getCityOverview(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Hà Nội là thủ đô và một trong hai đô thị loại đặc biệt của Việt Nam, trung tâm chính trị – văn hóa – giáo dục – khoa học của cả nước với lịch sử hơn 1000 năm.';
    } else if (cityName == 'TP. Hồ Chí Minh') {
      return 'TP.HCM (Sài Gòn) là thành phố lớn nhất Việt Nam, đầu tàu kinh tế, trung tâm thương mại – dịch vụ – tài chính – công nghệ.';
    } else if (cityName == 'Đà Nẵng') {
      return 'Đà Nẵng là trung tâm kinh tế – du lịch của miền Trung, sở hữu bờ biển dài, hạ tầng hiện đại và nhiều cây cầu biểu tượng.';
    } else if (cityName == 'Hải Phòng') {
      return 'Hải Phòng là thành phố cảng lớn ở miền Bắc, cửa ngõ biển quan trọng với công nghiệp, logistics và du lịch biển – đảo.';
    } else if (cityName == 'Cần Thơ') {
      return 'Cần Thơ là trung tâm vùng Đồng bằng sông Cửu Long, nổi tiếng với chợ nổi, miệt vườn và mạng lưới sông ngòi.';
    }
    return 'Thành phố $cityName có nhiều điểm nổi bật về văn hóa, lịch sử và kinh tế.';
  }

  String _getCityHighlights(String cityName) {
    switch (cityName) {
      case 'Hà Nội':
        return 'Phố cổ – Hồ Gươm – Văn Miếu, mùa thu lá vàng, cà phê trứng, phố đi bộ cuối tuần.';
      case 'TP. Hồ Chí Minh':
        return 'Landmark 81, phố đi bộ Nguyễn Huệ, chợ Bến Thành, ẩm thực đêm, sông Sài Gòn về đêm.';
      case 'Đà Nẵng':
        return 'Cầu Rồng phun lửa, bán đảo Sơn Trà, Ngũ Hành Sơn, biển Mỹ Khê, lễ hội pháo hoa.';
      case 'Hải Phòng':
        return 'Đồ Sơn – Cát Bà, hải sản tươi, cảng biển nhộn nhịp.';
      case 'Cần Thơ':
        return 'Chợ nổi Cái Răng, bến Ninh Kiều, vườn trái cây, du thuyền sông Hậu.';
      default:
        return 'Trung tâm hành chính, điểm check-in nổi tiếng, khu ẩm thực địa phương.';
    }
  }

  String _getCitySignatureFoods(String cityName) {
    switch (cityName) {
      case 'Hà Nội':
        return 'Phở, bún chả, bún thang, chả cá Lã Vọng, cốm làng Vòng.';
      case 'TP. Hồ Chí Minh':
        return 'Cơm tấm, hủ tiếu, bánh mì Sài Gòn, phá lấu, ốc đêm.';
      case 'Đà Nẵng':
        return 'Mì Quảng, bún chả cá, bánh tráng cuốn thịt heo, ốc hút.';
      case 'Hải Phòng':
        return 'Bánh đa cua, nem cua bể, bún cá cay, giá bể xào.';
      case 'Cần Thơ':
        return 'Bánh cống, lẩu mắm, cá lóc nướng trui, chuối nếp nướng.';
      default:
        return 'Đặc sản địa phương, món nước và món nướng đường phố.';
    }
  }

  String _getCityAlternateNames(String cityName) {
    if (cityName == 'Hà Nội') return 'Thăng Long, Đông Đô, Đông Quan';
    if (cityName == 'TP. Hồ Chí Minh') return 'Sài Gòn, Gia Định, Prey Nokor';
    if (cityName == 'Đà Nẵng') return 'Tourane, Cửa Hàn';
    if (cityName == 'Hải Phòng') return 'Hải Tần, Dương Kinh';
    if (cityName == 'Cần Thơ') return 'Tây Đô, Trấn Giang';
    return 'Chưa có thông tin';
  }

  String _getCityArea(String cityName) {
    if (cityName == 'Hà Nội') return '3.359,8 km² (ước tính)';
    if (cityName == 'TP. Hồ Chí Minh') return '2.061,2 km² (ước tính)';
    if (cityName == 'Đà Nẵng') return '1.285,4 km² (ước tính)';
    if (cityName == 'Hải Phòng') return '1.561,8 km² (ước tính)';
    if (cityName == 'Cần Thơ') return '1.439,2 km² (ước tính)';
    return 'Khoảng 1.000 km²';
  }

  String _getCityFoundingDate(String cityName) {
    if (cityName == 'Hà Nội') return '1010 (triều Lý)';
    if (cityName == 'TP. Hồ Chí Minh') return '1698 (Gia Định)';
    if (cityName == 'Đà Nẵng') return '1888 (thị xã Tourane)';
    if (cityName == 'Hải Phòng') return '1888 (thị xã Hải Phòng)';
    if (cityName == 'Cần Thơ') return '1739 (Trấn Giang)';
    return 'Chưa rõ';
  }

  String _getCityAdminCode(String cityName) {
    if (cityName == 'Hà Nội') return '01';
    if (cityName == 'TP. Hồ Chí Minh') return '79';
    if (cityName == 'Đà Nẵng') return '48';
    if (cityName == 'Hải Phòng') return '31';
    if (cityName == 'Cần Thơ') return '92';
    return '—';
  }

  String _getCityLocationDescription(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Nằm ở đồng bằng Bắc Bộ, châu thổ sông Hồng; địa hình bằng phẳng, có đồi thấp phía bắc – tây bắc.';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Miền Đông Nam Bộ, giáp Biển Đông qua Cần Giờ; địa hình đồng bằng, cao trung bình ~19m.';
    }
    if (cityName == 'Đà Nẵng') {
      return 'Miền Trung, giáp biển Đông; địa hình đa dạng: núi – đồng bằng – bờ biển dài ~92km.';
    }
    if (cityName == 'Hải Phòng') {
      return 'Hạ lưu sông Cấm, giáp vịnh Bắc Bộ; gồm đồng bằng, đồi thấp và quần đảo ven bờ (Cát Bà).';
    }
    if (cityName == 'Cần Thơ') {
      return 'Trung tâm ĐBSCL, bờ sông Hậu; địa hình bằng phẳng, sông ngòi – kênh rạch chằng chịt.';
    }
    return '$cityName có vị trí thuận lợi cho giao thông và phát triển kinh tế.';
  }

  String _getCityRegion(String cityName) {
    if (cityName == 'Hà Nội') return 'Đồng bằng sông Hồng';
    if (cityName == 'TP. Hồ Chí Minh') return 'Đông Nam Bộ';
    if (cityName == 'Đà Nẵng') return 'Duyên hải Nam Trung Bộ';
    if (cityName == 'Hải Phòng') return 'Đồng bằng sông Hồng';
    if (cityName == 'Cần Thơ') return 'Đồng bằng sông Cửu Long';
    return '—';
  }

  String _getCityBorders(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Bắc Ninh, Hưng Yên (đông); Hòa Bình, Phú Thọ (tây); Vĩnh Phúc, Thái Nguyên (bắc); Hà Nam (nam).';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Bình Dương, Tây Ninh (bắc); Đồng Nai (đông); Long An (tây); Bà Rịa–Vũng Tàu, Biển Đông (đông nam).';
    }
    if (cityName == 'Đà Nẵng') {
      return 'Thừa Thiên Huế (bắc); Quảng Nam (tây & nam); Biển Đông (đông).';
    }
    if (cityName == 'Hải Phòng') {
      return 'Quảng Ninh (đông bắc); Hải Dương (tây); Thái Bình (nam); Vịnh Bắc Bộ (đông).';
    }
    if (cityName == 'Cần Thơ') {
      return 'Hậu Giang (tây & nam); Vĩnh Long (đông bắc); Đồng Tháp (tây bắc); An Giang (tây bắc).';
    }
    return '—';
  }

  String _getCityTerrain(String cityName) {
    if (cityName == 'Hà Nội') return 'Đồng bằng, đồi thấp phía bắc – tây bắc';
    if (cityName == 'TP. Hồ Chí Minh')
      return 'Đồng bằng, vùng trũng – đầm lầy phía nam';
    if (cityName == 'Đà Nẵng') return 'Đồi núi, bán đảo, bãi biển';
    if (cityName == 'Hải Phòng') return 'Đồng bằng, đồi thấp, đảo – bán đảo';
    if (cityName == 'Cần Thơ') return 'Đồng bằng, sông ngòi – kênh rạch';
    return 'Đa dạng';
  }

  String _getCityEconomyDescription(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Trung tâm chính trị – khoa học – giáo dục; kinh tế dịch vụ – công nghiệp – thương mại – du lịch phát triển.';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Đầu tàu kinh tế: công nghiệp – dịch vụ – tài chính – công nghệ, thu hút FDI, hệ sinh thái khởi nghiệp.';
    }
    if (cityName == 'Đà Nẵng') {
      return 'Tăng trưởng dựa trên du lịch – dịch vụ – cảng biển – công nghệ cao, hạ tầng hiện đại.';
    }
    if (cityName == 'Hải Phòng') {
      return 'Cảng biển – logistics – công nghiệp – đóng tàu; thu hút nhiều dự án FDI quy mô lớn.';
    }
    if (cityName == 'Cần Thơ') {
      return 'Nông nghiệp – thủy sản – công nghiệp chế biến – thương mại – du lịch miệt vườn.';
    }
    return '$cityName có cơ cấu kinh tế đa dạng.';
  }

  String _getCityMainIndustries(String cityName) {
    if (cityName == 'Hà Nội')
      return 'Dịch vụ, công nghiệp, xây dựng, nông nghiệp';
    if (cityName == 'TP. Hồ Chí Minh')
      return 'Dịch vụ, công nghiệp, xây dựng, tài chính, du lịch';
    if (cityName == 'Đà Nẵng')
      return 'Du lịch, dịch vụ, công nghiệp, thương mại';
    if (cityName == 'Hải Phòng')
      return 'Cảng biển, logistics, công nghiệp, đóng tàu, thương mại';
    if (cityName == 'Cần Thơ')
      return 'Nông nghiệp, thủy sản, công nghiệp chế biến, thương mại, du lịch';
    return 'Đa dạng';
  }

  String _getCityGDP(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 40 tỷ USD (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 60 tỷ USD (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 4 tỷ USD (fake)';
    if (cityName == 'Hải Phòng') return '≈ 10 tỷ USD (fake)';
    if (cityName == 'Cần Thơ') return '≈ 5 tỷ USD (fake)';
    return '—';
  }

  String _getCityAverageIncome(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 6,5 triệu đồng/tháng (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 7,2 triệu đồng/tháng (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 5,8 triệu đồng/tháng (fake)';
    if (cityName == 'Hải Phòng') return '≈ 5,5 triệu đồng/tháng (fake)';
    if (cityName == 'Cần Thơ') return '≈ 5,2 triệu đồng/tháng (fake)';
    return '—';
  }

  String _getCityPopulation(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 8,3 triệu người (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 9,2 triệu người (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 1,2 triệu người (fake)';
    if (cityName == 'Hải Phòng') return '≈ 2,0 triệu người (fake)';
    if (cityName == 'Cần Thơ') return '≈ 1,4 triệu người (fake)';
    return '—';
  }

  String _getCityPopulationDensity(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 2.400 người/km² (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 4.300 người/km² (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 800 người/km² (fake)';
    if (cityName == 'Hải Phòng') return '≈ 1.280 người/km² (fake)';
    if (cityName == 'Cần Thơ') return '≈ 880 người/km² (fake)';
    return '—';
  }

  String _getCityEthnicGroups(String cityName) {
    if (cityName == 'Hà Nội')
      return 'Kinh (≈98,5%), Mường, Tày, Thái, Nùng, Hoa...';
    if (cityName == 'TP. Hồ Chí Minh')
      return 'Kinh (≈93,5%), Hoa (≈5,8%), Khmer, Chăm...';
    if (cityName == 'Đà Nẵng') return 'Kinh (≈99%), Hoa, Cơ Tu...';
    if (cityName == 'Hải Phòng') return 'Kinh (≈99,5%), Hoa, Tày, Nùng...';
    if (cityName == 'Cần Thơ') return 'Kinh (≈97%), Hoa, Khmer...';
    return 'Đa dạng';
  }

  String _getCityClimateDescription(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Khí hậu nhiệt đới gió mùa ẩm, bốn mùa rõ rệt: hè nóng ẩm mưa nhiều, đông khô lạnh.';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Khí hậu cận xích đạo, hai mùa: mưa (5–11) và khô (12–4); nhiệt độ cao ổn định quanh năm.';
    }
    if (cityName == 'Đà Nẵng') {
      return 'Khí hậu nhiệt đới gió mùa; mùa mưa 9–12, mùa khô 1–8; nhiệt độ trung bình cao.';
    }
    if (cityName == 'Hải Phòng') {
      return 'Nhiệt đới gió mùa ẩm; hè nóng ẩm mưa nhiều, đông lạnh hơn; chịu ảnh hưởng bão từ vịnh Bắc Bộ.';
    }
    if (cityName == 'Cần Thơ') {
      return 'Cận xích đạo; hai mùa mưa – khô rõ rệt; ít chịu bão, nắng ấm quanh năm.';
    }
    return 'Khí hậu đặc trưng vùng miền.';
  }

  String _getCityAverageTemperature(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 23,6°C (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 28°C (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 25,9°C (fake)';
    if (cityName == 'Hải Phòng') return '≈ 23,5°C (fake)';
    if (cityName == 'Cần Thơ') return '≈ 27,5°C (fake)';
    return '—';
  }

  String _getCityRainfall(String cityName) {
    if (cityName == 'Hà Nội') return '≈ 1.800 mm/năm (fake)';
    if (cityName == 'TP. Hồ Chí Minh') return '≈ 1.950 mm/năm (fake)';
    if (cityName == 'Đà Nẵng') return '≈ 2.500 mm/năm (fake)';
    if (cityName == 'Hải Phòng') return '≈ 1.700 mm/năm (fake)';
    if (cityName == 'Cần Thơ') return '≈ 1.600 mm/năm (fake)';
    return '—';
  }

  String _getCityBestTravelSeason(String cityName) {
    if (cityName == 'Hà Nội') return 'Tháng 10–11 và 3–4';
    if (cityName == 'TP. Hồ Chí Minh') return 'Tháng 12–4 (mùa khô)';
    if (cityName == 'Đà Nẵng') return 'Tháng 2–5 và 9–10';
    if (cityName == 'Hải Phòng') return 'Tháng 10–11 và 3–5';
    if (cityName == 'Cần Thơ') return 'Tháng 12–4 (mùa khô)';
    return 'Tuỳ vùng';
  }

  String _getCityTransportationDescription(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Đường bộ – đường sắt – đường thủy – hàng không; đang phát triển metro.';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Mạng lưới đường bộ lớn; đang xây metro, vành đai; kết nối vùng Đông Nam Bộ.';
    }
    if (cityName == 'Đà Nẵng') {
      return 'Có sân bay quốc tế, cảng biển, đường sắt; hạ tầng giao thông đô thị hiện đại.';
    }
    if (cityName == 'Hải Phòng') {
      return 'Cảng biển lớn nhất miền Bắc; sân bay Cát Bi; cao tốc kết nối Hà Nội – Hải Phòng.';
    }
    if (cityName == 'Cần Thơ') {
      return 'Đường bộ – đường thủy – hàng không; mạng lưới sông ngòi thuận lợi vận tải thủy.';
    }
    return 'Hệ thống giao thông đang phát triển.';
  }

  String _getCityAirports(String cityName) {
    if (cityName == 'Hà Nội') return 'Sân bay quốc tế Nội Bài';
    if (cityName == 'TP. Hồ Chí Minh') return 'Sân bay quốc tế Tân Sơn Nhất';
    if (cityName == 'Đà Nẵng') return 'Sân bay quốc tế Đà Nẵng';
    if (cityName == 'Hải Phòng') return 'Sân bay quốc tế Cát Bi';
    if (cityName == 'Cần Thơ') return 'Sân bay quốc tế Cần Thơ';
    return '—';
  }

  String _getCityTrainStations(String cityName) {
    if (cityName == 'Hà Nội') return 'Ga Hà Nội, Ga Giáp Bát, Ga Gia Lâm';
    if (cityName == 'TP. Hồ Chí Minh') return 'Ga Sài Gòn, Ga Bình Triệu';
    if (cityName == 'Đà Nẵng') return 'Ga Đà Nẵng';
    if (cityName == 'Hải Phòng') return 'Ga Hải Phòng';
    if (cityName == 'Cần Thơ') return 'Không có đường sắt';
    return '—';
  }

  String _getCityBusStations(String cityName) {
    if (cityName == 'Hà Nội') {
      return 'Bến xe Mỹ Đình, Giáp Bát, Nước Ngầm, Gia Lâm';
    }
    if (cityName == 'TP. Hồ Chí Minh') {
      return 'Bến xe Miền Đông, Miền Tây, An Sương';
    }
    if (cityName == 'Đà Nẵng') return 'Bến xe trung tâm Đà Nẵng';
    if (cityName == 'Hải Phòng') return 'Bến xe Niệm Nghĩa, Cầu Rào, Lạc Long';
    if (cityName == 'Cần Thơ') return 'Bến xe Cần Thơ, Ô Môn, Hưng Lợi';
    return '—';
  }
}
