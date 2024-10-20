#!/bin/bash

# Define variables
USERNAME="phoneticalfox"  # Replace YOUR_USERNAME with your GitHub username
REPO_NAME="loomchat"
REPO_URL="https://github.com/$USERNAME/$REPO_NAME.git"
DIR_NAME="loomchat"
PACKAGE_NAME="com.example.loomchat"

# Create project directory
mkdir $DIR_NAME
cd $DIR_NAME

# Initialize a new Git repository
git init

# Create app directory structure
mkdir -p app/src/main/java/$PACKAGE_NAME
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/values

# Create build.gradle files
cat <<EOL > app/build.gradle
apply plugin: 'com.android.application'

android {
    compileSdkVersion 33
    defaultConfig {
        applicationId "$PACKAGE_NAME"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'com.android.support:appcompat-v7:28.0.0'
    implementation 'androidx.appcompat:appcompat:1.3.0'
}
EOL

# Create MainActivity.kt
cat <<EOL > app/src/main/java/$PACKAGE_NAME/MainActivity.kt
package $PACKAGE_NAME

import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import android.widget.Toast

class MainActivity : AppCompatActivity() {
    private lateinit var ttsManager: TTSManager
    private lateinit var appSettings: AppSettings

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        ttsManager = TTSManager(this)
        appSettings = AppSettings(this)

        findViewById<Button>(R.id.btn_tts_settings).setOnClickListener {
            openTTSSettings()
        }
    }

    private fun openTTSSettings() {
        val voices = ttsManager.getAvailableVoices()
        val voiceNames = voices.map { it.name }.toTypedArray()

        AlertDialog.Builder(this)
            .setTitle("Select TTS Voice")
            .setItems(voiceNames) { _, which ->
                val selectedVoice = voices[which]
                ttsManager.setVoice(selectedVoice)

                appSettings.selectedVoice = selectedVoice.name
                appSettings.saveSettings(this)

                AlertDialog.Builder(this)
                    .setTitle("Preview Voice")
                    .setMessage("Would you like to preview this voice?")
                    .setPositiveButton("Yes") { _, _ ->
                        val sampleText = ttsManager.getRandomSampleText()
                        ttsManager.previewText(sampleText)
                    }
                    .setNegativeButton("No", null)
                    .show()

                Toast.makeText(this, "Selected voice: ${selectedVoice.name}", Toast.LENGTH_SHORT).show()
            }
            .show()
    }
}
EOL

# Create TTSManager.kt
cat <<EOL > app/src/main/java/$PACKAGE_NAME/TTSManager.kt
package $PACKAGE_NAME

import android.content.Context
import android.speech.tts.TextToSpeech
import android.speech.tts.Voice
import android.util.Log
import java.util.Locale

class TTSManager(private val context: Context) {
    private lateinit var textToSpeech: TextToSpeech
    private var selectedVoice: Voice? = null

    init {
        initializeTTS()
    }

    private fun initializeTTS() {
        textToSpeech = TextToSpeech(context) { status ->
            if (status == TextToSpeech.SUCCESS) {
                val result = textToSpeech.setLanguage(Locale.US)
                if (result == TextToSpeech.LANG_MISSING_DATA || result == TextToSpeech.LANG_NOT_SUPPORTED) {
                    Log.e("TTSManager", "Language not supported")
                }
            } else {
                Log.e("TTSManager", "Initialization failed")
            }
        }
    }

    fun setVoice(voice: Voice) {
        selectedVoice = voice
        textToSpeech.voice = selectedVoice
    }

    fun speak(text: String) {
        textToSpeech.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
    }

    fun previewText(text: String) {
        speak(text)
    }

    fun getAvailableVoices(): List<Voice> {
        return listOf() // Replace with actual voices
    }

    fun getRandomSampleText(): String {
        val sampleTexts = listOf(
            "The more I study, the more insatiable do I feel my genius for it to be.",
            "I believe myself to possess a most singular combination of qualities exactly fitted to make me preeminently a discoverer of the hidden realities of nature.",
            "I am more than ever now the bride of science. Religion to me is science, and science is religion.",
            "That brain of mine is something more than merely mortal; as time will show.",
            "The Analytical Engine weaves algebraic patterns, just as the Jacquard loom weaves flowers and leaves.",
            "As soon as I have got flying to a perfection, I have got a scheme about a steam engine."
        )
        return sampleTexts.random()
    }
}
EOL

# Create layout XML file
cat <<EOL > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <Button
        android:id="@+id/btn_tts_settings"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="TTS Settings"
        android:layout_centerInParent="true" />
</RelativeLayout>
EOL

# Create values XML files
cat <<EOL > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">LoomChat</string>
</resources>
EOL

cat <<EOL > app/src/main/res/values/colors.xml
<resources>
    <color name="colorPrimary">#6200EE</color>
    <color name="colorPrimaryDark">#3700B3</color>
    <color name="colorAccent">#03DAC5</color>
</resources>
EOL

# Create .gitignore file
cat <<EOL > .gitignore
/.gradle
/local.properties
/.idea
/.DS_Store
/build/
*.iml
EOL

# Add all files to git
git add .

# Commit changes
git commit -m "Initial commit: Set up LoomChat app with TTS functionality"

# Add remote repository
git remote add origin $REPO_URL

# Push changes to GitHub
git push -u origin master

echo "Successfully created and pushed the LoomChat app to GitHub."