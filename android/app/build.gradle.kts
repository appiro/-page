import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// key.properties を読み込む（場所：android/key.properties）
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (!keystorePropertiesFile.exists()) {
    throw GradleException("key.properties not found at: ${keystorePropertiesFile.absolutePath}")
}
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

android {
    namespace = "jp.appirp.fit_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "jp.appiro.fit_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // release署名（key.jks）を定義
    val releaseSigningConfig = signingConfigs.create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        // ★ここが重要：rootProject.file で android/ を基準に解決する
        storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }

    buildTypes {
        release {
            signingConfig = releaseSigningConfig

            // リソース削減を使うなら minify 必須（あなたのエラー対策）
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
