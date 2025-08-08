# Maher Flutter App (MVP)
تطبيق Flutter مبسط يجرّب تسجيل الدخول، إنشاء طلب، مشاهدة العروض، وإرسال/قبول عرض.

## التشغيل
1) ثبّت Flutter SDK محليًا.
2) شغّل الخادم:
   ```bash
   cd server
   npm install
   npm run dev
   ```
3) شغّل التطبيق على المحاكي/الجهاز:
   ```bash
   cd app_flutter
   flutter pub get
   flutter run
   ```
> على محاكي Android استخدم `http://10.0.2.2:4000` كعنوان API (مضبوط افتراضيًا).
