import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:furniture_store/model/product_model.dart';
import 'package:furniture_store/services/api_service.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for products",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: Icon(Icons.close),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 50.0,
              ),
              child: recommendedForYou(
                  headerText: "Recomended for you", listData: 20),
            )
          ],
        ),
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
            height: 592,
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
                    return GridView.builder(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        // mainAxisSpacing: 5, // Space between items vertically
                        crossAxisSpacing:
                            10, // Space between items horizontally
                        // childAspectRatio: 3 / 1, // Aspect ratio of each item
                      ),
                      itemCount: widget.listData,
                      itemBuilder: (context, index) {
                        Product product = snapshot.data![index];
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          height: 400,
                          width: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              // First image at the bottom
                              SvgPicture.asset(
                                'assets/images/bg.svg',
                                width: 200,
                                height: 400,
                                // fit: BoxFit.cover,
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
