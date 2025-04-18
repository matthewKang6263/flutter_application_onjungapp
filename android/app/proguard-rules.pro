# ✅ Kakao SDK 관련
-keep class com.kakao.** { *; }
-keep interface com.kakao.** { *; }
-dontwarn com.kakao.**

# ✅ Firebase 관련
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# ✅ Flutter 관련 (기본적으로 포함돼야 함)
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# ✅ Reflection 사용 보호
-keepattributes Signature
-keepattributes *Annotation*