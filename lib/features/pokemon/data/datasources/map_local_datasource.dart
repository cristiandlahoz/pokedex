import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../dtos/region_map_dto.dart';

@lazySingleton
class MapLocalDataSource {
  final Map<String, RegionMapDto> _cache = {};

  Future<RegionMapDto> loadRegionMap(String regionName) async {
    final cacheKey = regionName.toLowerCase();

    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final jsonString = await rootBundle.loadString(
        'assets/maps/coords/$cacheKey.json',
      );
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final dto = RegionMapDto.fromJson(json);

      _cache[cacheKey] = dto;
      return dto;
    } catch (e) {
      throw CacheException('Failed to load map for region: $regionName');
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
