package com.zero.flutterapp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.android.FlutterFragment
import io.flutter.plugins.GeneratedPluginRegistrant

class FlutterActivity : AppCompatActivity() {

    companion object{
        const val  TAG_FLUTTER_FRAGMENT = "flutter_fragment"
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_flutter)

        val fragmentManager = supportFragmentManager
        var flutterFragment:FlutterFragment? = fragmentManager.findFragmentByTag(TAG_FLUTTER_FRAGMENT) as FlutterFragment?

        if(flutterFragment == null){
            flutterFragment = FlutterFragment.withNewEngine().dartEntrypoint("main").build()
        }
        fragmentManager.beginTransaction()
            .replace(R.id.fragment_container,flutterFragment, TAG_FLUTTER_FRAGMENT).commitNow()
        GeneratedPluginRegistrant.registerWith(flutterFragment.flutterEngine!!)
    }
}