
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:products_manager/detail.dart';

import '../shared.dart';
import 'model.dart';

const kBoxShadow = [
  BoxShadow(
    color: Colors.black12,
    offset: Offset(0, 3),
    blurRadius: 6,
  ),
];

const kPrimaryColor = Colors.green;

class ExploreVinay extends StatefulWidget {
  @override
  _ExploreVinayState createState() => _ExploreVinayState();
}

class _ExploreVinayState extends State<ExploreVinay> {


  List<bool> optionSelected = [true, false, false];
  List<RecipeModel> foodList = [];

  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:5000/list"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.map((json) => RecipeModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes. HTTP Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.sort, color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(Icons.favorite, color: Colors.pink),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildHorizontalRecipeList(),
            const SizedBox(height: 16),
            _buildPopularSection(),
            _buildVerticalRecipeList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTextTitleVariation1('Coook Now!'),
          buildTextSubTitleVariation1('Healthy and nutritious food recipes'),
          SizedBox(height: 8,),

          Container(
            height: 50,
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: kBoxShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search Recipe",
                hintStyle: TextStyle(fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildOption('Veg', 'assets/icons/salad.png', 0),
              const SizedBox(width: 8),
              _buildOption('Non-veg', 'assets/icons/rice.png', 1),
              const SizedBox(width: 8),
              _buildOption('Sweets', 'assets/icons/fruit.png', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalRecipeList() {
    return SizedBox(
      height: 350,
      child: FutureBuilder<List<RecipeModel>>(
        future: fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/warning.png", height: 150,width: 150,),
                buildTextNut2("Error! Check Your Internet Connection",Colors.red),
              ],
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }
          final recipes = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(recipe: recipe),
                    ),
                  );
                },
                child: _buildRecipeCard(recipe, index),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildVerticalRecipeList() {
    return FutureBuilder<List<RecipeModel>>(
      future: fetchRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SizedBox();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recipes found.'));
        }
        final recipes = snapshot.data!;
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(recipe: recipe),
                  ),
                );
              },
              child: _buildRecipeListItem(recipe),
            );
          },
        );
      },
    );
  }

  Widget _buildOption(String text, String image, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          optionSelected = List.generate(optionSelected.length, (i) => i == index);
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: optionSelected[index] ? kPrimaryColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: kBoxShadow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                image,
                color: optionSelected[index] ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: optionSelected[index] ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(RecipeModel recipe, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: kBoxShadow,
      ),
      margin: EdgeInsets.only(
        right: 16,
        left: index == 0 ? 16 : 0,
        bottom: 16,
        top: 8,
      ),
      padding: const EdgeInsets.all(16),
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: '${recipe.authorName}_${recipe.imageUrl}',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(recipe.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          buildRecipeTitle(recipe.title),
          buildTextSubTitleVariation2(recipe.authorName),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCalories('${recipe.title} Kcal'),
              const Icon(Icons.favorite_border),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeListItem(RecipeModel recipe) {
    return Container(
      padding: EdgeInsets.only(left: 08),
      height: 158,
      width: 158,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: kBoxShadow,
      ),
      child: Row(
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(recipe.imageUrl,),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRecipeTitle(recipe.title),
                  buildRecipeSubTitle(recipe.authorName),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCalories('${recipe.title} Kcal'),
                      const Icon(Icons.favorite_border),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          buildTextTitleVariation2('Popular', false),
          const SizedBox(width: 8),
          buildTextTitleVariation2('Food', true),
        ],
      ),
    );
  }
}
