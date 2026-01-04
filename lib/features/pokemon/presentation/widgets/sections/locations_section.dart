import 'package:flutter/material.dart';

import '../../../../../core/theme/tokens.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../bloc/locations_state.dart';
import '../../../domain/entities/pokemon_location.dart';
import 'locations_map_viewer.dart';

class LocationsSection extends StatefulWidget {
  final LocationsSuccess state;
  final Color typeColor;

  const LocationsSection({
    super.key,
    required this.state,
    required this.typeColor,
  });

  @override
  State<LocationsSection> createState() => _LocationsSectionState();
}

class _LocationsSectionState extends State<LocationsSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.state.locations.isEmpty) {
      return const SizedBox.shrink();
    }

    final spacing = ResponsiveUtils.getSpacingMedium(context);

    return Column(
      children: [
        _buildSectionButton('Locations'),
        SizedBox(height: spacing),
        _buildLocationsList(),
        if (widget.state.regionMaps.isNotEmpty) ...[
          SizedBox(height: spacing),
          _buildSectionButton('Locations map (${widget.state.regionMaps.length})'),
          SizedBox(height: spacing),
          ...widget.state.regionMaps.map((regionMap) => Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: LocationsMapViewer(
                  regionMap: regionMap,
                  typeColor: widget.typeColor,
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildSectionButton(String text) {
    final fontSize = ResponsiveUtils.getFontSizeMedium(context);
    final horizontalPadding = ResponsiveUtils.getWidthPercentage(context, 0.08);
    final verticalPadding = ResponsiveUtils.getHeightPercentage(context, 0.012);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: widget.typeColor, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: widget.typeColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationsList() {
    final locationsForVersion = widget.state.locationsForSelectedVersion;

    if (locationsForVersion.isEmpty) {
      final padding = ResponsiveUtils.getSpacingMedium(context);
      final fontSize = ResponsiveUtils.getFontSizeMedium(context);

      return Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          'No locations available for this pokemon game version',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: fontSize,
          ),
        ),
      );
    }

    final uniqueRegions = locationsForVersion
        .map((loc) => loc.locationName.split('-').first)
        .toSet()
        .toList();

    final spacing = ResponsiveUtils.getSpacingSmall(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...uniqueRegions.map((region) => Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: _RegionCard(
                region: region,
                locations: locationsForVersion
                    .where((loc) => loc.locationName.startsWith(region))
                    .toList(),
                typeColor: widget.typeColor,
              ),
            )),
      ],
    );
  }
}

class _RegionCard extends StatefulWidget {
  final String region;
  final List<PokemonLocation> locations;
  final Color typeColor;

  const _RegionCard({
    required this.region,
    required this.locations,
    required this.typeColor,
  });

  @override
  State<_RegionCard> createState() => _RegionCardState();
}

class _RegionCardState extends State<_RegionCard> {
  bool _isExpanded = true;

  List<PokemonLocation> _getUniqueLocations() {
    final Map<String, PokemonLocation> uniqueMap = {};
    
    for (final location in widget.locations) {
      final key = '${location.areaName}_${location.minLevel}_${location.maxLevel}';
      if (!uniqueMap.containsKey(key)) {
        uniqueMap[key] = location;
      }
    }
    
    return uniqueMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final regionName = widget.region[0].toUpperCase() + widget.region.substring(1);
    final uniqueLocations = _getUniqueLocations();

    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);
    final padding = ResponsiveUtils.getSpacingMedium(context);
    final fontSize = ResponsiveUtils.getFontSizeMedium(context);
    
    return Container(
      decoration: BoxDecoration(
        color: widget.typeColor.withValues(alpha: DesignTokens.opacityLight),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '$regionName (${uniqueLocations.length})',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: widget.typeColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: widget.typeColor,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(padding, 0, padding, padding),
              child: Column(
                children: uniqueLocations
                    .map((location) => _buildLocationItem(location))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(PokemonLocation location) {
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);
    final padding = ResponsiveUtils.getSpacingMedium(context);
    final spacing = ResponsiveUtils.getSpacingSmall(context);
    final fontSize = ResponsiveUtils.getFontSizeMedium(context);
    final fontSizeSmall = ResponsiveUtils.getFontSizeSmall(context);

    return Container(
      margin: EdgeInsets.only(bottom: spacing),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location.areaName.replaceAll('-', ' '),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          if (location.minLevel > 0 || location.maxLevel > 0) ...[
            SizedBox(height: spacing * 0.5),
            Text(
              'Lvl ${location.minLevel}-${location.maxLevel}',
              style: TextStyle(
                fontSize: fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: widget.typeColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
