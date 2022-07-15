import 'package:flutter/material.dart';
import 'package:movies_app/src/providers/movies_provider.dart';
import 'package:movies_app/src/screens/cardlist.dart';
import 'package:movies_app/src/search/search_delegate.dart';
import 'package:provider/provider.dart';

import '../widgets/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoviesProvider providerMovies = Provider.of<MoviesProvider>(context);
    providerMovies.selectedmoview;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movie App'),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                },
                icon: const Icon(Icons.search_outlined))
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Categorylist(),
              SizedBox(
                height: 10,
              ),

              // CardSwiper(movies: providerMovies.listMoviesPlaying),
              providerMovies.selectedmoview == 0
                  ? CardList(movies: providerMovies.listMoviesPlaying)
                  : CardList(movies: providerMovies.popularMovies),
            ],
          ),
        ));
  }
}

// I need stateful widget because we need to change some sate on our category
class Categorylist extends StatefulWidget {
  const Categorylist({Key? key}) : super(key: key);

  @override
  _CategorylistState createState() => _CategorylistState();
}

class _CategorylistState extends State<Categorylist> {
  // int selectedCategory = 0;
  List<String> categories = ["Popular", "Action", "Coming Soon"];

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => buildCategory(index, context),
      ),
    );
  }

  Padding buildCategory(int index, BuildContext context) {
    MoviesProvider providerMovies = Provider.of<MoviesProvider>(context);

    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20, right: 10),
      child: GestureDetector(
        onTap: () {
          if (providerMovies.selectedmoview == 0) {
            providerMovies.selectedmoview = 1;
            providerMovies.setfilter(providerMovies.selectedmoview);
          } else if (providerMovies.selectedmoview == 1) {
            providerMovies.selectedmoview = 2;
            providerMovies.setfilter(providerMovies.selectedmoview);
          } else {
            providerMovies.selectedmoview = 0;
            providerMovies.setfilter(providerMovies.selectedmoview);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: index == providerMovies.selectedmoview
                        ? kTextColor
                        : Colors.black.withOpacity(0.4),
                  ),
            ),
            Container(
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: index == providerMovies.selectedmoview
                    ? kSecondaryColor
                    : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
