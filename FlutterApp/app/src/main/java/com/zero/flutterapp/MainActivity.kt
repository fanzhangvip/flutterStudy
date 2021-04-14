package com.zero.flutterapp

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.zero.flutterapp.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    private val binding by lazy {
        ActivityMainBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding.apply {
            setContentView(root)
            btnGoFluter.setOnClickListener {
                val intent = Intent(this@MainActivity, FlutterActivity::class.java)
                startActivity(intent)
            }
        }
    }
}