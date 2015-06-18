package com.parse.starter;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.parse.DeleteCallback;
import com.parse.GetCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.SaveCallback;


/**
 * Created by OmarDavila on 6/2/15.
 */
public class  CRUD extends Activity implements View.OnClickListener {

    //Variables
    private EditText nameDetail;
    private EditText emailDetail;
    private EditText phoneDetail;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.crud);

        nameDetail = (EditText) findViewById(R.id.editText3);
        emailDetail = (EditText) findViewById(R.id.editText4);
        phoneDetail = (EditText) findViewById(R.id.editText5);

        findViewById(R.id.button_save).setOnClickListener(this);

        if(!Utils.isConnectionAvailable(this,true)){
            finish();
            return;
        }

        objectID = getIntent().getStringExtra("objectID");
        if(objectID!=null){
            nameDetail.setText(getIntent().getStringExtra("name"));
            emailDetail.setText(getIntent().getStringExtra("email"));
            phoneDetail.setText(getIntent().getStringExtra("phone"));
        }
    }

    @Override
    public void onResume(){
        super.onResume();
    }

    // Input Validation Techniques for all user fields
    boolean validateInputs(){
        String nameField = nameDetail.getText().toString();
        if(nameField.length()<1){
            Toast.makeText(getApplicationContext(), "Invalid name", Toast.LENGTH_SHORT).show();
            return false;
        }

        String emailField = emailDetail.getText().toString();
        //REGEX from http://www.regular-expressions.info/email.html
        if(!emailField.matches("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")){
            Toast.makeText(getApplicationContext(), "Invalid email", Toast.LENGTH_SHORT).show();
            return false;
        }

        String phoneField = phoneDetail.getText().toString();

        int phoneValue = 0;
        try {
            phoneValue = Integer.parseInt(phoneField);
        } catch (Exception ex) {
            Toast.makeText(getApplicationContext(), "Invalid phone number", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    @Override
    public void onClick(View view) {
        switch(view.getId()){
            case R.id.button_save:
                if(!Utils.isConnectionAvailable(this,true)){
                    break;
                }
                if(validateInputs()){
                    String nameField = nameDetail.getText().toString();
                    String emailField = emailDetail.getText().toString();
                    int phoneValue = Integer.parseInt(phoneDetail.getText().toString());
                    ParseObject details;
                    if(objectID!=null) details = ParseObject.createWithoutData("Details",objectID);
                    else details = ParseObject.create("Details");
                    details.put("name",nameField);
                    details.put("email",emailField);
                    details.put("phone",phoneValue);
                    details.saveInBackground(new SaveCallback() {
                        @Override
                        public void done(ParseException e) {
                            if(e==null){
                                Toast.makeText(getApplicationContext(), "Saved", Toast.LENGTH_SHORT).show();
                                finish();
                            }else{
                                Toast.makeText(getApplicationContext(), "Save failed "+e.toString(), Toast.LENGTH_SHORT).show();
                            }
                        }
                    });
                }
                break;
            default:
                break;
        }
    }

    String objectID = null;
}