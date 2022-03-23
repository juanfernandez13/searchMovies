import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class MoviePage extends StatelessWidget {
  final Map movie;
  MoviePage(this.movie);

  Future<Map> _getPlot() async {
    http.Response response;

    response = await http.get(Uri.parse(
        'https://www.omdbapi.com/?apikey=1eb6da90&t=${movie['Title']}&plot=full'));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(movie['Title']),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                  future: _getPlot(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                            tag: movie['Poster'],
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 15,
                                                  right: 10,
                                                  top: 20,
                                                  bottom: 20),
                                              width: MediaQuery.of(context).size.width * 0.55,
                                              child: Image.network(movie['Poster']),
                                            )),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 15, top: 20, bottom: 20),
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.03,
                                          ),
                                          rowShimmer(
                                            MediaQuery.of(context).size.width * 0.30,
                                            MediaQuery.of(context).size.height * 0.02,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              rowShimmer(
                                MediaQuery.of(context).size.width * 0.90,
                                MediaQuery.of(context).size.height * 0.35,
                              ),
                            ],
                          ),
                        );

                      default:
                        if (snapshot.hasError)
                          return Container(
                            color: Colors.red,
                          );
                        else {
                          return PageMovie(context, snapshot);
                        }
                    }
                  }),
          ),
        ],
      ),
    );
  }

  Widget PageMovie(BuildContext context, AsyncSnapshot snapshot) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                  tag: movie['Poster'],
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Image.network(movie['Poster']),
                  )),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowText("Imdb rating: ${snapshot.data["imdbRating"]}"),
                    rowText("Director: ${snapshot.data["Director"]}"),
                    rowText("Released: ${snapshot.data["Released"]}"),
                    rowText("Genre: ${snapshot.data["Genre"]}"),
                    rowText("Runtime: ${snapshot.data["Runtime"]}"),
                    rowText("Writer: ${snapshot.data["Writer"]}"),
                    rowText("Type: ${snapshot.data["Type"]}"),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  'Plot',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),

          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: RawScrollbar(
              thumbColor: Colors.green,
              child: SingleChildScrollView(
                child: Text(
                  snapshot.data['Plot'],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowShimmer(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
            //color: Colors.white,
          ),
          baseColor: Colors.white,
          highlightColor: Colors.green,
        ),
      ),
    );
  }

  Widget rowText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
