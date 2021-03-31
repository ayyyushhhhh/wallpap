import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wallpap/models/api_funtions.dart';
import 'package:wallpap/search_query.dart';
import 'package:wallpap/wallpaper_screen.dart';

Future dataFuture;
ScrollController controller = ScrollController();

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataFuture = getResponse();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        NumImages += 30;
        if (jsonList.length % 80 == 0) {
          pageNum++;
        }
        dataFuture = getResponse();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Wall',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Pap',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        body: showImage(),
      ),
    );
  }
}

class showImage extends StatefulWidget {
  @override
  _showImageState createState() => _showImageState();
}

class _showImageState extends State<showImage> {
  String search;
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            color: Colors.white30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value) {
                      search = value;
                    },
                    decoration:
                        InputDecoration(hintText: 'Search Your Keyword'),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      if (search != null) {
                        _textEditingController.clear();
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => showSearchImage(
                                searchQuery: search,
                              ),
                            ),
                          );
                        });
                      }
                    },
                    child: Icon(
                      Icons.search,
                      size: 20,
                    )),
              ],
            ),
          ),
          FutureBuilder(
            future: dataFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return wallpaperListView();
              } else if (!snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ]);
              }
            },
          ),
        ],
      ),
    );
  }
}

class wallpaperListView extends StatefulWidget {
  @override
  _wallpaperListViewState createState() => _wallpaperListViewState();
}

class _wallpaperListViewState extends State<wallpaperListView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.builder(
        controller: controller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return containerImage(
            index: index,
          );
        },
        itemCount: jsonList.length,
      ),
    );
  }
}

class containerImage extends StatelessWidget {
  int index;
  containerImage({this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => fullScreenWallPaper(
                    index: index,
                    no: 1,
                  )),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(jsonList[index]),
          ),
        ),
      ),
    );
  }
}
