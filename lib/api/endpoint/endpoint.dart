class Endpoint {
  static const String baseURL = "https://applaundry.mobileprojp.com/api";
  static const String register = "$baseURL/register";
  static const String login = "$baseURL/login";
  static const String profile = "$baseURL/me";
  static const String updateProfile = "$baseURL/profile";
  static const String order = "$baseURL/orders";
  static const String kategori = "$baseURL/categories";
  static const String layanan = "$baseURL/layanan";
  static const String items = "$baseURL/items";
  static const String status = "$baseURL/orders";
  static String statusEndpoint(int orderId) => "$baseURL/orders/$orderId/status";
  static const String logout = "$baseURL/logout";
}
