import 'package:flutter/material.dart';
import 'package:products_manager/Dynamic/model.dart';
import 'package:products_manager/shared.dart';
import 'constants.dart';

class Detail extends StatelessWidget {
  static const kBoxShadow = [
    BoxShadow(
      color: Colors.black12,
      offset: Offset(0, 3),
      blurRadius: 6,
    ),
  ];

  final RecipeModel recipe;

  Detail({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.favorite,
              color: Colors.pink,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title and author section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation1(recipe.title),
                  buildTextSubTitleVariation1(recipe.authorName),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recipe image and details
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextTitleVariation2('Nitration', false),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true, // Prevents overflow inside SingleChildScrollView
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: recipe.nutritions.length,
                        itemBuilder: (context, index) {

                          final nutrition = recipe.nutritions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4,),
                            child: Container(
                              margin: EdgeInsets.only(right:230, left: 5),
                              height: 60,
                              width: 150,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                boxShadow: kBoxShadow,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: kBoxShadow,
                                    ),
                                    child: Center(
                                      child: buildTextNut3("${nutrition.quantity}"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      buildTextNut2("${nutrition.name}",Colors.black),
                                      buildTextNut("${nutrition.unit}")

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    right: -80,
                    child: Hero(
                      tag: recipe.profilePicture,
                      child: Container(
                        height: 290,
                        width: 290,
                        decoration: BoxDecoration(
                          boxShadow: kBoxShadow,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(recipe.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ingredients section
                  buildTextTitleVariation2('Ingredients', false),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true, // Prevents overflow inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.ingredients.length,
                    itemBuilder: (context, index) {
                      var d = recipe.ingredients[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: buildTextSubTitleVariation1("- ${d.name} ${d.quantity}"),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Steps section
                  buildTextTitleVariation2('Recipe preparation', false),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recipe.steps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: buildTextSubTitleVariation1(
                          'Step ${index + 1}: ${recipe.steps[index]}',                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: kPrimaryColor,
        icon: const Icon(
          Icons.play_circle_fill,
          color: Colors.white,
          size: 32,
        ),
        label: const Text(
          "Watch Video",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
