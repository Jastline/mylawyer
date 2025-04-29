plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.JastLine.mylawyer"

    compileSdk = 35
    ndkVersion = "27.0.12077973"
    //compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.JastLine.mylawyer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName
    }

    aaptOptions {
        noCompress 'db', 'sqlite', 'part1', 'part2' // Добавьте все расширения частей
        ignoreAssetsPattern '!.svn:!.git:!.ds_store:!*.scc:.*:<dir>_*:!CVS:!thumbs.db:!picasa.ini:!*~'
    }

    packagingOptions {
        jniLibs {
            useLegacyPackaging = true
        }
        resources {
            excludes += ['META-INF/*']
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        //release {
            //signingConfig = signingConfigs.getByName("debug")
        //}
        debug {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}
