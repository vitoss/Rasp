package com.example.raspapp;

import com.example.rasputility.JsonParameters;

import android.support.v7.app.ActionBarActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;

public class TemperatureFromToMenu extends ActionBarActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_temperature_from_to_menu);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.temperature_from_to_menu, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
	
	public void raspFromToButtonOnclick(View view){
		TextView dateFrom = (TextView)findViewById(R.id.rasp_temperature_date_from);
		String dateFromStr = dateFrom.getText().toString();
		TextView dateTo  = (TextView)findViewById(R.id.rasp_temperature_to_date);
		String dateToStr = dateTo.getText().toString();
		
		Intent intent = new Intent(this, TemperatureFromTo.class);
		intent.putExtra(JsonParameters.timestampFrom.toString(), dateFromStr);
		intent.putExtra(JsonParameters.timestampTo.toString(), dateToStr);
		startActivity(intent);
	}	

}
