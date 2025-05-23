package com.shashi.service;

import java.util.List;
import com.shashi.beans.SizeBean;

public interface SizeService {
	String addSize(String sizeName, String productType, Double length, Double width);
    String addSize(SizeBean size);
    String removeSize(String sizeId);
    String updateSize(SizeBean size);
    List<SizeBean> getAllSizes();
    SizeBean getSizeDetails(String sizeId);
    List<SizeBean> getSizesByProductType(String productType);
}