// Compile-only project for the book's Kotlin code: one package per problem (ch07.p01_two_sum, ...).
// Build: gradle compileKotlin   (or ../verify.sh kotlin)
plugins {
    kotlin("jvm") version "2.0.21"
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")
}
