import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app.dart';
import '../../../domain/entities/pokemon_move.dart';
import '../../../domain/services/moves_filtering_service.dart';
import '../../../domain/services/moves_sorting_service.dart';
import '../../../domain/value_objects/game_version.dart';
import '../../../domain/value_objects/learn_method.dart';
import '../../utils/type_colors.dart';

class MovesSection extends StatefulWidget {
  final List<PokemonMove> moves;
  final GameVersion? selectedGameVersion;
  final Color? accentColor;
  final MovesSortingService sortingService;
  final MovesFilteringService filteringService;

  const MovesSection({
    super.key,
    required this.moves,
    required this.sortingService,
    required this.filteringService,
    this.selectedGameVersion,
    this.accentColor,
  });

  @override
  State<MovesSection> createState() => _MovesSectionState();
}

class _MovesSectionState extends State<MovesSection> {
  String? _selectedLearnMethod;
  MoveSortColumn _sortColumn = MoveSortColumn.level;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _selectedLearnMethod = 'level-up';
  }

  @override
  void didUpdateWidget(MovesSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedGameVersion != widget.selectedGameVersion) {
      final availableMethods = _availableLearnMethods;
      if (_selectedLearnMethod != null &&
          !availableMethods.contains(_selectedLearnMethod)) {
        setState(() {
          _selectedLearnMethod = availableMethods.isNotEmpty
              ? availableMethods.first
              : null;
        });
      }
    }
  }

  List<PokemonMove> get _filteredAndSortedMoves {
    final filtered = widget.filteringService.applyFilters(
      widget.moves,
      version: widget.selectedGameVersion,
      learnMethod: _selectedLearnMethod,
    );
    return widget.sortingService.sort(filtered, _sortColumn, _sortAscending);
  }

  List<String> get _availableLearnMethods {
    final movesForVersion = widget.filteringService.filterByVersion(
      widget.moves,
      widget.selectedGameVersion,
    );
    return widget.filteringService.getAvailableLearnMethods(movesForVersion);
  }

  String _formatName(String name) {
    return name
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _onSortColumn(MoveSortColumn column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (widget.accentColor ?? Colors.orange).withOpacity(0.5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Moves list',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: widget.accentColor ?? Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 8),
          const Text(
            'You can sort the moves by tapping on the header of each column.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildMovesTable(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final methods = _availableLearnMethods;
    final chipColor = widget.accentColor ?? Colors.orange;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: methods.map((method) {
          final isSelected = _selectedLearnMethod == method;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: ChoiceChip(
              label: Text(LearnMethod.getDisplayName(method)),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedLearnMethod = method;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: chipColor.withOpacity(0.7),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMovesTable() {
    final moves = _filteredAndSortedMoves;

    if (moves.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'There are no moves that can be learnt with this method',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          const Divider(height: 1, thickness: 1),
          ...moves.map((move) => _buildMoveRow(move)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildHeaderCell('Name', MoveSortColumn.name),
          ),
          Expanded(
            flex: 1,
            child: _buildHeaderCell(
              _selectedLearnMethod == 'machine' ? '#' : 'Lvl',
              MoveSortColumn.level,
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildHeaderCell('Pow', MoveSortColumn.power),
          ),
          Expanded(
            flex: 1,
            child: _buildHeaderCell('Acc', MoveSortColumn.accuracy),
          ),
          Expanded(flex: 1, child: _buildHeaderCell('PP', MoveSortColumn.pp)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, MoveSortColumn column) {
    final isActive = _sortColumn == column;
    return GestureDetector(
      onTap: () => _onSortColumn(column),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black : Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isActive)
            Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildMoveRow(PokemonMove move) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildMoveNameCell(move)),
          Expanded(flex: 1, child: _buildLevelCell(move)),
          Expanded(
            flex: 1,
            child: _buildStatCell(move.power?.toString() ?? '-'),
          ),
          Expanded(
            flex: 1,
            child: _buildStatCell(move.accuracy?.toString() ?? '-'),
          ),
          Expanded(flex: 1, child: _buildStatCell(move.pp?.toString() ?? '-')),
        ],
      ),
    );
  }

  Widget _buildMoveNameCell(PokemonMove move) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatName(move.name),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Row(children: [if (move.type != null) _buildTypeIcon(move.type!)]),
      ],
    );
  }

  Widget _buildTypeIcon(String type) {
    final color = TypeColors.getColor(type);
    final iconPath = 'assets/icons/types/${type.toLowerCase()}.svg';

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(4),
      child: SvgPicture.asset(
        iconPath,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildLevelCell(PokemonMove move) {
    String text = '-';

    if (_selectedLearnMethod == 'machine' && move.machineNumber != null) {
      text = move.machineNumber.toString().padLeft(2, '0');
    } else if (move.level != null) {
      text = move.level.toString();
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatCell(String value) {
    return Text(
      value,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }
}
