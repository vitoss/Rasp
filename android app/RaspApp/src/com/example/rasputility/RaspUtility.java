package com.example.rasputility;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.AsyncTask;
import android.view.View;
import android.widget.ProgressBar;

public class RaspUtility {
	private String FULL_URL_PATTERN = "%1$s%2$s%3$s";
	private String HOST;
	private String HOST_HEADER = "uj-rasp.no-ip.org";
	private String API = "/api/temperature";
	private String TEST_API_URL = "/api/temperature/23";
	private String TMP_GIVEN_NUMBER_PATTERN = "/%1$s"; // return record of given
														// number (counting
														// backwards)
	private String TMP_TIMESTAMP_PATTERN = "/%1$s/%2$s"; // array of temperature
															// between specified
															// timestamp
	private static RaspUtility instance;

	public static RaspUtility getInstance() {
		if (instance == null)
			instance = new RaspUtility();
		return instance;
	}

	public enum JsonFields {
		value, timestamp
	};

	public void setHost(String host) {
		HOST = host;
	}

	private RaspUtility() {
	}

	/*
	 * Return current temperature
	 */
	public TemperatureObject getCurrentTemperature() {
		String url = createUrl(new HashMap<String, String>());
		TemperatureObject[] arrayCheck = checkURL(url);
		if (arrayCheck != null) {
			return arrayCheck[0];
		}
		String response = getTemperatureResponse(url);
		TemperatureObject object = retrieveJsonObject(response);
		return object;
	}

	/*
	 * Return Historical Temperature
	 */
	public TemperatureObject getHistoricalTemperature(int number) {
		HashMap<String, String> params = new HashMap<String, String>();
		params.put(JsonParameters.number.toString(), String.valueOf(number));
		String url = createUrl(params);
		TemperatureObject[] arrayCheck = checkURL(url);
		if (arrayCheck != null) {
			return arrayCheck[0];
		}
		String response = getTemperatureResponse(url);
		TemperatureObject object = retrieveJsonObject(response);
		return object;
	}

	public TemperatureObject[] getTemperatureFromTo(String from, String to) {
		String url = createUrl(new HashMap<String, String>());
		TemperatureObject[] arrayCheck = checkURL(url);
		if (arrayCheck != null) {
			return arrayCheck;
		}
		String response = getHistoricalTemperatureResponse(url, from, to);
		TemperatureObject[] objects = retrieveJsonArray(response);
		return objects;
	}

	/*
	 * Test if "host" is responding to our API
	 */
	public int getTestConnectionResult(String host) {
		if (host.isEmpty())
			return 400;
		String test_url = host + TEST_API_URL;
		int code = -1;
		try {
			code = new TestAsyncHttpGet().execute(test_url).get();
		} catch (ExecutionException ex1) {

		} catch (InterruptedException ex2) {

		}
		return code;
	}

	/*
	 * Test if currently set HOST is responding to our API
	 */
	public int getTestConnectionResult() {
		return getTestConnectionResult(HOST);
	}

	private TemperatureObject[] checkURL(String url) {
		if (url.isEmpty()) {
			DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			Date date = new Date();
			return new TemperatureObject[] { new TemperatureObject(dateFormat
					.format(date).toString(), "IN-PROPER DATA") };
		}

		return null;
	}

	private String createUrl(HashMap<String, String> params) {
		String URL = "";
		if (params.isEmpty()) {
			URL = HOST + API;
			return URL;
		} else if (params.containsKey(JsonParameters.number.toString())) {
			URL = String.format(
					FULL_URL_PATTERN,
					HOST,
					API,
					String.format(TMP_GIVEN_NUMBER_PATTERN,
							params.get(JsonParameters.number.toString())));
			return URL;
		} else if (params.containsKey(JsonParameters.timestampFrom.toString())) {
			URL = String.format(FULL_URL_PATTERN, HOST, API, String.format(
					TMP_TIMESTAMP_PATTERN,
					params.get(JsonParameters.timestampFrom.toString()),
					params.get(JsonParameters.timestampTo.toString())));
		}
		return URL;
	}

	private String getTemperatureResponse(String url) {
		try {
			// return new AsyncHttpGetTemperature().execute(url).get();
			return "{\"value\":19.75,\"timestamp\":\"2014-06-22 20:06:02\"}";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private String getHistoricalTemperatureResponse(String url, String from,
			String to) {
		try {
			// return new AsyncHttpGetTemperatureFromTo().execute(url, from,
			// to).get();
			return "[{ value: 22.937, timestamp: \"2014-06-21 09:40:02\"},"
					+ "{ value: 22.937, timestamp: \"2014-06-21 09:41:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:42:02\"},"
					+ "{ value: 22.875, timestamp: \"2014-06-21 09:43:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:44:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:45:02\"},"
					+ "{ value: 22.75, timestamp: \"2014-06-21 09:46:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:47:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:48:02\"},"
					+ "{ value: 22.812, timestamp: \"2014-06-21 09:49:02\"},"
					+ "{ value: 22.75, timestamp: \"2014-06-21 09:50:02\"},"
					+ "{ value: 22.625, timestamp: \"2014-06-21 09:51:02\"},"
					+ "{ value: 22.687, timestamp: \"2014-06-21 09:52:02\"},"
					+ "{ value: 22.625, timestamp: \"2014-06-21 09:53:02\"},"
					+ "{ value: 22.562, timestamp: \"2014-06-21 09:54:02\"},"
					+ "{ value: 22.562, timestamp: \"2014-06-21 09:55:02\"},"
					+ "{ value: 22.562, timestamp: \"2014-06-21 09:56:02\"},"
					+ "{ value: 22.562, timestamp: \"2014-06-21 09:57:02\"},"
					+ "{ value: 22.375, timestamp: \"2014-06-21 09:58:02\"},"
					+ "{ value: 22.312, timestamp: \"2014-06-21 09:59:02\"}]";

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private TemperatureObject retrieveJsonObject(String stream) {
		JSONObject jsonObj = null;
		TemperatureObject element = null;
		try {
			jsonObj = new JSONObject(stream);
			String value = jsonObj.getString(JsonFields.value.toString());
			String timestamp = jsonObj.getString(JsonFields.timestamp
					.toString());
			element = new TemperatureObject(timestamp, value);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return element;
	}

	private TemperatureObject[] retrieveJsonArray(String stream) {
		TemperatureObject[] element = null;
		JSONArray values = null;
		try {
			values = new JSONArray(stream);
			element = new TemperatureObject[values.length()];
			for (int i = 0; i < values.length(); i++) {
				JSONObject obj = values.getJSONObject(i);
				String value = obj.getString(JsonFields.value.toString());
				String timestamp = obj.getString(JsonFields.timestamp
						.toString());
				TemperatureObject tmp = new TemperatureObject(timestamp, value);
				element[i] = tmp;
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return element;
	}

	private class AsyncHttpGetTemperature extends
			AsyncTask<String, Integer, String> {
		@Override
		protected String doInBackground(String... arg0) {
			HttpResponse response = null;
			String output = "";
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet request = generateHttpGet();
				request.setURI(new URI(arg0[0]));
				response = client.execute(request);
				return output = EntityUtils.toString(response.getEntity());
			} catch (URISyntaxException e) {
				e.printStackTrace();
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return output;
		}
	}

	private class AsyncHttpGetTemperatureFromTo extends
			AsyncTask<String, Integer, String> {
		@Override
		protected String doInBackground(String... arg0) {
			HttpResponse response = null;
			String output = "";
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet request = generateHttpGet();
				request.setHeader("Start-Date", arg0[1]);
				request.setHeader("End-Date", arg0[2]);
				request.setURI(new URI(arg0[0]));
				response = client.execute(request);
				return output = EntityUtils.toString(response.getEntity());
			} catch (URISyntaxException e) {
				e.printStackTrace();
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return output;
		}
	}

	private class TestAsyncHttpGet extends AsyncTask<String, Integer, Integer> {
		@Override
		protected Integer doInBackground(String... arg0) {
			HttpResponse response = null;
			int code = -1;
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet request = generateHttpGet();
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

	/*
	 * Set Required Headers for establishing connection
	 */
	private HttpGet generateHttpGet() {
		HttpGet request = new HttpGet();
		request.setHeader("HOST", HOST_HEADER);
		request.setHeader("Content-Type", "application/json");
		request.setHeader("Cache-Control", "no-cache");
		request.setHeader("Salt", "1235");
		request.setHeader("Hash", "57b2e61b964e5ccdfd34d687db049885");
		return request;
	}
}
