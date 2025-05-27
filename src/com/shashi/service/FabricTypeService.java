package com.shashi.service;

import java.util.List;
import com.shashi.beans.FabricTypeBean;

public interface FabricTypeService {
    String addFabricType(String fabricTypeName, double pricePerMeter);
    String removeFabricType(String fabricTypeName);
    String updateFabricType(String oldFabricTypeName, FabricTypeBean updatedFabricType);
    List<FabricTypeBean> getAllFabricTypes();
    FabricTypeBean getFabricTypeDetails(String fabricTypeName);
    double getPricePerMeter(String fabricTypeName);
}