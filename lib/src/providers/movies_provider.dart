import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/src/helpers/debouncer.dart';
import 'package:movies_app/src/models/models.dart';
import 'package:movies_app/src/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  late ScrollController scrollcontroller = ScrollController();
  String baseUrl = 'api.themoviedb.org';
  String apiKey = 'c4dab5f0d0c4145b527c5599f65bb483';
  String language = 'en-US';
  // At the beginning, we fetch the first 20 posts
  int page = 0;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int limit = 20;
  // There is next page or not
  bool hasNextPage = true;
  // Used to display loading indicators when _firstLoad function is running
  bool isFirstLoadRunning = false;
  // Used to display loading indicators when _loadMore function is running
  bool isLoadMoreRunning = false;

  int _numberPage = 0;
  int selectedmoview = 0;
  List<Movie> listMoviesPlaying = [];
  List<Movie> popularMovies = [];

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  loadcontroller() {
    scrollcontroller = ScrollController()..addListener(getNowPlayingMovies);
  }

  disposecontroller() async {
    scrollcontroller.removeListener(await getNowPlayingMoviesPage(1));
    super.dispose();
  }

  setfilter(int i) {
    // selectedmoview = 1;
    moviefilter(selectedmoview);
    notifyListeners();
  }

  moviefilter(int selectedmoview) {
    if (selectedmoview == 0) {
      getNowPlayingMovies();
      notifyListeners();
    }
    if (selectedmoview == 1) {
      getPopularMovies();
      notifyListeners();
    } else {
      getNowPlayingMovies();
      notifyListeners();
    }
  }

  MoviesProvider() {
    print('MoviesProvider constructor..');
    // loadcontroller();
    getNowPlayingMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(baseUrl, endpoint,
        {'api_key': apiKey, 'language': language, 'page': '$page'});

    var response = await http.get(url);

    return response.body;
  }

  Future<String> _getJsonDatapage(String endpoint, int page) async {
    var url = Uri.https(baseUrl, endpoint,
        {'api_key': apiKey, 'language': language, 'page': '$page'});

    var response = await http.get(url);

    return response.body;
  }

  getNowPlayingMovies() async {
    //var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    //print(jsonResponse['results'][0]['title']);

    final responseData = await _getJsonData('3/movie/now_playing');
    final nowPlayingReponse = NowPlayingResponse.fromJson(responseData);

    listMoviesPlaying = nowPlayingReponse.results;
    notifyListeners();
  }

  getNowPlayingMoviesPage(int page) async {
    //var jsonResponse = json.decode(response.body) as Map<String, dynamic>;
    //print(jsonResponse['results'][0]['title']);
    page += 1;
    final responseData = await _getJsonDatapage('3/movie/now_playing', page);
    final nowPlayingReponse = NowPlayingResponse.fromJson(responseData);

    listMoviesPlaying = nowPlayingReponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _numberPage++;

    final responseData = await _getJsonData('3/movie/popular', _numberPage);

    final popularMoviesResponse = PopularMoviesResponse.fromJson(responseData);
    popularMovies = [...popularMovies, ...popularMoviesResponse.results];
    notifyListeners();
  }

  //Search movies
  Future<List<Movie>> getMoviesByQuery(String query) async {
    final URL = Uri.https(baseUrl, '3/search/movie',
        {'api_key': apiKey, 'language': language, 'query': query});

    var response = await http.get(URL);

    var responseSearch = SearchResponse.fromJson(response.body);

    return responseSearch.results;
  }

  void getSuggestionsByQuery(String sechtTerm) {
    debouncer.value = '';

    debouncer.onValue = (value) async {
      final result = await getMoviesByQuery(value);
      _suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = sechtTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
