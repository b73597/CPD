package com.parse.starter;

import android.app.Application;

import com.parse.Parse;
import com.parse.ParseACL;
import com.parse.ParseCrashReporting;
import com.parse.ParseUser;

public class ParseApplication extends Application {

  @Override
  public void onCreate() {
    super.onCreate();
      // Enable Local Datastore.
      Parse.enableLocalDatastore(this);

      // Initialize Crash Reporting.
    ParseCrashReporting.enable(this);

    // Enable Local Datastore.
    Parse.enableLocalDatastore(this);

    // Add your initialization code here
    Parse.initialize(this);


    ParseUser.enableAutomaticUser();
    ParseACL defaultACL = new ParseACL();
    // Optionally enable public read access.
    // defaultACL.setPublicReadAccess(true);
    ParseACL.setDefaultACL(defaultACL, true);
    //
    Parse.initialize(this, "qf3R1DBaQgWRrlc15HyFPy5W6GPutAjN7nJQ0Me5", "NmldmaNb3wZJsW58xp8iEydADxO4BLLna25yJRXM");


  }
}
