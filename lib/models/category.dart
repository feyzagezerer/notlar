class Category {
  int categoryID;
  String categoryName;

  Category(
      this.categoryName); //veritabanına veri eklerken sadece bu, ID otomatik veriliyo

  Category.withID(
      this.categoryID, this.categoryName); //değer okurken bunu, ID de gelcek

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['categoryID'] = categoryID;
    map['categoryName'] = categoryName;
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    this.categoryID = map['categoryID'];
    this.categoryName = map['categoryName'];
  }

  @override
  String toString() {
    return 'Category{categoryID: $categoryID, categoryName: $categoryName}';
  }
}
