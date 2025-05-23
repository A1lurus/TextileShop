package com.shashi.service;

import java.io.InputStream;
import java.util.List;
import com.shashi.beans.FabricBean;

public interface FabricService {
    // Updated method signature
    String addFabric(String fabricTypeName, String color, InputStream image);
    String addFabric(FabricBean fabric);
    String removeFabric(String fabricId);
    String updateFabric(FabricBean fabric);
    List<FabricBean> getAllFabrics();
    FabricBean getFabricDetails(String fabricId);
    byte[] getFabricImage(String fabricId);
    List<FabricBean> getFabricsByType(String fabricType);
}