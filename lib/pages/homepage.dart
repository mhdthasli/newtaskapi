import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projecttasknew/pages/setting_page.dart';

import '../login&register/login_page.dart';

class ImageSearchScreen extends StatefulWidget {
  @override
  _ImageSearchScreenState createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _images = [];
  int _page = 1;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _loadMoreImages();
    }
  }

  Future<void> _searchImages() async {
    setState(() {
      _page = 1;
      _images.clear();
    });
    await _fetchImages();
  }

  Future<void> _loadMoreImages() async {
    setState(() {
      _page++;
    });
    await _fetchImages();
  }

  Future<void> _fetchImages() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final apiKey = '46342352-16f76098eabdc5dc18259bdc7'; // Your actual Pixabay API key
    final searchTerm = _searchController.text;
    final url = 'https://pixabay.com/api/?key=$apiKey&q=$searchTerm&image_type=photo&page=$_page';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      setState(() {
        _images.addAll(data['hits']);
        _isLoading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to handle logout
  void _logout() {
    // Add your logout logic here
    // For example, you might want to navigate back to a login screen
    // You can also clear user session data if needed
    Navigator.of(context).pop(); // Close the drawer
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Logged out successfully"),
    ));
    // Example: Navigate to a login screen (uncomment if you have a login screen)
    // Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: Text("Image Search"),
      ),

      // Add Drawer here
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child:Column(

          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Icon(
                Icons.lock_open_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),

            ListTile(
              leading: Icon(Icons.search),
              title: Text('S E A R C H  I M A G E S '),

              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('S E T T I N G S '),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingPage()),
                );// Close the drawer
              },
            ),



            // Logout Button
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('L O G O U T'),
              onTap:() async {
                try {
                  await FirebaseAuth.instance.signOut(); // Sign out the user
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) =>   LoginPages(onTap: () {  },)), // Provide any necessary parameters
                        (route) => false, // Remove all previous routes
                  );
                } catch (e) {
                  // Handle sign-out error if needed
                  print("Sign out error: $e");
                  // Optionally, show an error message
                }
              }, // Call the logout method
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Images',hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search,color: Theme.of(context).colorScheme.inversePrimary),
                  onPressed: _searchImages,
                ),
                // Adding border radius
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0), // Set the border radius here
                  borderSide: BorderSide.none, // No border side
                ),
                filled: true, // To add a background color to the TextField
                fillColor: Colors.grey[200], // Optional: Set a background color
              ),
            ),
          ),
          SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              itemCount: _images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                final image = _images[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return FullScreenImage(imageUrl: image['largeImageURL']);
                    }));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: CachedNetworkImage(
                      imageUrl: image['webformatURL'],
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
