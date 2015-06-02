package com.parse.starter;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseUser;
import com.parse.SignUpCallback;

public class ParseStarterProjectActivity extends Activity {


    // Sign Up Variables
    Button signUp;

    String userName;
    String userPassword;

    EditText user;
    EditText pass;


public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

    setContentView(R.layout.main);


//
//        // Test Parse Object
//        ParseObject testObject = new ParseObject("TestObject");
//        testObject.put("foo", "bar");
//        testObject.saveInBackground();


    user = (EditText) findViewById(R.id.editText);
    pass = (EditText) findViewById(R.id.editText2);

    signUp = (Button) findViewById(R.id.button);


    // Button onClick Listener
    signUp.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            userName = user.getText().toString();
            userPassword = pass.getText().toString();

            //send to parse
            ParseUser user = new ParseUser();
            user.setUsername(userName);
            user.setPassword(userPassword);
            user.signUpInBackground(new SignUpCallback() {

                public void done(ParseException e) {
                    if (e == null) {
                        Toast.makeText(getApplicationContext(),"Success", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(getApplicationContext(),"Failed", Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }
    });

	}



}
