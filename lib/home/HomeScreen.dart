import 'package:flutter/material.dart';
import 'package:mobile_book/home/VolumeService.dart';
import 'package:mobile_book/models/User.dart';
import 'package:mobile_book/utils/Constants.dart';
import 'package:mobile_book/utils/Routes.dart';
import 'package:mobile_book/utils/widget_util.dart';
import 'package:intl/intl.dart';

import 'Volume.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  Widget getLoadingWidget() => Center(key:Key('loader'),child: CircularProgressIndicator());

  Widget getErrorWidget(String errorMsg, Function reload) =>
      Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Colors.red[500],
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  InkWell(
                    onTap: reload,
                    child: Icon(Icons.refresh, size: 24,),
                  )
                ],
              ),
            ),
          ));


  Widget getEmptyView() =>
      Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("There are no books on the server at this time!!! Please check back"),
          )
      );

  Widget getPaginationErrorWidget(String errorMsg, Function reload) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                errorMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.red[500],
                ),
              ),
              SizedBox(height: 4.0,),
              InkWell(
                onTap: reload,
                child: Icon(Icons.refresh),
              )
            ],
          ),
        ));


  Widget getPaginationLoadingWidget() =>
      Card(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            )),
      );

  Widget getListWidget(BuildContext context, Volume volume) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        child: Card(
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  Routes.DETAILS,
                  arguments: {"volume": volume.toJson()}
              );
            },
            title: Text(volume.title),
            subtitle: Text(volume.authors != null ? volume.authors.join(", ") : "N/A"),
            leading: volume.imageLinks == null || volume.imageLinks.smallThumbnail == null ?
                    CircleAvatar (backgroundImage: AssetImage('assets/images/placeholder.png')):
                    FadeInImage.assetNetwork(placeholder: "assets/images/loading.gif", image: volume.imageLinks.smallThumbnail)
          ),
        ),
      );
}

class _HomeScreenState extends State<HomeScreen> {
  static const _MAX_VOLUMES = 20;
  List<Volume> _volumes = [];
  bool _hasMore = true;
  bool _hasError = false;
  bool _isLoading = false;
  int _startIndex = 0;
  String _errorMsg;
  ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadVolumes();
  }

  void _listControllerListener() {
    var triggerFetchMoreSize = 0.7 * _listController.position.maxScrollExtent;
    if (_listController.position.pixels > triggerFetchMoreSize && _hasMore) {
      _listController.removeListener(_listControllerListener);
      _loadVolumes();
    }
  }

  void _loadVolumes() {
    try{
      if(_isLoading || !_hasMore) return;
      setState(() => _isLoading = true);
      VolumeService.loadVolumes(_startIndex, _MAX_VOLUMES)
          .then((value)=> setState((){
            _isLoading = false;
            _hasError = false;
            if(value.isEmpty){
              _hasMore = false;
            }else{
              _volumes.addAll(value);
              _startIndex = _volumes.length;
              _listController.addListener(_listControllerListener);
            }
      }))
      .catchError((error){
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMsg = error.toString();
          });
      });
    }catch(error){
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMsg = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map  args = ModalRoute.of(context).settings.arguments;
    User principal = User.fromJson(args["principal"]);

    return Scaffold(
      appBar: buildAppBar(Constants.APP_NAME),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        //physics: const ScrollPhysics(),
        controller: _listController,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: Constants.LAYOUT_PADDING,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                buildColumnSpacing(),
               _buildHeadline(principal),
                buildColumnSpacing(),
                _buildJumbotron(),
                buildColumnSpacing(),
                _buildList(),
          ],
    ),
        ),
      ),
    );
  }

  Widget _buildHeadline(principal){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Text(
              "Welcome",
              key: Key("welcome-text"),
              style: TextStyle(
                fontSize: 17.0,
                letterSpacing: 2.0,
                color: Colors.grey[700],
              ),
            ),
            Text(
              "${principal.firstName} ${principal.lastName}",
              style: TextStyle(
                fontSize: 24.0,
                letterSpacing: 2.5,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildJumbotron(){
    return Container(
        width: double.infinity,
        height: 200.0,
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/study.jpg'),
                      fit: BoxFit.cover
                  ),
                borderRadius: BorderRadius.all(Radius.circular(25.0))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Study time today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0
                    ),
                  ),
                  Text(
                    DateFormat.yMMMEd().format(DateTime.now()),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          ),
    );
  }

  Widget _buildList(){
    return Container(
        child: _isLoading && _volumes.isEmpty ?
            widget.getLoadingWidget() :
            _hasError && _volumes.isEmpty?
              widget.getErrorWidget(_errorMsg, _loadVolumes) :
                _volumes.isEmpty ?
                  widget.getEmptyView() :
                  ListView.builder(
                      key: Key("listview"),
                      itemCount: _volumes.length + (_hasMore ? 1 : 0),
                      //controller: _listController,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (_hasMore && index >= _volumes.length) {
                          if (_hasError && !_isLoading) {
                            return widget.getPaginationErrorWidget(_errorMsg, _loadVolumes);
                          } else {
                            return widget.getPaginationLoadingWidget();
                          }
                        }
                        return widget.getListWidget(context,_volumes[index]);
                      }
                  )
    );
  }
}
