@file:Suppress("DEPRECATION")

import java.time.LocalDate
import java.time.format.DateTimeFormatter
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "media.gabriel.pixelplay"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "media.gabriel.pixelplay"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

val copyFormattedReleaseApks by tasks.registering {
    doLast {
        val releaseOutputDir = layout.buildDirectory.dir("outputs/apk/release").get().asFile
        val flutterOutputDir = layout.buildDirectory.dir("outputs/flutter-apk").get().asFile
        val releaseApks =
            releaseOutputDir.listFiles { file -> file.isFile && file.extension == "apk" }
                ?: emptyArray()

        flutterOutputDir.mkdirs()

        releaseApks.forEach { apkFile ->
            val abiName = resolveAbiNameFromFileName(apkFile.name)
            val targetFile =
                flutterOutputDir.resolve(
                    "${releaseApkNamePrefix}_${releaseApkDate}_${abiName}_release.apk"
                )

            apkFile.copyTo(targetFile, overwrite = true)
        }
    }
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy(copyFormattedReleaseApks)
}

kotlin {
    compilerOptions {
        jvmTarget = JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
