# يوم السينما الجامعي - نظام حجز المقاعد

تطبيق حجز مقاعد (واجهة عربية RTL) في ملف واحد `index.html` مرتبط بـ Supabase.

## الملفات
- `index.html` : التطبيق كامل (React + Tailwind عبر CDN).
- `supabase.sql` : جدول الحجوزات والدوال (شغّله مرة واحدة في Supabase).

## التشغيل
1. في Supabase > SQL Editor شغّل محتوى `supabase.sql` (بدّل الرقم السري 1234 قبلها).
2. ارفع المجلد على GitHub.
3. فعّل GitHub Pages: Settings > Pages > Source: `main` / root.
4. افتح الرابط: `https://USERNAME.github.io/REPO/`

## ملاحظات
- المفتاح داخل `index.html` هو publishable key، آمن يكون عام. لا تضع `service_role` أبداً.
- رقم الأدمن يتحقق منه السيرفر (دوال `admin_*` في SQL).
- رمز QR شكلي وليس قياسياً؛ للمسح بالكاميرا أضف مكتبة QR لاحقاً.
