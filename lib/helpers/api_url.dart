class ApiUrl {
  // Base URL API - Sesuaikan dengan lokasi API Anda
  // Gunakan IP komputer untuk testing di device fisik
  static const String baseUrl = "http://10.99.4.182:8080";
  
  // Alternatif untuk testing:
  // - Localhost: "http://localhost/toko-api/public"
  // - Android Emulator: "http://10.0.2.2/toko-api/public"

  // Endpoint Registrasi
  static const String registrasi = "$baseUrl/registrasi";

  // Endpoint Login
  static const String login = "$baseUrl/login";

  // Endpoint Produk
  static const String listProduk = "$baseUrl/produk";
  static const String createProduk = "$baseUrl/produk";

  // Endpoint Produk dengan ID
  static String showProduk(int id) {
    return "$baseUrl/produk/$id";
  }

  static String updateProduk(int id) {
    return "$baseUrl/produk/$id";
  }

  static String deleteProduk(int id) {
    return "$baseUrl/produk/$id";
  }
}
