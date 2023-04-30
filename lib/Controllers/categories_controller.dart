import 'package:get/get.dart';
import 'package:moneyboi/Constants/enums.dart';
import 'package:moneyboi/Constants/urls.dart';
import 'package:moneyboi/Data%20Models/api_response_model.dart';
import 'package:moneyboi/Data%20Models/expense_category.dart';
import 'package:moneyboi/Network/network_service.dart';

class CategoriesController extends GetxController {
  final NetworkService _apiService = NetworkService();

  // Variable that will contain the list of categories.
  // This list should be fetched once on the app start and will hold the values
  // until app closure.
  final _categoriesMain = <ExpenseCategory>[].obs();

  // Getter for the _categoriesMain list.
  List<ExpenseCategory> get categories => _categoriesMain;

  @override
  void onInit() {
    _populateCategories();
    super.onInit();
  }

  void _populateCategories() async {
    final ApiResponseModel _categoriesResp;

    try {
      _categoriesResp = await _apiService.networkCall(
          networkCallMethod: NetworkCallMethod.GET,
          authenticated: false,
          endPointUrl: getCategoriesEndPoint);

      if (_categoriesResp.statusCode == 200 &&
          _categoriesResp.responseJson != null) {
        for (var i in _categoriesResp.responseJson!.data) {
          _categoriesMain.add(ExpenseCategory.fromJson(i));
        }
      }
    } catch (e) {}
  }
}
