package com.example.raspapp;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.concurrent.ExecutionException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.support.v7.app.ActionBarActivity;
import android.support.v4.app.Fragment;
import android.text.Editable;
import android.text.TextWatcher;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.ColorStateList;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.os.Build;

import com.example.rasputility.*;

public class MainActivity extends ActionBarActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);

		if (savedInstanceState == null) {
			getSupportFragmentManager().beginTransaction()
					.add(R.id.container, new PlaceholderFragment()).commit();
		}
		 haveNetworkConnection();
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

		new AlertDialog.Builder(this)
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

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			startActivity(new Intent(android.provider.Settings.ACTION_WIFI_SETTINGS));
		}

		return super.onOptionsItemSelected(item);
	}

	public void raspConnectButtonOnClick(View view) {
		EditText url = (EditText) findViewById(R.id.rasp_address);
		String url_string = url.getText().toString();
		boolean result = false;
		int code = -1;
		if (!url_string.isEmpty()) {
			try {
				url_string +="/api/temperature/23";
				code = new AsyncHttpGet().execute(url_string).get();
				if (code == 200)
					result = true;
			} catch (InterruptedException e) {
				e.printStackTrace();
			} catch (ExecutionException e) {
				e.printStackTrace();
			}
		}
		TextView res = (TextView) findViewById(R.id.rasp_connect_status_result);
		Button menu = (Button) findViewById(R.id.rasp_button_goto_menu);
		menu.setEnabled(result);
		if (result){
			res.setText(String.valueOf("SUCCESS"));
		}
		else{
			res.setText(String.valueOf("FAIL"));
		}
	}

	/**
	 * A placeholder fragment containing a simple view.
	 */
	public static class PlaceholderFragment extends Fragment {

		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_main, container,
					false);
			return rootView;
		}
	}

	private class AsyncHttpGet extends AsyncTask<String, Integer, Integer> {

		@Override
		protected Integer doInBackground(String... arg0) {
			HttpResponse response = null;
			int code = -1;
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet request = new HttpGet();
				request.setHeader("HOST", "uj-rasp.no-ip.org");
				request.setHeader("Content-Type", "application/json");
				request.setHeader("Cache-Control", "no-cache");
				request.setHeader("Salt", "1235");
				request.setHeader("Hash", "57b2e61b964e5ccdfd34d687db049885");
				request.setURI(new URI(arg0[0]));
				response = client.execute(request);
				code = response.getStatusLine().getStatusCode();
			} catch (URISyntaxException e) {
				e.printStackTrace();
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return code;
		}
	}
}
