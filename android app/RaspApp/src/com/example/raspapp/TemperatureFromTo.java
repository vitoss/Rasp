package com.example.raspapp;

import com.example.rasputility.JsonParameters;
import com.example.rasputility.RaspUtility;
import com.example.rasputility.TemperatureObject;

import android.support.v7.app.ActionBarActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class TemperatureFromTo extends ActionBarActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		getTemperatureFromTo();
		setContentView(R.layout.activity_temperature_from_to);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.temperature_from_to, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	private void getTemperatureFromTo() {
		Intent ctx = getIntent();
		String dateFrom = ctx.getStringExtra(JsonParameters.timestampFrom
				.toString());
		String dateTo = ctx.getStringExtra(JsonParameters.timestampTo
				.toString());
		if (dateFrom.isEmpty() || dateTo.isEmpty()) {
			return;
		}
		TemperatureObject[] results = RaspUtility.getInstance().getTemperatureFromTo(dateFrom, dateTo);
	}
}
