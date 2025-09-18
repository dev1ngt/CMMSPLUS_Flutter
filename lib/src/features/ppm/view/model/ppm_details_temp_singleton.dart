
import 'package:cmms/src/features/ppm/view/model/ppm_details_temp_data.dart';
import 'package:flutter/cupertino.dart';

class PPMDetailsTempSingletonModel with ChangeNotifier {
// Private constructor
  PPMDetailsTempSingletonModel._private();

  // Static instance
  static final PPMDetailsTempSingletonModel _instance = PPMDetailsTempSingletonModel._private();

  // Factory constructor to provide access to the instance
  factory PPMDetailsTempSingletonModel() {
    return _instance;
  }

  PPMDetailsTempModel? _ppmDetailsTempModel;

  PPMDetailsTempModel get ppmDetailsTempModel {
    _ppmDetailsTempModel ??= PPMDetailsTempModel();
    return _ppmDetailsTempModel!;
  }

  void updateAssetData(List<int> assetid, List<String> assetname) {
     ppmDetailsTempModel.assetID = assetid;
     ppmDetailsTempModel.assetName = assetname;
    notifyListeners(); // Notify listeners when the model is updated
  }

  void removeAllTempList(){
    ppmDetailsTempModel.assetID = [];
    ppmDetailsTempModel.assetName = [];
    notifyListeners(); // Notify listeners when the model is updated
  }

}