package com.example.rasputility;

import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;



public class RaspUtility {
	private static String FULL_URL_PATTERN = "%1$s%2$s%3$s";
	private final static String HOST = "http://localhost:8080";
	private final static String API =  "/api/temperature";
	private final static String TMP_GIVEN_NUMBER_PATTERN = "/%1$s"; //return record of given number (counting backwards)
	private final static String TMP_TIMESTAMP_PATTERN = "/%1$s/%2$s"; //array of temperature between specified timestamp
	public enum JsonFields { value, timestamp};
	
	public static TemperatureObject getTemperature()
	{
		TemperatureObject[] array = getTemperatureArray(new HashMap<String, String>());
		
		return array[0];
	}
	
	public static TemperatureObject[] getTemperatureArray(HashMap<String, String> params)
	{
		String url = createUrl(params);
		InputStream response = getReponse(url);
		TemperatureObject[] objects = retrieveJsonObjects(response);
		return objects;
	}
	
	private static String createUrl(HashMap<String, String> params)
	{
		String URL="";
		if(params.isEmpty())
		{
			URL = HOST + API;
			return URL;
		}
		
		if(params.containsKey(JsonParameters.number.toString()))
		{
			URL = String.format(FULL_URL_PATTERN, HOST, API, String.format(TMP_GIVEN_NUMBER_PATTERN, params.get(JsonParameters.number.toString())));
			return URL;
		}
		
		URL = String.format(FULL_URL_PATTERN,  HOST, API, String.format(TMP_TIMESTAMP_PATTERN, params.get(JsonParameters.timestampFrom.toString()), params.get(JsonParameters.timestampTo.toString())));
		return URL;
	}
	
	private static InputStream getReponse(String url)
	{
		try {
			URL obj = new URL(url);
			HttpURLConnection con = (HttpURLConnection) obj.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("Content-Type", "application/json");
			con.setRequestProperty("Cache-Control", "no-cache");
			con.setRequestProperty("Salt", "1235");
			con.setRequestProperty("Hash", "1e1a642f16892ef7ca87b2307adafc09");
			return con.getInputStream();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	private static TemperatureObject[] retrieveJsonObjects(InputStream stream){
		InputStream is = stream;
		JsonReader rdr = Json.createReader(is);
		JsonObject obj = rdr.readObject();
		JsonArray results = obj.getJsonArray("data");
		ArrayList<TemperatureObject> elements = new  ArrayList<TemperatureObject>();
		for (JsonObject result : results.getValuesAs(JsonObject.class)) 
		 {
			String value = result.getString(JsonFields.value.toString());
			String timestamp = result.containsKey(JsonFields.timestamp.toString()) == false ? "" : result.getString(JsonFields.timestamp.toString());
			elements.add(new TemperatureObject(timestamp, value));
		 }
		
		return (TemperatureObject[])elements.toArray();
	}
}

class TemperatureObject {
	private String timestamp;
	private String value;
	
	public TemperatureObject(String timestamp, String value){
		this.timestamp = timestamp;
		this.value = value;
	}

	public String getTimestamp() {
		return timestamp;
	}

	public String getValue() {
		return value;
	}
}
