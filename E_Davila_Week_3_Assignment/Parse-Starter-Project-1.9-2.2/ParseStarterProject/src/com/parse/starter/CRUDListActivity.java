package com.parse.starter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.DataSetObserver;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.DeleteCallback;
import com.parse.FindCallback;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.ParseQuery;
import com.parse.ParseUser;

import java.util.Date;
import java.util.List;


public class CRUDListActivity extends Activity {

    Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crudlist);
        crudListView = (ListView) findViewById(R.id.crud_list);
        findViewById(R.id.btn_logout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ParseUser.logOut();
                Intent intent = new Intent(CRUDListActivity.this, ParseStarterProjectActivity.class);
                startActivity(intent);
                finish();
            }
        });
        findViewById(R.id.btn_add).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                showEditActivity(null);
            }
        });
        adapter = new CRUDListAdapter(this);
        crudListView.setAdapter(adapter);

        if(!Utils.isConnectionAvailable(this,true)){
            finish();
            return;
        }
    }

    @Override
    protected void onResume(){
        super.onResume();
        updateList();
    }

    @Override
    protected void onPause(){
        handler.removeCallbacksAndMessages(null);
        super.onPause();
    }

    @SuppressLint("NewApi")
    void updateList(){
        if(Utils.isConnectionAvailable(this,false)) {
            ParseQuery.getQuery("Details").orderByAscending("name").findInBackground(new FindCallback<ParseObject>() {
                @Override
                public void done(List<ParseObject> parseObjects, ParseException e) {
                    if (e == null) {
                        boolean shouldUpdate = false;
                        if(parseObjects.size()!=adapter.getCount()) shouldUpdate = true;
                        else {
                            for (int i = 0, ie = parseObjects.size(); i < ie; i++) {
                                if (parseObjects.get(i).getUpdatedAt().after(adapter.getItem(i).lastUpdateTime)) {
                                    shouldUpdate = true;
                                    break;
                                }
                            }
                        }
                        if(shouldUpdate) {
                            adapter.clear();
                            for(ParseObject object: parseObjects){
                                adapter.add(new CRUDObject(object.getObjectId(),object.getUpdatedAt(),object.getString("name"),object.getString("email"),(int)object.getNumber("phone")));
                            }
                            adapter.notifyDataSetChanged();
                        }
                    } else {
                        Toast.makeText(getApplicationContext(), "Cannot refresh data", Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }else{

        }
        //update again after 10 seconds
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                updateList();
            }
        }, 10000);
    }

    void showEditActivity(CRUDObject object){
        Intent intent = new Intent(this,CRUD.class);
        if(object!=null) {
            intent.putExtra("objectID", object.objectID);
            intent.putExtra("name", object.name);
            intent.putExtra("email", object.email);
            intent.putExtra("phone", ""+object.phone);
        }
        startActivity(intent);
    }

    class CRUDObject{
        String objectID;
        Date lastUpdateTime;
        String name;
        String email;
        int phone;
        public CRUDObject(String objectID, Date lastUpdateTime, String name, String email, int phone){
            this.objectID = objectID;
            this.lastUpdateTime = lastUpdateTime;
            this.name = name;
            this.email = email;
            this.phone = phone;
        }
    }
    class CRUDListAdapter extends ArrayAdapter<CRUDObject>
    {
        public CRUDListAdapter(Context context) {
            super(context, 0);
        }
        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            CRUDObject object = getItem(position);
            if (convertView == null) {
                convertView = LayoutInflater.from(getContext()).inflate(R.layout.crudlist_item, parent, false);
                convertView.findViewById(R.id.btn_edit).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        showEditActivity((CRUDObject) view.getTag());
                    }
                });
                convertView.findViewById(R.id.btn_delete).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if(!Utils.isConnectionAvailable(CRUDListActivity.this,true)) return;
                        handler.removeCallbacksAndMessages(null);
                        ParseObject.createWithoutData("Details",((String)view.getTag())).deleteInBackground(new DeleteCallback() {
                            @Override
                            public void done(ParseException e) {
                                updateList();
                            }
                        });
                    }
                });
            }
            ((TextView)convertView.findViewById(R.id.txt_name)).setText(object.name);
            ((TextView)convertView.findViewById(R.id.txt_email)).setText(object.email);
            ((TextView)convertView.findViewById(R.id.txt_phone)).setText(""+object.phone);
            convertView.findViewById(R.id.btn_delete).setTag(object.objectID);//for delete, we save object ID only
            convertView.findViewById(R.id.btn_edit).setTag(object);
            return convertView;
        }
    }

    CRUDListAdapter adapter;
    ListView crudListView;
}