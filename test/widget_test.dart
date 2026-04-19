import 'package:eung_shop_app/app/app.dart';
import 'package:eung_shop_app/app/router/app_router.dart';
import 'package:eung_shop_app/app/router/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows bottom navigation destinations', (tester) async {
    await _pumpApp(tester);

    expect(find.text('홈'), findsOneWidget);
    expect(find.text('카테고리'), findsOneWidget);
    expect(find.text('장바구니'), findsOneWidget);
    expect(find.text('마이'), findsOneWidget);
  });

  testWidgets('switches tabs from home to category page', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Eung Shop'), findsOneWidget);
    expect(find.text('새로 들어왔어요'), findsOneWidget);

    await tester.tap(find.text('카테고리'));
    await tester.pump();

    expect(find.text('찾고 싶은 카테고리를 검색해보세요'), findsOneWidget);
    expect(find.text('상의'), findsOneWidget);
    expect(find.text('티셔츠'), findsOneWidget);
  });

  testWidgets('opens product list from home shortcut', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('상의'));
    await tester.pumpAndSettle();

    expect(find.text('상의'), findsOneWidget);
    expect(find.text('5개 상품'), findsOneWidget);
  });

  testWidgets('filters categories by Korean consonant search', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('categorySearchField')),
      'ㅅ',
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('셔츠'), findsOneWidget);
    expect(find.text('니트'), findsNothing);

    await tester.drag(
      find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
      const Offset(0, -700),
    );
    await tester.pumpAndSettle();

    expect(find.text('신사복'), findsOneWidget);
  });

  testWidgets('filters categories by decomposed Korean jamo search', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('categorySearchField')),
      'ㅅㅕ',
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('셔츠'), findsOneWidget);
    expect(find.text('신사복'), findsNothing);
  });

  testWidgets('composes decomposed Korean jamo in the search field', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.enterText(
      find.byKey(const ValueKey('categorySearchField')),
      'ㅅㅕㅊㅡ',
    );
    await tester.pump(const Duration(milliseconds: 100));

    final editableText = tester.widget<EditableText>(find.byType(EditableText));

    expect(editableText.controller.text, '셔츠');
    expect(find.text('셔츠'), findsAtLeastNWidgets(1));
  });

  testWidgets('opens product list for all products in a category', (
    tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('전체보기').first);
    await tester.pumpAndSettle();

    expect(find.text('상의'), findsOneWidget);
    expect(find.text('5개 상품'), findsOneWidget);
    expect(find.text('릴렉스 코튼 티셔츠'), findsOneWidget);
  });

  testWidgets('opens product list for a child category only', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('티셔츠'));
    await tester.pumpAndSettle();

    expect(find.text('티셔츠'), findsOneWidget);
    expect(find.text('2개 상품'), findsOneWidget);
    expect(find.text('릴렉스 코튼 티셔츠'), findsOneWidget);
  });

  testWidgets('applies product discount filter', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('전체보기').first);
    await tester.pumpAndSettle();

    expect(find.text('5개 상품'), findsOneWidget);

    await tester.tap(find.text('필터'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('할인 상품만'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('적용하기'));
    await tester.pumpAndSettle();

    expect(find.text('2개 상품'), findsOneWidget);
    expect(find.text('필터 1'), findsOneWidget);
  });

  testWidgets('changes product sort order', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('티셔츠'));
    await tester.pumpAndSettle();

    expect(find.text('최신순'), findsOneWidget);

    await tester.tap(find.text('최신순'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('높은 가격순'));
    await tester.pumpAndSettle();

    expect(find.text('높은 가격순'), findsOneWidget);
  });

  testWidgets('opens product detail from product list', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('티셔츠'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('릴렉스 코튼 티셔츠'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('릴렉스 코튼 티셔츠'));
    await tester.pumpAndSettle();

    expect(find.text('상품 상세'), findsOneWidget);
    expect(find.text('장바구니'), findsOneWidget);
    expect(find.text('바로구매'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('EUNG'), 300);
    await tester.pumpAndSettle();

    expect(find.text('EUNG'), findsOneWidget);
    expect(find.text('색상'), findsOneWidget);
    expect(find.text('사이즈'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('상품 정보'), 300);
    await tester.pumpAndSettle();

    expect(find.text('상품 정보'), findsOneWidget);
  });

  testWidgets('adds selected product to cart', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('카테고리'));
    await tester.pump();
    await tester.tap(find.text('티셔츠'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('릴렉스 코튼 티셔츠'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('릴렉스 코튼 티셔츠'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('장바구니'));
    await tester.pumpAndSettle();

    appRouter.go(RoutePaths.home);
    await tester.pumpAndSettle();
    await tester.tap(find.text('장바구니'));
    await tester.pumpAndSettle();

    expect(find.text('릴렉스 코튼 티셔츠'), findsOneWidget);
    expect(find.text('화이트 / S'), findsOneWidget);
    expect(find.text('29,000원'), findsOneWidget);
    expect(find.text('29,000원 주문하기'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  appRouter.go(RoutePaths.home);
  await tester.pumpWidget(const ProviderScope(child: App()));
  await tester.pump();
}
