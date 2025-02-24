class FavoriteManager {
  // Singleton instance
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;
  FavoriteManager._internal();

  // List to store favorite products
  List<Map<String, dynamic>> favoriteProducts = [];

  // Method to add or remove a product from favorites
  void toggleFavorite(Map<String, dynamic> product) {
    if (favoriteProducts.contains(product)) {
      favoriteProducts.remove(product);
    } else {
      favoriteProducts.add(product);
    }
  }

  // Method to check if a product is favorited
  bool isFavorite(Map<String, dynamic> product) {
    return favoriteProducts.contains(product);
  }
}