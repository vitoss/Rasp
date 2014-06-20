package com.example.raspapp;

import android.support.v7.app.ActionBarActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MenuActivity extends ActionBarActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_menu);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.menu, menu);
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
	
	public void raspTemperatureFromToOnClick(View view){
		Context ctx = this;
		Intent menu = new Intent(ctx, FromToActivity.class);
		startActivity(menu);
	}
	
	public void raspTemperatureOnClick(View view){
		Context ctx = this;
		Intent menu = new Intent(ctx, Temperature.class);
		startActivity(menu);
	}
}
