plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")

    // 🔥 Firebase plugin (IDE kell, nem apply!)
    id("com.google.gms.google-services")

    // Flutter plugin mindig utolsó
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.dft_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.dft_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // később ide jön a saját signing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}