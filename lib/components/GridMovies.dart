import 'package:filmes/components/MoviePage.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GridMovies extends StatefulWidget {
  String nameMovie;
  Future getMovies;

  GridMovies(this.nameMovie, this.getMovies);

  @override
  _GridMoviesState createState() => _GridMoviesState();
}



class _GridMoviesState extends State<GridMovies> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
              future: widget.getMovies,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:

                    return ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            cardShimmer(),
                            cardShimmer(),
                          ],
                        );
                      },
                    );

                  default:
                    if (snapshot.hasError)
                      return Container(
                        color: Colors.red,
                      );

                    else
                      return moviesTable(context, snapshot);
                }
              }),
        )
      ],
    );
  }



  Widget cardShimmer(){
    return Container(
      padding: EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Shimmer.fromColors(
          child: Card(
            color: Colors.white,
          ),
          baseColor: Colors.green,
          highlightColor: Colors.white),
    );
  }

  int moviesCount(List movies) {
    return movies.length;
  }
  Widget moviesTable(BuildContext context, AsyncSnapshot snapshot) {
    return snapshot.data['Search'] == null?

    Container(
      width: double.infinity,
      color: Colors.green[700],
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset("assets/imageSadSmile.png"),
          ),

          Center(child: SizedBox(
              width: 300,
              child: Text("Infelizmente nenhum filme foi encontrado",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)))
        ],
      )
    ) :

    RawScrollbar(
      thumbColor: Colors.green,
      child: GridView.builder(
          itemCount: moviesCount(snapshot.data['Search']),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MoviePage(snapshot.data["Search"][index])));
              },
              child: Hero(
                tag: snapshot.data['Search'][index]['Poster'],
                child: snapshot.data['Search'][index]['Poster'] == "N/A" || snapshot.data['Search'][index]['Poster'] == null?
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    color:Colors.green,
                    child: Image.asset("assets/imageSadSmile.png"),
                  ),
                ) : Image.network(snapshot.data["Search"][index]['Poster']),
              ),
            );
          }),
    );
  }
}
