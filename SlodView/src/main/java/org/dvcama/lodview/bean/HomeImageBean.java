package org.dvcama.lodview.bean;

import java.util.ArrayList;
import java.util.List;

public class HomeImageBean {

	public String getResource() {
		return resource;
	}

	public void setResource(String resource) {
		this.resource = resource;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getDateLabel() {
		return dateLabel;
	}

	public void setDateLabel(String dateLabel) {
		this.dateLabel = dateLabel;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getWorkLabel() {
		return workLabel;
	}

	public void setWorkLabel(String workLabel) {
		this.workLabel = workLabel;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	private String resource;
	private String date;
	private String dateLabel;
	private String imageUrl;
	private String label;
	private String workLabel;
	private String year;
	
	private List<String> thumbnails = new ArrayList<String>();

	public List<String> getThumbnails() {
		return thumbnails;
	}

	public void setThumbnails(List<String> thumbnails) {
		this.thumbnails = thumbnails;
	}
	

}
