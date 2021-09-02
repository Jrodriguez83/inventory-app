
class CategoryName{
  int _id;
  String _categoryName;
  String _iconName;

  CategoryName(this._categoryName,[this._iconName]);
  CategoryName.withID(this._id,this._categoryName,this._iconName);

  int get id => _id;
  String get categoryName => _categoryName;
  String get iconName => _iconName;

  set categoryName(newCategoryName) {
    if (categoryName.length < 255) {
      this._categoryName = newCategoryName;
    }
  }

  set iconName(newIconName){
    if (iconName != null) {
      this._iconName = newIconName;
    }
  }

  Map<String, dynamic> convertIntoMap(){
    var map = Map<String, dynamic>();

    if (_id != null) {
      map['Id'] = _id;
    }

    map['category_name'] = _categoryName;
    map['icon_name'] = _iconName;

    return map;
  }

  CategoryName.fromMapObject(Map<String,dynamic>map){
    this._id = map['Id'];
    this._categoryName = map['category_name'];
    this._iconName = map['category_name'];
  }

}