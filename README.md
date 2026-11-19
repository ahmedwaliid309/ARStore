# Decora (ARStore) — Starter

تطبيق Flutter لمتجر أثاث بالواقع المعزز. الـ AR مؤجل، والأولوية دلوقتي للتطبيق نفسه.
Figma: https://www.figma.com/design/9xevqJ4IGM8LP7zrQX2ycF/Decora

## تجهيز المشروع (وليد، مرة واحدة)

```powershell
cd G:\Android_Std
git clone https://github.com/ahmedwaliid309/ARStore.git
cd ARStore
flutter create --project-name decora .
flutter pub add go_router provider flutter_screenutil cached_network_image shared_preferences
flutter pub add flutter_localizations --sdk=flutter
```

1. انسخ فولدرَي `lib/` و`assets/` من الـ Starter فوق المشروع (استبدل `main.dart`).
2. امسح `test/widget_test.dart` (بيشاور على MyApp القديم).
3. في `pubspec.yaml` ضيف تحت `flutter:` (مسافتين قبل `assets` و`fonts`):

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/models/

  fonts:
    - family: Tajawal
      fonts:
        - asset: assets/fonts/Tajawal-Regular.ttf
        - asset: assets/fonts/Tajawal-Medium.ttf
          weight: 500
        - asset: assets/fonts/Tajawal-Bold.ttf
          weight: 700
```

4. جرّب:

```powershell
flutter pub get
flutter run
```

5. ارفع:

```powershell
git add .
git commit -m "Initial Decora starter: theme, router, providers, screens"
git branch -M main
git push -u origin main
git checkout -b develop
git push -u origin develop
```

6. على GitHub: Settings ثم General ثم Default branch = `develop`، وSettings ثم Collaborators وضيف التيم.
7. ابعت رسالة التوزيع.

لو ظهر خطأ `Could not close incremental caches` (مشروع على درايف غير C):

```powershell
Add-Content -Path "$HOME\.gradle\gradle.properties" -Value "kotlin.incremental=false"
flutter clean
```

## اللي لازم يتظبط من Figma (وليد)

- `lib/core/theme/app_colors.dart`: الألوان مؤقتة.
- `lib/core/theme/app_theme.dart`: الخط (Tajawal مؤقت).
- `lib/main.dart`: حجم الـ Frame (390×844 مؤقت) واللغة (عربي RTL).
- `lib/core/widgets/main_shell.dart`: تابات الـ Bottom Nav (4 تابات مؤقتة).
- قايمة الشاشات (14) اتبنت على اللي اتفقنا عليه قبل كده، قارنها بالتصميم.

## الهيكل

```
lib/
├── main.dart                  ← وليد بس (فيه تسجيل كل الـ Providers)
├── core/                      ← وليد بس (theme / router / widgets مشتركة)
│   └── widgets/product_card.dart   ← استثناء: عطا
├── data/                      ← Product وداتا تجريبية و ProductRepository
├── providers/                 ← Cart / Favorites / Auth / Orders
└── features/<screen>/         ← فولدر لكل شاشة، وكل واحد في فولدره بس
```

## توزيع الشاشات (13 شاشة + AR مؤجل)

| العضو | الشاشات | الـ Provider |
|-------|---------|-------------|
| أحمد وليد | Splash، Onboarding، Orders (+ core والمراجعة، وAR لاحقاً) | — |
| معاذ | Home، Order Confirmation | — |
| أحمد عطا | Products، Favorites (+ ProductCard) | FavoritesProvider |
| السيد | Cart، Checkout | CartProvider وOrdersProvider |
| إيمان | Product Details، Settings | — |
| سارة | Login/Register، Profile (+ الاختبار والتوثيق) | AuthProvider |

كل ملف شاشة في `lib/features/` فيه في أوله تعليق بالمسؤول والـ Branch والمطلوب.

## قواعد

1. Branch لكل شاشة من `develop`: `feature/اسم-الشاشة`.
2. ممنوع الرفع على `main` أو `develop` مباشرة، Pull Request فقط (base = develop).
3. `core/` و`main.dart` و`pubspec.yaml` تعديلها من وليد بس.
4. الألوان من `AppColors`، والأحجام بـ `.w .h .r .sp`، والتنقل من `AppRoutes`.
5. الطلبات في `initState` مش `build`، وكل شاشة فيها تحميل ولا نتايج وخطأ.
6. أسماء دوال الـ Providers متفق عليها، متغيّرهاش من غير ما تبلّغ.
