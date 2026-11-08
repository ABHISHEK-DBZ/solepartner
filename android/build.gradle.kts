allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// solana_wallet_adapter_android 0.0.6 predates AGP 8 and omits a namespace.
subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.findByName("android") ?: return@withId
        val getter = android.javaClass.methods.firstOrNull {
            it.name == "getNamespace" && it.parameterCount == 0
        } ?: return@withId
        if (getter.invoke(android) == null) {
            android.javaClass.methods.firstOrNull {
                it.name == "setNamespace" && it.parameterCount == 1
            }?.invoke(android, project.group.toString())
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
