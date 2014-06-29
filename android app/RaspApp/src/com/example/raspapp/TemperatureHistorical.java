package com.example.raspapp;

import com.example.rasputility.RaspUtility;
import com.example.rasputility.TemperatureObject;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class TemperatureHistorical extends ActionBarActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_temperature_historical);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.temperature_historical, menu);
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

	public void raspButtonGoBackOnClick(View view) {
		EditText editTxt = (EditText) findViewById(R.id.rasp_number_edit_text);
		TextView labelTemperature = (TextView) findViewById(R.id.rasp_historical_temperature_label);
		TextView historicalTemperature = (TextView) findViewById(R.id.rasp_historical_temperature_text_view);
		historicalTemperature.setVisibility(View.VISIBLE);
		TextView labelDate = (TextView) findViewById(R.id.rasp_historical_date_label);
		TextView historicalDate = (TextView) findViewById(R.id.rasp_historical_date_text_view);
		if (editTxt.getText().toString().isEmpty()) {
			historicalTemperature.setText("Set number");
			return;
		}
		int number = Integer.parseInt(editTxt.getText().toString());
		TemperatureObject result = RaspUtility.getInstance()
				.getHistoricalTemperature(number);

		labelTemperature.setVisibility(View.VISIBLE);
		labelDate.setVisibility(View.VISIBLE);
		historicalDate.setText(result.getTimestamp());
		historicalDate.setVisibility(View.VISIBLE);
		historicalTemperature.setText(result.getValue());
	}
}
