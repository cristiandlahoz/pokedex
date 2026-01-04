import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app.dart';
import '../../../domain/entities/pokemon_move.dart';
import '../../../domain/value_objects/game_version.dart';
import '../../utils/type_colors.dart';

enum MoveSortColumn {
  name,
  level,
  power,
  accuracy,
  pp,
}

class MovesSection extends StatefulWidget {
  final List<PokemonMove> moves;
  final GameVersion? selectedGameVersion;

  const MovesSection({
    super.key,
    required this.moves,
    this.selectedGameVersion,
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

  String _normalizeVersionName(String? name) {
    if (name == null) return '';
    return name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  List<PokemonMove> get _filteredAndSortedMoves {
    var filtered = widget.moves;

    if (widget.selectedGameVersion != null) {
      final normalizedSelected = _normalizeVersionName(widget.selectedGameVersion!.name);
      filtered = filtered
          .where((move) => _normalizeVersionName(move.versionGroup) == normalizedSelected)
          .toList();
    }

    if (_selectedLearnMethod != null) {
      filtered = filtered
          .where((move) => move.learnMethod == _selectedLearnMethod)
          .toList();
    }

    final sorted = List<PokemonMove>.from(filtered);

    switch (_sortColumn) {
      case MoveSortColumn.name:
        sorted.sort((a, b) => _sortAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case MoveSortColumn.level:
        sorted.sort((a, b) {
          if (a.level == null && b.level == null) return 0;
          if (a.level == null) return 1;
          if (b.level == null) return -1;
          return _sortAscending
              ? a.level!.compareTo(b.level!)
              : b.level!.compareTo(a.level!);
        });
        break;
      case MoveSortColumn.power:
        sorted.sort((a, b) {
          if (a.power == null && b.power == null) return 0;
          if (a.power == null) return 1;
          if (b.power == null) return -1;
          return _sortAscending
              ? a.power!.compareTo(b.power!)
              : b.power!.compareTo(a.power!);
        });
        break;
      case MoveSortColumn.accuracy:
        sorted.sort((a, b) {
          if (a.accuracy == null && b.accuracy == null) return 0;
          if (a.accuracy == null) return 1;
          if (b.accuracy == null) return -1;
          return _sortAscending
              ? a.accuracy!.compareTo(b.accuracy!)
              : b.accuracy!.compareTo(a.accuracy!);
        });
        break;
      case MoveSortColumn.pp:
        sorted.sort((a, b) {
          if (a.pp == null && b.pp == null) return 0;
          if (a.pp == null) return 1;
          if (b.pp == null) return -1;
          return _sortAscending
              ? a.pp!.compareTo(b.pp!)
              : b.pp!.compareTo(a.pp!);
        });
        break;
    }

    return sorted;
  }

  List<String> get _availableLearnMethods {
    var movesToCheck = widget.moves;

    if (widget.selectedGameVersion != null) {
      final normalizedSelected = _normalizeVersionName(widget.selectedGameVersion!.name);
      movesToCheck = movesToCheck
          .where((move) => _normalizeVersionName(move.versionGroup) == normalizedSelected)
          .toList();
    }

    final methods = movesToCheck
        .where((move) => move.learnMethod != null)
        .map((move) => move.learnMethod!)
        .toSet()
        .toList();
    
    methods.sort();
    
    final order = ['level-up', 'machine', 'egg', 'tutor'];
    methods.sort((a, b) {
      final indexA = order.indexOf(a);
      final indexB = order.indexOf(b);
      if (indexA != -1 && indexB != -1) {
        return indexA.compareTo(indexB);
      }
      if (indexA != -1) return -1;
      if (indexB != -1) return 1;
      return a.compareTo(b);
    });
    
    return methods;
  }

  String _formatName(String name) {
    return name
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getLearnMethodLabel(String method) {
    switch (method) {
      case 'level-up':
        return 'Level up';
      case 'machine':
        return 'TM/HM';
      case 'egg':
        return 'Eggs';
      case 'tutor':
        return 'Tutor';
      default:
        return _formatName(method);
    }
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
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.shade300, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Moves list',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 8),
          const Text(
            'You can sort the moves by tapping on the header of each column.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: methods.map((method) {
          final isSelected = _selectedLearnMethod == method;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getLearnMethodLabel(method)),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedLearnMethod = method;
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.orange.shade300,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
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
          Expanded(
            flex: 1,
            child: _buildHeaderCell('PP', MoveSortColumn.pp),
          ),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.black : Colors.grey.shade700,
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
          Expanded(
            flex: 3,
            child: _buildMoveNameCell(move),
          ),
          Expanded(
            flex: 1,
            child: _buildLevelCell(move),
          ),
          Expanded(
            flex: 1,
            child: _buildStatCell(move.power?.toString() ?? '-'),
          ),
          Expanded(
            flex: 1,
            child: _buildStatCell(move.accuracy?.toString() ?? '-'),
          ),
          Expanded(
            flex: 1,
            child: _buildStatCell(move.pp?.toString() ?? '-'),
          ),
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (move.type != null) _buildTypeIcon(move.type!),
          ],
        ),
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
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
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
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatCell(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
