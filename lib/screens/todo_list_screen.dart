import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/todo.dart';
import '../widgets/todo_section.dart';
import '../widgets/category_dialog.dart';
import '../widgets/celebration_overlay.dart';
import '../theme/app_theme.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> with SingleTickerProviderStateMixin {
  final List<Todo> _todos = [];
  final _textController = TextEditingController();
  late TabController _tabController;
  bool _showingCelebration = false;
  AppThemeType _currentTheme = AppThemeType.light;
  
  List<String> _categories = ['買い物', '勉強', '仕事'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addTodo(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _todos.add(Todo(
        id: DateTime.now().toString(),
        title: text.trim(),
        category: _categories[_tabController.index],
        isCompleted: false,
        createdAt: DateTime.now(), // 追加
      ));
      _textController.clear();
    });
  }

  void _showAddTodoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: '${_categories[_tabController.index]}に新しいTodoを追加',
                      ),
                      onSubmitted: (value) {
                        _addTodo(value);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      _addTodo(_textController.text);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _addCategory() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const CategoryDialog(
        title: 'カテゴリーを追加',
        buttonText: '追加', // 追加
      ),
    );


    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _categories.add(result.trim());
        _tabController = TabController(
          length: _categories.length,
          vsync: this,
          initialIndex: _categories.length - 1,
        );
      });
    }
  }

  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('ダークグレー'),
                leading: const Icon(Icons.circle, color: Colors.grey),
                onTap: () {
                  setState(() => _currentTheme = AppThemeType.darkGrey);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ネイビー'),
                leading: const Icon(Icons.circle, color: Color(0xFF1A237E)),
                onTap: () {
                  setState(() => _currentTheme = AppThemeType.navy);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('ライト'),
                leading: const Icon(Icons.circle, color: Colors.white),
                onTap: () {
                  setState(() => _currentTheme = AppThemeType.light);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryMenu(int index) {
    final category = _categories[index];
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text('$categoryを編集'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => CategoryDialog(
                      title: 'カテゴリーを編集',
                      buttonText: '更新', // 追加
                      initialValue: category,
                    ),
                  );

                  if (result != null && result.trim().isNotEmpty) {
                    setState(() {
                      _categories[index] = result.trim();
                      // カテゴリー名が変更された場合、関連するTodoのカテゴリーも更新
                      for (var todo in _todos) {
                        if (todo.category == category) {
                          todo.category = result.trim();
                        }
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: Text('$categoryを削除'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteCategory(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteCategory(int index) {
    final category = _categories[index];
    setState(() {
      _categories.removeAt(index);
      _todos.removeWhere((todo) => todo.category == category);
      
      if (_categories.isEmpty) {
        _tabController.dispose();
      } else {
        _tabController = TabController(
          length: _categories.length,
          vsync: this,
          initialIndex: math.min(index, _categories.length - 1),
        );
      }
    });
  }

  void _toggleTodo(String id) {
    setState(() {
      final todo = _todos.firstWhere((todo) => todo.id == id);
      todo.isCompleted = !todo.isCompleted;
      
      // カテゴリー内のTODOがすべて完了したかチェック
      final currentCategory = _categories[_tabController.index];
      final incompleteTodos = _todos.where(
        (todo) => todo.category == currentCategory && !todo.isCompleted
      ).toList();
      
      if (incompleteTodos.isEmpty) {
        setState(() {
          _showingCelebration = true;
        });
      }
    });
  }

  void _deleteTodo(String id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });
  }

  List<Todo> _getFilteredTodos({required bool completed, required String category}) {
    return _todos.where((todo) => 
      todo.isCompleted == completed && 
      todo.category == category
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Todo リスト'),
            actions: [
              IconButton(
                icon: const Icon(Icons.palette),
                onPressed: _showThemeSelector,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: _categories.asMap().entries.map((entry) {
                        return Tab(
                          child: Row(
                            children: [
                              Text(entry.value),
                              IconButton(
                                icon: const Icon(Icons.more_vert, size: 16),
                                onPressed: () => _showCategoryMenu(entry.key),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addCategory,
                    tooltip: 'カテゴリーを追加',
                  ),
                ],
              ),
            ),
          ),
          body: _categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('カテゴリーがありません'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _addCategory,
                        icon: const Icon(Icons.add),
                        label: const Text('カテゴリーを追加'),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: _categories.map((category) => 
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              TodoSection(
                                title: 'TODO',
                                todos: _getFilteredTodos(
                                  completed: false,
                                  category: category,
                                ),
                                onToggle: _toggleTodo,
                                onDelete: _deleteTodo,
                              ),
                              TodoSection(
                                title: 'DONE',
                                todos: _getFilteredTodos(
                                  completed: true,
                                  category: category,
                                ),
                                onToggle: _toggleTodo,
                                onDelete: _deleteTodo,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).toList(),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTodoBottomSheet(),
            child: const Icon(Icons.add),
          ),
        ),
        if (_showingCelebration)
          CelebrationOverlay(
            onAnimationComplete: () {
              setState(() {
                _showingCelebration = false;
              });
            },
          ),
      ],
    );
  }
}