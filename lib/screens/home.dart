import 'package:cuberto_bottom_bar/internal/cuberto_bottom_bar.dart';
import 'package:cuberto_bottom_bar/internal/tab_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniture_store/model/product_model.dart';
import 'package:furniture_store/screens/cartScreen.dart';
import 'package:furniture_store/screens/personScreen.dart';
import 'package:furniture_store/screens/searchScreen.dart';
import 'package:furniture_store/services/api_service.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TabData> tabs = [];
  final Color _inactiveColor = Colors.purple;
  Color _currentColor = Colors.purple;
  int _currentPage = 0;
  late String _currentTitle;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    tabs = [
      TabData(
        iconData: Icons.home,
        title: "Home",
        // tabColor: Colors.deepPurple,
        // tabGradient: getGradient(Colors.deepPurple),
      ),
      TabData(
        iconData: Icons.search,
        title: "Search",
        // tabColor: Colors.pink,
        // tabGradient: getGradient(Colors.pink),
      ),
      TabData(
        iconData: Icons.shopping_bag_outlined,
        title: "Cart",
        // tabColor: Colors.amber,
        // tabGradient: getGradient(Colors.amber),
      ),
      TabData(
        iconData: Icons.person_outline_rounded,
        title: "Person",
        // tabColor: Colors.teal,
        // tabGradient: getGradient(Colors.teal),
      ),
    ];
    _currentTitle = tabs[0].title;
    // Debug prints to check the length and contents of tabs
    print('Tabs length: ${tabs.length}');
    for (var tab in tabs) {
      print('Tab: ${tab.title}, Color: ${tab.tabColor}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            _currentTitle = tabs[index].title;
          });
        },
        children: [
          HomeContent(),
          SearchScreen(),
          CartScreen(),
          PersonScreen(),
        ],
      ),
      bottomNavigationBar: CubertoBottomBar(
        barShadow: [],
        key: const Key("BottomBar"),
        inactiveIconColor: _inactiveColor,
        tabStyle: CubertoTabStyle.styleNormal,
        selectedTab: _currentPage,
        tabs: tabs
            .map(
              (value) => TabData(
                key: Key(value.title),
                iconData: value.iconData,
                title: value.title,
                tabGradient: value.tabGradient,
              ),
            )
            .toList(),
        onTabChangedListener: (position, title, color) {
          setState(() {
            _currentPage = position;
            _currentTitle = title;
            if (color != null) {
              _currentColor = color;
            }
            _pageController.jumpToPage(position);
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: GestureDetector(
            onTap: () => print("Menu Clicked"),
            child: SvgPicture.asset(
              'assets/icons/menu.svg',
              height: 30.0,
              width: 30.0,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () => print("scan Clicked"),
              child: SvgPicture.asset(
                'assets/icons/scan.svg',
                height: 30.0,
                width: 30.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: browsebycategorie(
                  headerText: "Browse by Categories", listData: 10),
            ),
            Container(
              child: recommendedForYou(
                  headerText: "Recomended for you", listData: 20),
            )
          ],
        ),
      ),
    );
  }
}

// BROWSE BY CATEGORIES
class browsebycategorie extends StatefulWidget {
  final String headerText;
  final int listData;
  const browsebycategorie(
      {super.key, required this.headerText, required this.listData});

  @override
  _browsebycategorieState createState() => _browsebycategorieState();
}

class _browsebycategorieState extends State<browsebycategorie> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30.0),
            child: Text(
              widget.headerText,
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "DT Sans",
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            height: 250,
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    itemCount: widget.listData,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data![index];
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 250,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            // First image at the bottom
                            SvgPicture.asset(
                              'assets/images/bg.svg',
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            // Second image overlay with image from API
                            Positioned(
                              top: 0,
                              // left: 20,
                              child: Center(
                                child: Container(
                                  child: Image.network(
                                    product.image,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            // Text on top
                            Positioned(
                              bottom: 24,
                              // left: 0,
                              child: Center(
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              // left: 0,
                              child: Center(
                                child: Text(
                                  'Rating- ${product.rate.toString()}' +
                                      ' | Count- ${product.count.toString()}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// RECOMENDED FOR YOU
class recommendedForYou extends StatefulWidget {
  final String headerText;
  final int listData;
  const recommendedForYou({
    Key? key,
    required this.headerText,
    required this.listData,
  }) : super(key: key);

  @override
  State<recommendedForYou> createState() => _recommendedForYouState();
}

class _recommendedForYouState extends State<recommendedForYou> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.headerText,
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "DT Sans",
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0),
            height: 380,
            width: double.infinity,
            child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No products found'));
                  } else {
                    // Reverse the list of products
                    List<Product> reversedProducts =
                        snapshot.data!.reversed.toList();
                    return GridView.builder(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        mainAxisSpacing: 10, // Space between items vertically
                        crossAxisSpacing:
                            10, // Space between items horizontally
                        // childAspectRatio: 3 / 1, // Aspect ratio of each item
                      ),
                      itemCount: widget.listData,
                      itemBuilder: (context, index) {
                        Product product = reversedProducts[index];
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 250,
                          width: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              // First image at the bottom
                              SvgPicture.asset(
                                'assets/images/bg.svg',
                                width: 200,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              // Second image overlay
                              Positioned(
                                top: -5,
                                // left: 20,
                                child: Container(
                                  child: Image.network(
                                    product.image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              // Text on top
                              Positioned(
                                bottom: 24,
                                // left: 300,
                                child: Text(
                                  product.title,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 310,
                                child: Text(
                                  '100+ Products',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
