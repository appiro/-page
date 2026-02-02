import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise.dart';
import '../models/exercise_measure_type.dart';
import '../providers/master_provider.dart';
import '../providers/favorite_exercise_provider.dart';
import '../utils/constants.dart';
import '../utils/default_data_helper.dart';

class ExercisePickerScreen extends StatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  State<ExercisePickerScreen> createState() => _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends State<ExercisePickerScreen> {
  String _searchQuery = '';
  String? _selectedBodyPartId;
  bool _showFavoritesOnly = false;

  void _showAddExerciseDialog(MasterProvider masterProvider) {
    final nameController = TextEditingController();
    String? selectedBodyPartId =
        _selectedBodyPartId ??
        (masterProvider.bodyParts.isNotEmpty
            ? masterProvider.bodyParts.first.id
            : null);
    ExerciseMeasureType selectedMeasureType = ExerciseMeasureType.weightReps;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('新しい種目を追加'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: '種目名',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedBodyPartId,
                decoration: const InputDecoration(
                  labelText: '種類',
                  border: OutlineInputBorder(),
                ),
                items: masterProvider.bodyParts.map((bp) {
                  return DropdownMenuItem(value: bp.id, child: Text(bp.name));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBodyPartId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ExerciseMeasureType>(
                value: selectedMeasureType,
                decoration: const InputDecoration(
                  labelText: '計測タイプ',
                  border: OutlineInputBorder(),
                ),
                items: ExerciseMeasureType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedMeasureType = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('種目名を入力してください')));
                  return;
                }

                if (selectedBodyPartId == null) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('種類を選択してください')));
                  return;
                }

                try {
                  await masterProvider.createExercise(
                    nameController.text.trim(),
                    selectedBodyPartId!,
                    measureType: selectedMeasureType,
                  );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('種目を追加しました')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('エラー: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('追加'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteExercise(MasterProvider provider, Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('種目を削除'),
        content: Text('${exercise.name} を一覧から削除しますか？\n(過去の記録は保持されます)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await provider.archiveExercise(exercise.id);
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('種目を削除しました')));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('エラー: ${e.toString()}')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  void _showEditExerciseDialog(Exercise exercise) {
    final nameController = TextEditingController(text: exercise.name);
    String selectedBodyPartId = exercise.bodyPartId;
    ExerciseMeasureType selectedMeasureType = exercise.measureType;

    showDialog(
      context: context,
      builder: (context) {
        // Access provider to get body parts list
        final masterProvider = context.read<MasterProvider>();
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('種目を編集'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '種目名',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedBodyPartId,
                  decoration: const InputDecoration(
                    labelText: '種類',
                    border: OutlineInputBorder(),
                  ),
                  items: masterProvider.bodyParts.map((bp) {
                    return DropdownMenuItem(value: bp.id, child: Text(bp.name));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedBodyPartId = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ExerciseMeasureType>(
                  value: selectedMeasureType,
                  decoration: const InputDecoration(
                    labelText: '計測タイプ',
                    border: OutlineInputBorder(),
                  ),
                  items: ExerciseMeasureType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMeasureType = value;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newName = nameController.text.trim();
                  if (newName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('種目名を入力してください')),
                    );
                    return;
                  }

                  Navigator.pop(context);
                  try {
                    await masterProvider.updateExercise(
                      exercise.copyWith(
                        name: newName,
                        bodyPartId: selectedBodyPartId,
                        measureType: selectedMeasureType,
                      ),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('種目を更新しました')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('エラー: $e')));
                    }
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExerciseOptions(Exercise exercise) {
    final favoriteProvider = context.read<FavoriteExerciseProvider>();
    final isFavorite = favoriteProvider.isFavorite(exercise.id);

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : null,
              ),
              title: Text(isFavorite ? 'お気に入りから削除' : 'お気に入りに追加'),
              onTap: () async {
                Navigator.pop(context);
                await favoriteProvider.toggleFavorite(exercise.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite ? 'お気に入りから削除しました' : 'お気に入りに追加しました',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('編集'),
              onTap: () {
                Navigator.pop(context);
                _showEditExerciseDialog(exercise);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('削除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                final provider = context.read<MasterProvider>();
                _confirmDeleteExercise(provider, exercise);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final masterProvider = context.watch<MasterProvider>();
    final favoriteProvider = context.watch<FavoriteExerciseProvider>();

    // Filter exercises
    List<Exercise> filteredExercises = masterProvider.exercises;

    if (_searchQuery.isNotEmpty) {
      filteredExercises = masterProvider.searchExercises(_searchQuery);
    }

    if (_selectedBodyPartId != null) {
      filteredExercises = filteredExercises
          .where((e) => e.bodyPartId == _selectedBodyPartId)
          .toList();
    }

    // Filter by favorites
    if (_showFavoritesOnly) {
      filteredExercises = filteredExercises
          .where((e) => favoriteProvider.isFavorite(e.id))
          .toList();
    }

    // Sort by name within each category
    filteredExercises.sort((a, b) => a.name.compareTo(b.name));

    // Create grouped exercises with favorites section
    final Map<String, List<Exercise>> groupedExercises = {};

    // First, add favorites section if there are any favorites
    final favoriteExercises = filteredExercises
        .where((e) => favoriteProvider.isFavorite(e.id))
        .toList();

    if (favoriteExercises.isNotEmpty && !_showFavoritesOnly) {
      groupedExercises['_favorites'] = favoriteExercises;
    }

    // Then, group by body part (all exercises, including favorites)
    for (var exercise in filteredExercises) {
      if (!groupedExercises.containsKey(exercise.bodyPartId)) {
        groupedExercises[exercise.bodyPartId] = [];
      }
      groupedExercises[exercise.bodyPartId]!.add(exercise);
    }

    // Get sorted keys: favorites first, then body parts in custom order
    // Custom order: 胸、脚、背中、肩、腕、体幹
    final bodyPartOrder = {
      '胸': 1,
      '脚': 2,
      '足': 2, // Alternative name for legs
      '背中': 3,
      '肩': 4,
      '腕': 5,
      '体幹': 6,
    };

    final sortedKeys = groupedExercises.keys.toList()
      ..sort((a, b) {
        if (a == '_favorites') return -1;
        if (b == '_favorites') return 1;

        // Get body part names
        final bodyPartA = masterProvider.getBodyPart(a);
        final bodyPartB = masterProvider.getBodyPart(b);
        final nameA = bodyPartA?.name ?? '';
        final nameB = bodyPartB?.name ?? '';

        // Get order from map, default to 999 for unknown body parts
        final orderA = bodyPartOrder[nameA] ?? 999;
        final orderB = bodyPartOrder[nameB] ?? 999;

        // Compare by order
        if (orderA != orderB) {
          return orderA.compareTo(orderB);
        }

        // If same order (or both unknown), sort by name
        return nameA.compareTo(nameB);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('種目を選択'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.star : Icons.star_border,
              color: _showFavoritesOnly ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
            tooltip: _showFavoritesOnly ? 'すべて表示' : 'お気に入りのみ',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddExerciseDialog(masterProvider),
            tooltip: '新しい種目を追加',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              decoration: const InputDecoration(
                labelText: '種目を検索',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Body Part Filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              children: [
                FilterChip(
                  label: const Text('すべて'),
                  selected: _selectedBodyPartId == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedBodyPartId = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...masterProvider.bodyParts.map((bp) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(bp.name),
                      selected: _selectedBodyPartId == bp.id,
                      onSelected: (selected) {
                        setState(() {
                          _selectedBodyPartId = selected ? bp.id : null;
                        });
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const Divider(height: 1),

          // Exercise List
          Expanded(
            child: masterProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : groupedExercises.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '種目が見つかりません',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'デバッグ情報:\n'
                            '種類数: ${masterProvider.bodyParts.length}\n'
                            '種目数: ${masterProvider.exercises.length}\n'
                            'フィルター後: ${filteredExercises.length}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: sortedKeys.length,
                    itemBuilder: (context, index) {
                      final bodyPartId = sortedKeys[index];
                      final exercises = groupedExercises[bodyPartId]!;
                      final bodyPart = masterProvider.getBodyPart(bodyPartId);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              children: [
                                if (bodyPartId == '_favorites')
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                if (bodyPartId == '_favorites')
                                  const SizedBox(width: 8),
                                Text(
                                  bodyPartId == '_favorites'
                                      ? 'お気に入り'
                                      : (bodyPart?.name ?? 'Unknown'),
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: bodyPartId == '_favorites'
                                            ? Colors.amber[700]
                                            : AppConstants.primaryColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          ...exercises.map((exercise) {
                            final isDefault = DefaultDataHelper
                                .defaultExerciseNames
                                .contains(exercise.name);
                            final isFavorite = favoriteProvider.isFavorite(
                              exercise.id,
                            );

                            return ListTile(
                              leading: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.star : Icons.star_border,
                                  color: isFavorite
                                      ? Colors.amber
                                      : Colors.grey,
                                ),
                                onPressed: () async {
                                  await favoriteProvider.toggleFavorite(
                                    exercise.id,
                                  );
                                },
                                tooltip: isFavorite ? 'お気に入りから削除' : 'お気に入りに追加',
                              ),
                              title: Text(exercise.name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!isDefault)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () =>
                                          _showExerciseOptions(exercise),
                                      tooltip: 'オプション',
                                    ),
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop(exercise);
                              },
                              onLongPress: () => _showExerciseOptions(exercise),
                            );
                          }),
                          // Add divider after favorites section
                          if (bodyPartId == '_favorites')
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(thickness: 2),
                            ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
