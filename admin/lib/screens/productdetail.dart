import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daraz Product Details',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductDetailsScreen(),
    );
  }
}

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  double selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Image.network(
                'https://media.istockphoto.com/id/489814272/photo/gold-silver-rings-and-chains.jpg?s=612x612&w=0&k=20&c=d8tGqzlmqMZzhcYmgE_OyDNSQ9dAdo-T3BwdaSsDbhs=',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              SizedBox(height: 16),

              // Product Details
              Text(
                'Product Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Category: Electronics'),
              Text('Price: \$99.99'),

              SizedBox(height: 16),

              SizedBox(height: 16),

              // Product Description
              Text(
                'Product Description:\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vel nisi nec mi imperdiet ultricies. Cras sed tristique risus, nec laoreet leo. Curabitur volutpat lacus eu felis vehicula cursus.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 16),

              // Product Rating and Reviews
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star, color: Colors.amber),
                      Icon(Icons.star_half, color: Colors.amber),
                    ],
                  ),
                  Text('120 Reviews'),
                ],
              ),

              SizedBox(height: 16),

              // User Reviews
              Text(
                'User Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // User Review 1
              buildUserReview(
                avatarUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYetfo0Z9tnauj3LQ-Cj7xCvaN_L8svM3Yw6SK-btVLTEQvY7Ih5hob5P1lUgLWtqvPlg&usqp=CAU',
                username: 'John Doe',
                rating: 4.5,
                review: 'Great product! I love it.',
              ),

              // User Review 2
              buildUserReview(
                avatarUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYetfo0Z9tnauj3LQ-Cj7xCvaN_L8svM3Yw6SK-btVLTEQvY7Ih5hob5P1lUgLWtqvPlg&usqp=CAU',
                username: 'Jane Smith',
                rating: 5.0,
                review: 'Excellent quality and fast delivery.',
              ),

              // User Review 3
              buildUserReview(
                avatarUrl:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYetfo0Z9tnauj3LQ-Cj7xCvaN_L8svM3Yw6SK-btVLTEQvY7Ih5hob5P1lUgLWtqvPlg&usqp=CAU',
                username: 'Bob Johnson',
                rating: 3.5,
                review: 'Not bad, but could be better.',
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserReview({
    required String avatarUrl,
    required String username,
    required double rating,
    required String review,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text('$rating'),
                ],
              ),
              Text(review),
            ],
          ),
        ],
      ),
    );
  }

  void _showGiveReviewModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Give Review',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),

              // Rating Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rating'),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index + 1 <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          // Handle rating selection
                          setState(() {
                            selectedRating = index + 1.toDouble();
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Review Input Field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Write your review...',
                ),
              ),

              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: () {
                  // Handle submit review
                  Navigator.pop(context); // Close the modal
                },
                child: Text('Submit Review'),
              ),
            ],
          ),
        );
      },
    );
  }
}
