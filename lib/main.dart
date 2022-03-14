// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search in PDFs database'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PdfViewPage(
                          searchText: 'jornal',
                          pdfLink:
                              'https://appro.riodasostras.rj.gov.br/storage/riodasostrasapp/jornais/2022/3/dc5dc863-5649-47ac-a4ab-3b2f2a692ef6.pdf',
                          openToPage: 2),
                    ),
                  );
                },
                child: Text('Open PDF'))
          ],
        ),
      ),
    );
  }
}

class PdfViewPage extends StatefulWidget {
  final String? searchText;
  final String pdfLink;
  final int? openToPage;

  const PdfViewPage(
      {Key? key,
      required this.searchText,
      required this.pdfLink,
      this.openToPage})
      : super(key: key);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;

  late PdfTextSearchResult _searchResult;
  TextEditingController textEditingController = TextEditingController();

  String? searchText;
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();

    searchText = widget.searchText;
    if (searchText != null) {
      textEditingController.text = searchText!;
    }

    print('PdfViewPage searchText: $searchText');
    super.initState();
  }

  bool isLoading = true;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('search result'),
          content: Text(
              'No further occurrences were found. Do you want to continue searching from the beginning?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _searchResult.nextInstance();
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text('yes'),
            ),
            FlatButton(
              onPressed: () {
                _searchResult.clear();
                Navigator.of(context).pop();
              },
              child: Text('no'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 0, 5),
            color: Colors.black,
            child: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        //alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        height: 38,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                onSubmitted: (v) {
                                  if (!isLoading) onSearch();
                                },
                                controller: textEditingController,
                                keyboardType: TextInputType.text,
                                autocorrect: false,
                                onChanged: (v) {
                                  searchText = v;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16, 6, 0, 0),
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontFamily: 'Roboto'),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Visibility(
                                    visible: _searchResult.hasResult,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _searchResult.clear();
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (!isLoading) onSearch();
                                    },
                                    icon: Icon(
                                      Icons.search,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //options
                Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Pag.: ${_pdfViewerController.pageNumber}/${_pdfViewerController.pageCount}',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),

                      //zoom
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          IconButton(
                              tooltip: 'Zoom +',
                              onPressed: () {
                                _pdfViewerController.zoomLevel++;
                              },
                              icon: Icon(
                                Icons.zoom_in,
                                color: Colors.white,
                              )),
                          IconButton(
                              tooltip: 'Zoom -',
                              onPressed: () {
                                _pdfViewerController.zoomLevel--;
                              },
                              icon: Icon(
                                Icons.zoom_out,
                                color: Colors.white,
                              )),
                        ]),
                      ),

                      //earch
                      if (_searchResult.hasResult)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                child: Text(
                              'Result.: ${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 11),
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.navigate_before,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _searchResult.previousInstance();
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (_searchResult.currentInstanceIndex ==
                                    _searchResult.totalInstanceCount) {
                                  _showDialog(context);
                                } else {
                                  _searchResult.nextInstance();
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            )),
          ),
          Expanded(
            child: Stack(
              children: [
                SfPdfViewer.network(
                  widget.pdfLink,
                  onPageChanged: (details) {
                    //setState(() {});
                  },
                  onDocumentLoaded: (details) {
                    setState(() {
                      isLoading = false;
                    });

                    print('onDocumentLoaded $isLoading');

                    Future.delayed(Duration(milliseconds: 200), () {
                      if (widget.openToPage != null) {
                        _pdfViewerController.jumpToPage(widget.openToPage!);
                        print('go to page  ${widget.openToPage}');
                      }
                      onSearch();
                    });
                  },
                  initialZoomLevel: 1,
                  interactionMode: PdfInteractionMode.selection,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Color(0xAAdddddd),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onSearch() async {
    if (searchText != null && searchText?.isNotEmpty == true) {
      try {
        if (!isLoading) {
          setState(() {
            isLoading = true;
            print('isLoading $isLoading');
          });
        }
        await Future.delayed(Duration(milliseconds: 100));
        _searchResult = await _pdfViewerController.searchText(searchText!);
        await Future.delayed(Duration(milliseconds: 100));
      } catch (e) {
        print('onSearch $e');
      } finally {
        setState(() {
          isLoading = false;
          print('isLoading $isLoading');
        });
      }
    }
  }
}
