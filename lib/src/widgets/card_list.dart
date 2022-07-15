// import 'package:card_swiper/card_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:movies_app/src/models/models.dart';

// class CardSwiper extends StatelessWidget {
//   List<Movie> movies;

//   CardSwiper({Key? key, required this.movies}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;

//     if (movies.isEmpty) {
//       return SizedBox(
//         width: double.infinity,
//         height: deviceSize.height * 0.6,
//         child: const Center(
//           child: CircularProgressIndicator(
//             color: Colors.indigo,
//           ),
//         ),
//       );
//     }

//     return CardWidget(deviceSize: deviceSize, movies: movies);
//   }
// }

// class CardWidget extends StatelessWidget {
//   const CardWidget({
//     Key? key,
//     required this.deviceSize,
//     required this.movies,
//   }) : super(key: key);

//   final Size deviceSize;
//   final List<Movie> movies;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: deviceSize.height,
//       child: ListView.builder(
//         itemCount: movies.length,

//         // layout: SwiperLayout.STACK, //La forma en que vamos a mover los cards
//         // itemWidth: deviceSize.width * 0.6,
//         // itemHeight: deviceSize.height * 0.5,
//         itemBuilder: (BuildContext context, int index) {
//           //Debemos regresar un Widget, el que sera utilizado para renderizar la tarjeta

//           final movie = movies[index];

//           movie.heroId = 'swiper-${movie.id}';

//           return GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, 'details', arguments: movie);
//             },
//             child: Card(
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     SizedBox(
//                       height: 180,
//                       child: Hero(
//                         tag: movie
//                             .heroId!, //Debe ser unico. cualquier cosa pero unico
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: FadeInImage.assetNetwork(
//                             placeholder: 'assets/no-image.jpg',
//                             image: movie.getFullPosterImage(),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                         // Add from this line
//                         child: Container(
//                       height: 180,
//                       padding: const EdgeInsets.all(12),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(movie.title,
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 10),
//                           Expanded(child: Text(movie.overview))
//                         ],
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
