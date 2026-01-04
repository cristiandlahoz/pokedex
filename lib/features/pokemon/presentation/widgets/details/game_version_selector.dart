import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/tokens.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../bloc/details_bloc.dart';
import '../../../bloc/details_event.dart';
import '../../../bloc/details_state.dart';
import '../../../bloc/game_version_bloc.dart';
import '../../../bloc/game_version_event.dart';
import '../../../bloc/game_version_state.dart';
import '../../../bloc/locations_bloc.dart';
import '../../../bloc/locations_event.dart';
import '../../../domain/value_objects/game_version.dart';

class GameVersionSelector extends StatefulWidget {
  const GameVersionSelector({super.key});

  @override
  State<GameVersionSelector> createState() => _GameVersionSelectorState();
}

class _GameVersionSelectorState extends State<GameVersionSelector> {
  @override
  void initState() {
    super.initState();
    _loadGameVersions();
  }

  void _loadGameVersions() {
    final detailsState = context.read<DetailsBloc>().state;
    if (detailsState is DetailsSuccess) {
      final versions = detailsState.allGameVersions;
      context.read<GameVersionBloc>().add(
        GameVersionsLoaded(
          versions: versions,
          initialVersion: detailsState.selectedGameVersion,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalMargin = ResponsiveUtils.getWidthPercentage(context, 0.08);
    final verticalMargin = ResponsiveUtils.getHeightPercentage(context, 0.005);
    final horizontalPadding = ResponsiveUtils.getSpacingMedium(context);
    final verticalPadding = ResponsiveUtils.getHeightPercentage(context, 0.005);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context) * 0.8;
    final fontSize = ResponsiveUtils.getFontSizeSmall(context) * 1.1;
    final iconSize = ResponsiveUtils.getWidthPercentage(context, 0.05);
    final dotSize = ResponsiveUtils.getWidthPercentage(context, 0.018);
    final dotMargin = ResponsiveUtils.getSpacingSmall(context);
    final shadowBlur = ResponsiveUtils.getWidthPercentage(context, 0.01);
    final shadowOffset = ResponsiveUtils.getHeightPercentage(context, 0.001);

    return BlocBuilder<GameVersionBloc, GameVersionState>(
      builder: (context, versionState) {
        if (versionState is! GameVersionSelectionState) {
          return const SizedBox.shrink();
        }

        final selectedVersion = versionState.selectedVersion;
        final allVersions = versionState.availableVersions;

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin,
            vertical: verticalMargin,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: const Color(0xFF4CAF50),
              width: DesignTokens.borderWidthThick,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: DesignTokens.opacityLight * 0.6,
                ),
                blurRadius: shadowBlur,
                offset: Offset(0, shadowOffset),
              ),
            ],
          ),
          child: DropdownButton<GameVersion>(
            value: selectedVersion,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade600,
              size: iconSize,
            ),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            menuMaxHeight: DesignTokens.dropdownMenuMaxHeight,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
            selectedItemBuilder: (context) {
              return allVersions.map((version) {
                return Row(
                  children: [
                    Container(
                      width: dotSize,
                      height: dotSize,
                      margin: EdgeInsets.only(right: dotMargin),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        version.displayName,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
            items: allVersions.map((version) {
              return DropdownMenuItem(
                value: version,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getSpacingSmall(context) * 0.4,
                    horizontal: ResponsiveUtils.getSpacingSmall(context) * 0.15,
                  ),
                  child: Text(
                    version.displayName,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<GameVersionBloc>().add(
                  GameVersionChanged(version: value),
                );
                context.read<DetailsBloc>().add(
                  DetailsGameVersionSelected(version: value),
                );
                context.read<LocationsBloc>().add(
                  GameVersionSelected(version: value),
                );
              }
            },
          ),
        );
      },
    );
  }
}
