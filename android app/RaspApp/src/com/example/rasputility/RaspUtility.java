package com.example.rasputility;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.os.AsyncTask;

public class RaspUtility {
	private String FULL_URL_PATTERN = "%1$s%2$s%3$s";
	private String HOST;
	private String HOST_HEADER = "uj-rasp.no-ip.org";
	private String API = "/api/temperature";
	private String TMP_GIVEN_NUMBER_PATTERN = "/%1$s"; // return record of given
														// number (counting
														// backwards)
	private String TMP_TIMESTAMP_PATTERN = "/%1$s/%2$s"; // array of temperature
															// between specified
															// timestamp

	public enum JsonFields {
		value, timestamp
	};

	public RaspUtility(String host){
		HOST = host;
	}
	
	public TemperatureObject getTemperature() {
		TemperatureObject[] array = getTemperatureArray(new HashMap<String, String>());

		return array[0];
	}

	public TemperatureObject[] getTemperatureArray(
			HashMap<String, String> params) {
		String url = createUrl(params);
		InputStream response = getReponse(url);
		TemperatureObject[] objects = retrieveJsonObjects(response);
		return objects;
	}

	private String createUrl(HashMap<String, String> params) {
		String URL = "";
		if (params.isEmpty()) {
			URL = HOST + API;
			return URL;
		}

		if (params.containsKey(JsonParameters.number.toString())) {
			URL = String.format(
					FULL_URL_PATTERN,
					HOST,
					API,
					String.format(TMP_GIVEN_NUMBER_PATTERN,
							params.get(JsonParameters.number.toString())));
			return URL;
		}

		URL = String.format(FULL_URL_PATTERN, HOST, API, String.format(
				TMP_TIMESTAMP_PATTERN,
				params.get(JsonParameters.timestampFrom.toString()),
				params.get(JsonParameters.timestampTo.toString())));
		return URL;
	}

	private InputStream getReponse(String url) {
		try {
			return new AsyncHttpGet().execute(url).get();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	private TemperatureObject[] retrieveJsonObjects(InputStream stream) {
		InputStream is = stream;
		JsonReader rdr = Json.createReader(is);
		JsonObject obj = rdr.readObject();
		JsonArray results = obj.getJsonArray("data");
		ArrayList<TemperatureObject> elements = new ArrayList<TemperatureObject>();
		for (JsonObject result : results.getValuesAs(JsonObject.class)) {
			String value = result.getString(JsonFields.value.toString());
			String timestamp = result.containsKey(JsonFields.timestamp
					.toString()) == false ? "" : result
					.getString(JsonFields.timestamp.toString());
			elements.add(new TemperatureObject(timestamp, value));
		}

		return (TemperatureObject[]) elements.toArray();
	}

	private class AsyncHttpGet extends AsyncTask<String, Integer, InputStream> {

		@Override
		protected InputStream doInBackground(String... arg0) {
			HttpResponse response = null;
			InputStream inputStr = null;
			try {
				HttpClient client = new DefaultHttpClient();
				HttpGet request = new HttpGet();
				request.setHeader("HOST", HOST_HEADER);
				request.setHeader("Content-Type", "application/json");
				request.setHeader("Cache-Control", "no-cache");
				request.setHeader("Salt", "1235");
				request.setHeader("Hash", "57b2e61b964e5ccdfd34d687db049885");
				request.setURI(new URI(arg0[0]));
				response = client.execute(request);
				inputStr = (response.getEntity() == null ? null : response
						.getEntity().getContent());
			} catch (URISyntaxException e) {
				e.printStackTrace();
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			return inputStr;
		}
	}

}

