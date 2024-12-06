import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class SearchProvider extends ChangeNotifier {
  List<dynamic> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<dynamic> get results => _results;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Create a logger instance
  final Logger _logger = Logger();

  // Function to search movies
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    _errorMessage = ''; 
    notifyListeners();

    try {
      final apiKey = dotenv.env['OMDB_API_KEY'] ?? 'your_default_api_key';
      final url = Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&s=$query');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Search'] != null) {
          _results = data['Search']; 
        } else {
          _results = [];
        }
      } else {
        _errorMessage = 'Failed to load movies, please try again.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred. Please check your internet connection.';
      
      // Use logger to log the error
      _logger.e('Error occurred while fetching movies:', e);

      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
