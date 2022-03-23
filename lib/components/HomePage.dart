import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'GridMovies.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    Timer? _timer;
    String? movie;
    bool _movieIsempty = true;
    double maxValue = 0;
    double offset = 0;
    bool max = true;

    ScrollController _controller1 = ScrollController();
    ScrollController _controller2 = ScrollController();
    ScrollController _controller3 = ScrollController();
    ScrollController _controller4 = ScrollController();


    TextEditingController _controllerText = TextEditingController();

    Future<Map> _getMovies() async {
      http.Response response;
        response = await http.get(Uri.parse(
            'https://www.omdbapi.com/?apikey=1eb6da90&s=${movie}'));

        return json.decode(response.body);
    }



    @override
    void initState() {
      _controller2.addListener(() {
        maxValue = _controller2.position.maxScrollExtent;
      });

      offset = maxValue;

      _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
        if (max) {
          offset--;
          if (offset < 3) max = false;
        }
        else {
          offset++;
          if (offset >= maxValue) max = true;
        }
        _controller1.jumpTo(offset);
        _controller2.jumpTo(maxValue - offset);
        _controller3.jumpTo(offset);
        _controller4.jumpTo(maxValue - offset);
      });

      super.initState();
    }



    @override
    Widget build(BuildContext context) {

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp ]);

      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    animatedListMovie(1, _controller1, _movieIsempty),
                    animatedListMovie(8, _controller2,_movieIsempty),

                    TextField(
                      controller: _controllerText,
                      onSubmitted: (text) => setState(() {
                        movie = _controllerText.text;
                        _movieIsempty = movie == null || movie == '';
                      }),
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Search',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),

                          labelStyle: TextStyle(
                            color: Colors.white,
                          )),
                      textAlign: TextAlign.start,
                    ),
                    animatedListMovie(15, _controller3,_movieIsempty),
                    animatedListMovie(22, _controller4,_movieIsempty),
                  ],
                ),
              ),
              if(!_movieIsempty )Expanded(child: GridMovies(movie!,_getMovies())),
            ],
          ),
        ),
      );
    }

    Widget animatedListMovie(final int moviePosition, ScrollController _controller, bool isEmpty){
      return AnimatedContainer(
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.only(top: isEmpty? MediaQuery.of(context).size.height*0.0005:1, bottom: isEmpty? 5:1 ),
        height: isEmpty? MediaQuery.of(context).size.height*0.2 : 0,
        color: Colors.black,
        child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width*0.25,
                child: Image.asset("assets/image${index+moviePosition}.jpg"),
              );
            }),);
    }

}
