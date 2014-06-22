package com.example.raspapp;

import com.example.rasputility.RaspUtility;
import com.example.rasputility.TemperatureObject;

import android.support.v7.app.ActionBarActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

public class Temperature extends ActionBarActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_temperature);
		setCurrentTempreture();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.temperature, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			startActivity(new Intent(
					android.provider.Settings.ACTION_WIFI_SETTINGS));
		} else if (id == R.id.action_exit) {
			finish();
			android.os.Process.killProcess(android.os.Process.myPid());
			super.onDestroy();
		}

		return super.onOptionsItemSelected(item);
	}
	
	private void setCurrentTempreture(){
		TemperatureObject currentTemp = RaspUtility.getInstance().getCurrentTemperature();
		TextView temp =(TextView)findViewById(R.id.rasp_temperature);
		temp.setText(currentTemp.getValue());
	}
	
	public void refreshTemperature(View view){
		setCurrentTempreture();
	}

}
