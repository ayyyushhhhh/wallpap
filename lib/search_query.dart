import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallpap/models/api_funtions.dart';
import 'package:wallpap/wallpaper_screen.dart';

Future searchFuture;
ScrollController searchcontroller = ScrollController();
String search;

class showSearchImage extends StatefulWidget {
  String searchQuery;
  showSearchImage({this.searchQuery});
  @override
  _showSearchImageState createState() => _showSearchImageState();
}

class _showSearchImageState extends State<showSearchImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFuture = getSearchResponse(widget.searchQuery);
    searchcontroller.addListener(() {
      if (searchcontroller.position.pixels ==
          searchcontroller.position.maxScrollExtent) {
        SearchNumImages += 30;
        if (searchList.length % 80 == 0) {
          SearchpageNum++;
        }

        if (this.mounted)
          setState(() {
            searchFuture = getSearchResponse(widget.searchQuery);
          });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search : ${widget.searchQuery}'),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder(
              future: searchFuture,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: 404 Not Found',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return searchwallpaperListView();
                } else if (!snapshot.hasData) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ]);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class searchwallpaperListView extends StatefulWidget {
  @override
  _searchwallpaperListViewState createState() =>
      _searchwallpaperListViewState();
}

class _searchwallpaperListViewState extends State<searchwallpaperListView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.builder(
        controller: searchcontroller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return searchcontainerImage(
            index: index,
          );
        },
        itemCount: searchList.length,
      ),
    );
  }
}

class searchcontainerImage extends StatelessWidget {
  int index;
  searchcontainerImage({this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => fullScreenWallPaper(
              index: index,
              no: 0,
            ),
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(searchList[index]),
          ),
        ),
      ),
    );
  }
}
