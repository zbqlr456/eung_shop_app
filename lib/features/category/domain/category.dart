enum CategoryAudience { all, women, men, kids }

extension CategoryAudienceLabel on CategoryAudience {
  String get label {
    return switch (this) {
      CategoryAudience.all => '전체',
      CategoryAudience.women => '여성',
      CategoryAudience.men => '남성',
      CategoryAudience.kids => '키즈',
    };
  }
}

class CategoryItem {
  const CategoryItem({required this.id, required this.name});

  final String id;
  final String name;
}

class CategorySection {
  const CategorySection({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<CategoryItem> items;
}
