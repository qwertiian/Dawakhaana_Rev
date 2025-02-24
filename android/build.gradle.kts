plugins {
    id("com.android.application") version "8.7.0" apply false // Android Gradle plugin
    id("org.jetbrains.kotlin.android") version "2.1.10" apply false // Kotlin plugin
    id("com.google.gms.google-services") version "4.4.2" apply false // Google Services plugin
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}