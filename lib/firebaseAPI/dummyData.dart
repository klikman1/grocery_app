import '../models/ShoppingCart.dart';

final List<Map<String, dynamic>> dummyProducts = [
  {
    "id": "p1",
    "name": "Apple",
    "stockQuantity": 10,
    "unityPrice": 0.5,
    "nutritionDetails": "Calories: 52, Carbs: 14g, Fiber: 2.4g",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/1/15/Red_Apple.jpg",
  },
  {
    "id": "p2",
    "name": "Milk",
    "stockQuantity": 2,
    "unityPrice": 1.2,
    "nutritionDetails": "Calories: 42, Protein: 3.4g, Fat: 1g",
    "imageUrl": "https://cdn.pixabay.com/photo/2016/08/11/23/25/glass-1587258_1280.jpg",
  },
  {
    "id": "p3",
    "name": "Bread",
    "stockQuantity": 1,
    "unityPrice": 1.0,
    "nutritionDetails": "Calories: 265, Carbs: 49g, Protein: 9g",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Fresh_made_bread_05.jpg/800px-Fresh_made_bread_05.jpg",
  },
  {
    "id": "p4",
    "name": "Banana",
    "stockQuantity": 6,
    "unityPrice": 0.3,
    "nutritionDetails": "Calories: 89, Carbs: 23g, Fiber: 2.6g",
    "imageUrl": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Banana-Single.jpg/2324px-Banana-Single.jpg",
  },
  {
    "id": "p5",
    "name": "Eggs",
    "stockQuantity": 12,
    "unityPrice": 2.5,
    "nutritionDetails": "Calories: 155, Protein: 13g, Fat: 11g",
    "imageUrl": "https://img.freepik.com/premium-photo/pyramid-brown-eggs-isolated-white_221436-209.jpg",
  },
];

final List<ShoppingCart> dummyCarts = [
  ShoppingCart(
    id: 'c1',
    name: 'Weekly Groceries',
    totalProduct: 5,
    total: 7.9,
    products: {
      'p1': 2, // 2 Apples
      'p2': 1, // 1 Milk
      'p3': 2, // 2 Bread
    },
  ),
  ShoppingCart(
    id: 'c2',
    name: 'Fruit Basket',
    totalProduct: 3,
    total: 3.8,
    products: {
      'p1': 1, // 1 Apple
      'p4': 2, // 2 Bananas
    },
  ),
  ShoppingCart(
    id: 'c3',
    name: 'Protein Essentials',
    totalProduct: 2,
    total: 3.7,
    products: {
      'p2': 1, // 1 Milk
      'p5': 1, // 1 Egg
    },
  ),
];
