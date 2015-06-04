package com.parse.starter;

import android.app.Activity;
import android.os.Bundle;
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
public class  CRUD extends Activity {

    //Variables
    private EditText nameDetail;
    private EditText emailDetail;
    private EditText phoneDetail;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.crud);

        nameDetail = (EditText) findViewById(R.id.editText3);
        emailDetail = (EditText) findViewById(R.id.editText4);
        phoneDetail = (EditText) findViewById(R.id.editText5);

        findViewById(R.id.button_save).setOnClickListener(new View.OnClickListener() {

            public void onClick(View view) {
                String nameField = nameDetail.getText().toString();
                String emailField = emailDetail.getText().toString();
                String phoneField = phoneDetail.getText().toString();

                int phoneValue = 0;
                try {
                    phoneValue = Integer.parseInt(phoneField);
                } catch (Exception ex) {
                    Toast.makeText(getApplicationContext(), "Invalid phone number", Toast.LENGTH_SHORT).show();
                    return;
                }

                ParseObject details = new ParseObject("Details");
                details.put("name", nameField);
                details.put("email", emailField);
                details.put("phone", phoneValue);

                details.saveInBackground(new SaveCallback() {
                    public void done(ParseException e) {
                        if (e == null) {
                            Toast.makeText(getApplicationContext(), "Save Success", Toast.LENGTH_SHORT).show();
                        } else {
                            Toast.makeText(getApplicationContext(), "Save Failed ", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        });
        findViewById(R.id.button_load).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ParseQuery<ParseObject> query = ParseQuery.getQuery("Details");
                query.getFirstInBackground(new GetCallback<ParseObject>() {
                    @Override
                    public void done(ParseObject parseObject, ParseException e) {
                        if (e == null) {
                            nameDetail.setText(parseObject.getString("name"));
                            emailDetail.setText(parseObject.getString("email"));
                            phoneDetail.setText("" + parseObject.getNumber("phone"));
                        } else {
                            Toast.makeText(getApplicationContext(), "Load Failed ", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        });
        findViewById(R.id.button_delete).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ParseQuery<ParseObject> query = ParseQuery.getQuery("Details");
                query.getFirstInBackground(new GetCallback<ParseObject>() {
                    @Override
                    public void done(ParseObject parseObject, ParseException e) {
                        if(e == null){
                            parseObject.deleteInBackground(new DeleteCallback() {
                                @Override
                                public void done(ParseException e) {
                                    if(e==null){
                                        Toast.makeText(getApplicationContext(), "Delete Success", Toast.LENGTH_SHORT).show();
                                    }else{
                                        Toast.makeText(getApplicationContext(), "Delete Failed", Toast.LENGTH_SHORT).show();
                                    }
                                }
                            });
                        }else{
                            Toast.makeText(getApplicationContext(), "No record", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        });
        findViewById(R.id.button_update).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ParseQuery<ParseObject> query = ParseQuery.getQuery("Details");
                query.getFirstInBackground(new GetCallback<ParseObject>() {
                    @Override
                    public void done(ParseObject parseObject, ParseException e) {
                        if(e == null){

                            String nameField = nameDetail.getText().toString();
                            String emailField = emailDetail.getText().toString();
                            String phoneField = phoneDetail.getText().toString();

                            int phoneValue = 0;
                            try {
                                phoneValue = Integer.parseInt(phoneField);
                            } catch (Exception ex) {
                                Toast.makeText(getApplicationContext(), "Invalid phone number", Toast.LENGTH_SHORT).show();
                                return;
                            }
                            //ParseObject details = new ParseObject("Details");
                            parseObject.put("name", nameField);
                            parseObject.put("email", emailField);
                            parseObject.put("phone", phoneValue);

                            parseObject.saveInBackground(new SaveCallback() {
                                @Override
                                public void done(ParseException e) {
                                    if (e == null) {
                                        Toast.makeText(getApplicationContext(), "Update Success", Toast.LENGTH_SHORT).show();
                                    } else {
                                        Toast.makeText(getApplicationContext(), "Update Failed ", Toast.LENGTH_SHORT).show();
                                    }
                                }
                            });
                }



                }
            });
        }
    });
  }
}