# Flutter & Dart JNI (don't remove or obfuscate Flutter engine)
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep method names used for platform channels
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# GetX (if used for routing or reflection-based logic)
-keep class com.github.jonataslaw.** { *; }
-keepclassmembers class * {
    public <init>(...);
}

# Hive type adapters and fields
-keep class ** extends hive_generator.TypeAdapter { *; }
-keepclassmembers class * {
    @HiveField <fields>;
}
-keep class * extends com.example.yourapp.NoteModel { *; }  # replace with actual model base class if needed

# Gson (if you use JSON serialization)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Preserve model classes with serialization
-keepclassmembers class * {
   public <init>(...);
}

# Keep annotations
-keepattributes RuntimeVisibleAnnotations,AnnotationDefault

# WorkManager / Background tasks (if you use them)
-keep class androidx.work.** { *; }

# Firebase (optional, if used)
-keep class com.google.firebase.** { *; }

# Avoid stripping logs or crash stack traces
-keepattributes SourceFile,LineNumberTable

# Prevent removal of classes used by Flutter's Play Store deferred components
-keep class com.google.android.play.** { *; }
-dontwarn com.google.android.play.**
