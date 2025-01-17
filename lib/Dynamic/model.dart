class RecipeModel {
  final String authorName;
  final String profilePicture;
  final String title;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<Nutrition> nutritions;
  final List<String> steps;

  RecipeModel({
    required this.authorName,
    required this.profilePicture,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.nutritions,
    required this.steps,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      authorName: json['author']['author_name'],
      profilePicture: json['author']['profile_picture'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      ingredients: List<Ingredient>.from(
        json['ingredients'].map((ing) => Ingredient.fromJson(ing)),
      ),
      nutritions: List<Nutrition>.from(
        json['nutritions'].map((nut) => Nutrition.fromJson(nut)),
      ),
      steps: List<String>.from(json['steps']),
    );
  }
}

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'],
      quantity: json['quantity'],
    );
  }
}

class Nutrition {
  final String name;
  final int quantity;
  final String unit;

  Nutrition({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }
}
