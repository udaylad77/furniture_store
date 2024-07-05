class Product {
  final int id;
  final String title;
  final String description;
  final String image;
  final double rate;
  final int count;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.rate,
      required this.count});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      rate: json['rating']['rate'],
      count: json['rating']['count'],
    );
  }
}
