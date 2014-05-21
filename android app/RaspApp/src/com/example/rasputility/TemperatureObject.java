package com.example.rasputility;

public class TemperatureObject {
	private String timestamp;
	private String value;

	public TemperatureObject(String timestamp, String value) {
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
