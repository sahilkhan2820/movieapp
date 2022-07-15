import 'package:flutter/material.dart';
import 'package:movies_app/src/models/models.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/constants.dart';

class CardList extends StatelessWidget {
  List<Movie> movies;

  CardList({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    if (movies.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: deviceSize.height * 0.6,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.lime,
          ),
        ),
      );
    }

    return CardWidget(deviceSize: deviceSize, movies: movies);
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.deviceSize,
    required this.movies,
  }) : super(key: key);

  final Size deviceSize;
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    MoviesProvider providerMovies =
        Provider.of<MoviesProvider>(context, listen: false);
    providerMovies.loadcontroller();
    // providerMovies.getNowPlayingMoviesPage(1);
    return Column(
      children: [
        //  Categorylist(selectedCategory: 0),
        SizedBox(
          width: double.infinity,
          height: deviceSize.height,
          child: ListView.builder(
            controller: providerMovies.scrollcontroller,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final movie = movies[index];
              movie.heroId = 'swiper-${movie.id}';
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'details', arguments: movie);
                },
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 180,
                          child: Hero(
                            tag: movie
                                .heroId!, //Debe ser unico. cualquier cosa pero unico
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/no-image.jpg',
                                image: movie.getFullPosterImage(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            // Add from this line
                            child: Container(
                          height: 180,
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(movie.title,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10),
                              Expanded(
                                  child: Text(movie.overview,
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)))
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
