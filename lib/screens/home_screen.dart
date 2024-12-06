import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/search_provider.dart'; 
import 'package:google_fonts/google_fonts.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,  
      appBar: AppBar(
        title: const Text('IMDB Search App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0, 
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextField(
                onSubmitted: (query) {
                  searchProvider.searchMovies(query);
                },
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Search for movies...',
                  hintStyle: GoogleFonts.roboto(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            searchProvider.isLoading
                ? const CircularProgressIndicator() 
                : searchProvider.errorMessage.isNotEmpty
                    ? Text(
                        searchProvider.errorMessage,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      )
                    : searchProvider.results.isEmpty
                        ? const Text(
                            'No results found',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          )
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75, 
                              ),
                              itemCount: searchProvider.results.length,
                              itemBuilder: (context, index) {
                                final movie = searchProvider.results[index];
                                return MovieCard(movie: movie);
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,  
      shadowColor: Colors.black.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: movie['Poster'] != 'N/A'
                ? Image.network(
                    movie['Poster'],
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                  )
                : const Icon(Icons.image_not_supported, size: 50),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie['Title'] ?? 'No Title',
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              movie['Year'] ?? 'No Year',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
