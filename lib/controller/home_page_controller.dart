import 'dart:math';

import 'package:get/get.dart';
import 'package:images/models/photo_model.dart';
import 'package:images/services/api_service.dart';

class HomePageController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = true.obs;
  RxString orderBy = "latest".obs;
  RxString apikey = "cjKpZsgq3h2c-OUleVGB44QTZZJfw09U-g_GO03qbJ0".obs;

  RxList<PhotosModel> photos = RxList();
  List<String> orders = [
    'latest',
    'oldest',
    'popular',
    'views',
  ];

  // get
  getPhotos() async {
    isLoading.value = true;
    var response = await ApiService().getMethod(
        "https://api.unsplash.com/photos/?per_page=30&order_by=${orderBy.value}&client_id=$apikey");
    photos = RxList();
    if (response.statusCode == 200) {
      response.data.forEach((element) {
        photos.add(PhotosModel.fromJson(element));
      });
      isLoading.value = false;
    }
  }

  orderFunc(String newVal) {
    orderBy.value = newVal;
    getPhotos();
  }

  @override
  void onInit() {
    getPhotos();
    super.onInit();
  }
}
