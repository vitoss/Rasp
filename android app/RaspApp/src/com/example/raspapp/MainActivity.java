package com.example.raspapp;


import com.example.rasputility.RaspUtility;
import android.support.v7.app.ActionBarActivity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends ActionBarActivity {
	private static String ADDRESS = "ADDRESS";
	private static String MENU_BUTTON_ACTIVE = "MENU BUTTON STATE";
	private static String STATUS_LABEL = "CONNECTION STATUS";

	private String address = "http://uj-rasp.no-ip.org";
	private boolean menuButtonActive = false;
	private String statusLabel;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		LoadPreferences();
		haveNetworkConnection();
		setContentView(R.layout.activity_main);
		InitContent();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	private void SavePreferences() {
		SharedPreferences sharedPreferences = getPreferences(MODE_PRIVATE);
		SharedPreferences.Editor editor = sharedPreferences.edit();
		Button menuButton = (Button) findViewById(R.id.rasp_button_goto_menu);
		menuButton.setEnabled(menuButtonActive);
		editor.putBoolean(MENU_BUTTON_ACTIVE, menuButton.isEnabled());
		editor.putString(STATUS_LABEL, statusLabel);
		editor.putString(ADDRESS, address);
		editor.commit();
	}

	private void LoadPreferences() {
		SharedPreferences sharedPreferences = getPreferences(MODE_PRIVATE);

		address = sharedPreferences.getString(ADDRESS, getResources()
				.getString(R.string.rasp_address_default));

		statusLabel = sharedPreferences.getString(STATUS_LABEL, getResources()
				.getString(R.string.rasp_connect_status_result));

		menuButtonActive = sharedPreferences.getBoolean(MENU_BUTTON_ACTIVE,
				false);
	}

	private void InitContent() {
		EditText url = (EditText) findViewById(R.id.rasp_address);
		url.setText(address, TextView.BufferType.EDITABLE);
		TextView statusLabelTxt = (TextView) findViewById(R.id.rasp_connect_status_result);
		statusLabelTxt.setText(statusLabel);
		Button menuButton = (Button) findViewById(R.id.rasp_button_goto_menu);
		menuButton.setEnabled(menuButtonActive);
	}

	@Override
	public void onBackPressed() {
		SavePreferences();
		super.onBackPressed();
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			startActivity(new Intent(
					android.provider.Settings.ACTION_WIFI_SETTINGS));
		} else if (id == R.id.action_check_internet) {
			haveNetworkConnection();
		} else if (id == R.id.action_exit) {
			finish();
			android.os.Process.killProcess(android.os.Process.myPid());
			super.onDestroy();
		}

		return super.onOptionsItemSelected(item);
	}

	public void raspConnectButtonOnClick(View view) {
		EditText url = (EditText) findViewById(R.id.rasp_address);
		TextView res = (TextView) findViewById(R.id.rasp_connect_status_result);
		Button menu = (Button) findViewById(R.id.rasp_button_goto_menu);
		String url_string = url.getText().toString();	
		boolean result = false;
		int code = -1;
		if (!url_string.isEmpty()) {
				code = RaspUtility.getInstance().getTestConnectionResult(url_string);
				if (code == 200)
					result = true;
		}
		result = true;// for debug uncomment
		menu.setEnabled(result); 
		menuButtonActive = result;
		if (result) {
			address = url_string;
			statusLabel = String.valueOf(code); 
			//statusLabel = "SUCCESS";
			res.setText(statusLabel);
		} else {
			address = "";
			statusLabel = "FAIL";
			res.setText(statusLabel);
		}
	}

	public void raspGotoMenuButtonClick(View view) {
		Context ctx = this;
		Intent menu = new Intent(ctx, MenuActivity.class);
		startActivity(menu);
	}
	
	private void haveNetworkConnection() {
		boolean haveConnectedWifi = false;
		boolean haveConnectedMobile = false;

		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo[] netInfo = cm.getAllNetworkInfo();
		for (NetworkInfo ni : netInfo) {
			if (ni.getTypeName().equalsIgnoreCase("WIFI"))
				if (ni.isConnected())
					haveConnectedWifi = true;
			if (ni.getTypeName().equalsIgnoreCase("MOBILE"))
				if (ni.isConnected())
					haveConnectedMobile = true;
		}

		new AlertDialog.Builder(MainActivity.this)
				.setTitle("Internet Connection")
				.setMessage(
						"WIFI connection: "
								+ (haveConnectedWifi == true ? "ON" : "OFF")
								+ "\nMobile connection: "
								+ (haveConnectedMobile == true ? "ON" : "OFF")
								+ "\nAt least one of internet connection is required")
				.setPositiveButton(android.R.string.ok,
						new DialogInterface.OnClickListener() {
							public void onClick(DialogInterface dialog,
									int which) {
							}
						}).setIcon(android.R.drawable.ic_dialog_info).show();
	}
}
