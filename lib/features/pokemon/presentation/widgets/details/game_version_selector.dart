import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/tokens.dart';
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
      context.read<GameVersionBloc>().add(GameVersionsLoaded(
            versions: versions,
            initialVersion: detailsState.selectedGameVersion,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameVersionBloc, GameVersionState>(
      builder: (context, versionState) {
        if (versionState is! GameVersionSelectionState) {
          return const SizedBox.shrink();
        }

        final selectedVersion = versionState.selectedVersion;
        final allVersions = versionState.availableVersions;

        return Column(
          children: [
            Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF4CAF50),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: DesignTokens.dropdownShadowOpacity),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButton<GameVersion>(
                    value: selectedVersion,
                    isExpanded: true,
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 28),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    menuMaxHeight: DesignTokens.dropdownMenuMaxHeight,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                      letterSpacing: 0.2,
                    ),
                    selectedItemBuilder: (context) {
                      return allVersions.map((version) {
                        return Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple.shade700,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                version.displayName,
                                style: TextStyle(
                                  fontSize: 15,
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
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Text(
                            version.displayName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade800,
                              letterSpacing: 0.2,
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
              ),
            ],
          );
        },
      );
    }
  }
