import 'package:eung_shop_app/features/category/domain/category.dart';

const allCategorySections = [
  CategorySection(
    id: 'tops',
    title: '상의',
    items: [
      CategoryItem(id: 't-shirts', name: '티셔츠'),
      CategoryItem(id: 'shirts', name: '셔츠'),
      CategoryItem(id: 'knitwear', name: '니트'),
      CategoryItem(id: 'hoodies', name: '후드'),
      CategoryItem(id: 'sweatshirts', name: '맨투맨'),
    ],
  ),
  CategorySection(
    id: 'bottoms',
    title: '하의',
    items: [
      CategoryItem(id: 'denim', name: '데님'),
      CategoryItem(id: 'slacks', name: '슬랙스'),
      CategoryItem(id: 'skirts', name: '스커트'),
      CategoryItem(id: 'shorts', name: '쇼츠'),
    ],
  ),
  CategorySection(
    id: 'outerwear',
    title: '아우터',
    items: [
      CategoryItem(id: 'coats', name: '코트'),
      CategoryItem(id: 'jackets', name: '재킷'),
      CategoryItem(id: 'padding', name: '패딩'),
      CategoryItem(id: 'cardigans', name: '가디건'),
    ],
  ),
  CategorySection(
    id: 'shoes',
    title: '신발',
    items: [
      CategoryItem(id: 'sneakers', name: '스니커즈'),
      CategoryItem(id: 'loafers', name: '로퍼'),
      CategoryItem(id: 'boots', name: '부츠'),
      CategoryItem(id: 'sandals', name: '샌들'),
    ],
  ),
  CategorySection(
    id: 'bags',
    title: '가방',
    items: [
      CategoryItem(id: 'backpacks', name: '백팩'),
      CategoryItem(id: 'shoulder-bags', name: '숄더백'),
      CategoryItem(id: 'tote-bags', name: '토트백'),
      CategoryItem(id: 'crossbody-bags', name: '크로스백'),
    ],
  ),
  CategorySection(
    id: 'formalwear',
    title: '포멀',
    items: [
      CategoryItem(id: 'suits', name: '신사복'),
      CategoryItem(id: 'suit-sets', name: '수트'),
      CategoryItem(id: 'ties', name: '넥타이'),
    ],
  ),
];

const womenCategorySections = [
  CategorySection(
    id: 'women-tops',
    title: '상의',
    items: [
      CategoryItem(id: 'women-t-shirts', name: '티셔츠'),
      CategoryItem(id: 'women-blouses', name: '블라우스'),
      CategoryItem(id: 'women-knitwear', name: '니트'),
      CategoryItem(id: 'women-hoodies', name: '후드'),
    ],
  ),
  CategorySection(
    id: 'women-bottoms',
    title: '하의',
    items: [
      CategoryItem(id: 'women-denim', name: '데님'),
      CategoryItem(id: 'women-slacks', name: '슬랙스'),
      CategoryItem(id: 'women-skirts', name: '스커트'),
      CategoryItem(id: 'women-shorts', name: '쇼츠'),
    ],
  ),
  CategorySection(
    id: 'women-dresses',
    title: '원피스',
    items: [
      CategoryItem(id: 'mini-dresses', name: '미니 원피스'),
      CategoryItem(id: 'long-dresses', name: '롱 원피스'),
      CategoryItem(id: 'knit-dresses', name: '니트 원피스'),
    ],
  ),
  CategorySection(
    id: 'women-accessories',
    title: '잡화',
    items: [
      CategoryItem(id: 'women-bags', name: '가방'),
      CategoryItem(id: 'women-shoes', name: '신발'),
      CategoryItem(id: 'women-jewelry', name: '주얼리'),
    ],
  ),
];

const menCategorySections = [
  CategorySection(
    id: 'men-tops',
    title: '상의',
    items: [
      CategoryItem(id: 'men-t-shirts', name: '티셔츠'),
      CategoryItem(id: 'men-shirts', name: '셔츠'),
      CategoryItem(id: 'men-knitwear', name: '니트'),
      CategoryItem(id: 'men-sweatshirts', name: '맨투맨'),
    ],
  ),
  CategorySection(
    id: 'men-bottoms',
    title: '하의',
    items: [
      CategoryItem(id: 'men-denim', name: '데님'),
      CategoryItem(id: 'men-slacks', name: '슬랙스'),
      CategoryItem(id: 'men-joggers', name: '조거 팬츠'),
      CategoryItem(id: 'men-shorts', name: '쇼츠'),
    ],
  ),
  CategorySection(
    id: 'men-outerwear',
    title: '아우터',
    items: [
      CategoryItem(id: 'men-jackets', name: '재킷'),
      CategoryItem(id: 'men-coats', name: '코트'),
      CategoryItem(id: 'men-padding', name: '패딩'),
      CategoryItem(id: 'men-blazers', name: '블레이저'),
    ],
  ),
  CategorySection(
    id: 'men-accessories',
    title: '잡화',
    items: [
      CategoryItem(id: 'men-shoes', name: '신발'),
      CategoryItem(id: 'men-bags', name: '가방'),
      CategoryItem(id: 'men-caps', name: '모자'),
    ],
  ),
];

const kidsCategorySections = [
  CategorySection(
    id: 'kids-tops',
    title: '상의',
    items: [
      CategoryItem(id: 'kids-t-shirts', name: '티셔츠'),
      CategoryItem(id: 'kids-sweatshirts', name: '맨투맨'),
      CategoryItem(id: 'kids-hoodies', name: '후드'),
      CategoryItem(id: 'kids-knitwear', name: '니트'),
    ],
  ),
  CategorySection(
    id: 'kids-bottoms',
    title: '하의',
    items: [
      CategoryItem(id: 'kids-denim', name: '데님'),
      CategoryItem(id: 'kids-leggings', name: '레깅스'),
      CategoryItem(id: 'kids-joggers', name: '조거 팬츠'),
      CategoryItem(id: 'kids-shorts', name: '쇼츠'),
    ],
  ),
  CategorySection(
    id: 'kids-outerwear',
    title: '아우터',
    items: [
      CategoryItem(id: 'kids-jackets', name: '재킷'),
      CategoryItem(id: 'kids-padding', name: '패딩'),
      CategoryItem(id: 'kids-cardigans', name: '가디건'),
    ],
  ),
  CategorySection(
    id: 'kids-shoes',
    title: '신발',
    items: [
      CategoryItem(id: 'kids-sneakers', name: '스니커즈'),
      CategoryItem(id: 'kids-boots', name: '부츠'),
      CategoryItem(id: 'kids-sandals', name: '샌들'),
    ],
  ),
];

const allKnownCategorySections = [
  ...allCategorySections,
  ...womenCategorySections,
  ...menCategorySections,
  ...kidsCategorySections,
];

List<CategorySection> categorySectionsForAudience(CategoryAudience audience) {
  return switch (audience) {
    CategoryAudience.all => allCategorySections,
    CategoryAudience.women => womenCategorySections,
    CategoryAudience.men => menCategorySections,
    CategoryAudience.kids => kidsCategorySections,
  };
}

Set<String> categoryIdsForSelection(
  String categoryId, {
  required bool includeChildren,
}) {
  final ids = <String>{categoryId};
  if (!includeChildren) return ids;

  for (final section in allKnownCategorySections) {
    if (section.id == categoryId) {
      ids.addAll(section.items.map((item) => item.id));
      break;
    }
  }

  return ids;
}
