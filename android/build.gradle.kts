import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 🔧 build mappa áthelyezés (Flutter default tweak)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

// 🔧 subproject build mappák
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 🔧 dependency sorrend
subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}