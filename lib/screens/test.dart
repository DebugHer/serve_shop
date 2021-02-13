//class SearchList extends StatefulWidget {
//  SearchList({ Key key }) : super(key: key);
//  @override
//  _SearchListState createState() => new _SearchListState();
//}
//class _SearchListState extends State<SearchList>
//{
//  Widget appBarTitle = new Text("My Properties", style: new TextStyle(color:
//  Colors.white),);
//  Icon actionIcon = new Icon(Icons.search, color: Colors.orange,);
//  final key = new GlobalKey<ScaffoldState>();
//  final TextEditingController _searchQuery = new TextEditingController();
//  List<String>  _list;
//  bool _IsSearching;
//  String _searchText = "";
//  _SearchListState() {
//    _searchQuery.addListener(() {
//      if (_searchQuery.text.isEmpty) {
//        setState(() {
//          _IsSearching = false;
//          _searchText = "";
//        });
//      }
//      else {
//        setState(() {
//          _IsSearching = true;
//          _searchText = _searchQuery.text;
//        });
//      }
//    });
//  }
//  @override
//  void initState() {
//    super.initState();
//    _IsSearching = false;
//    init();
//  }
//  void init() {
//    _list = List();
//    _list.add("building 1",);
//    _list.add("building 2");
//    _list.add("building 3");
//    _list.add("building 4");
//    _list.add("building 5");
//    _list.add("building 6");
//    _list.add("building 7");
//    _list.add("building 8");
//    _list.add("building 9");
//    _list.add("building 10");
//  }
//  @override
//  Widget build(BuildContext context) {
//    SizeConfig().init(context);
//    return new Scaffold(
//      key: key,
//      appBar: buildBar(context),
//      body: new GridView.count(
//        crossAxisCount: 3,
//        padding: EdgeInsets.fromLTRB(10,10,10,10),
//        childAspectRatio: 8.0 / 9.0,
//        children: _IsSearching ? _buildSearchList() : _buildList(),
//      ),
//      drawer: Navigationdrawer(),
//    );
//  }
//  List<Uiitem> _buildList() {
//    return _list.map((contact) => new Uiitem(contact)).toList();
//  }
//  List<Uiitem> _buildSearchList() {
//    if (_searchText.isEmpty) {
//      return _list.map((contact) => new Uiitem(contact))
//          .toList();
//    }
//    else {
//      List<String> _searchList = List();
//      for (int i = 0; i < _list.length; i++) {
//        String  name = _list.elementAt(i);
//        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
//          _searchList.add(name);
//        }
//      }
//      return _searchList.map((contact) => new Uiitem(contact))
//          .toList();
//    }
//  }
//  Widget buildBar(BuildContext context) {
//    return new AppBar(
//        centerTitle: true,
//        title: appBarTitle,
//        iconTheme: new IconThemeData(color:Colors.orange),
//        backgroundColor: Colors.black,
//        actions: <Widget>[
//          new IconButton(icon: actionIcon, onPressed: () {
//            setState(() {
//              if (this.actionIcon.icon == Icons.search) {
//                this.actionIcon = new Icon(Icons.close, color: Colors.orange,);
//                this.appBarTitle = new TextField(
//                  controller: _searchQuery,
//                  style: new TextStyle(
//                    color: Colors.orange,
//                  ),
//                  decoration: new InputDecoration(
//                      hintText: "Search here..",
//                      hintStyle: new TextStyle(color: Colors.white)
//                  ),
//                );
//                _handleSearchStart();
//              }
//              else {
//                _handleSearchEnd();
//              }
//            });
//          },),
//        ]
//    );
//  }
//  void _handleSearchStart() {
//    setState(() {
//      _IsSearching = true;
//    });
//  }
//  void _handleSearchEnd() {
//    setState(() {
//      this.actionIcon = new Icon(Icons.search, color: Colors.orange,);
//      this.appBarTitle =
//      new Text("My Properties", style: new TextStyle(color: Colors.white),);
//      _IsSearching = false;
//      _searchQuery.clear();
//    });
//  }
//}
//class Uiitem extends StatelessWidget{
//  final String name;
//  Uiitem(this.name);
//  Widget build(BuildContext context){
//    return new Card(
//      margin: EdgeInsets.fromLTRB(5,5,5,7),
//      elevation: 10.0,
//      child: InkWell(
//        splashColor: Colors.orange,
//        onTap: (){
//        },
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            AspectRatio(
//              aspectRatio: 18.0 / 11.0,
//              child: Image.asset('assets/images/build.jpeg',fit: BoxFit.scaleDown,),
//            ),
//            Padding(
//              padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0,0.0),
//              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(this.name,style: new TextStyle(fontFamily: 'Raleway',fontWeight:
//                  FontWeight.bold,fontSize: 14.0),
//                    maxLines: 1,
//                  ),
//                  SizedBox(height: 0.0),
//                  Text('Place',style: new TextStyle(fontFamily: 'Roboto'),),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}