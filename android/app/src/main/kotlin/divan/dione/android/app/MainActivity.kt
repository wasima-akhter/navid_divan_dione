package divan.dione.android.app

import io.flutter.embedding.android.FlutterActivity
import android.util.Log
import android.os.Bundle  // Import the Bundle class

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set log level to suppress verbose logs for BufferQueueProducer
        Log.isLoggable("BufferQueueProducer", Log.WARN)
    }
}
