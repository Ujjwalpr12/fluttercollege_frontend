import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final courses = await _apiService.getCourses();
      if (!mounted) return;
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load courses: ${e.toString()}';
      });
    }
  }

  Future<void> _refreshData() async {
    await _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchCourses,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_courses.isEmpty) {
      return Center(child: Text('No courses available'));
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return ListTile(
            title: Text(course['name']?.toString() ?? 'Unnamed Course'),
            subtitle: Text(course['description']?.toString() ?? 'No description'),
          );
        },
      ),
    );
  }
}