# 🛒 Aplikasi Toko Kita

## 👤 Informasi Praktikan
- **Nama**: Haniel Wijanarko
- **NIM**: H1D023052
- **Shift Awal / Baru**: F / E
- **Pertemuan**: 11 - BLoC Pattern


## 📱 Deskripsi
Aplikasi **Toko Kita** adalah aplikasi mobile e-commerce sederhana yang dibuat menggunakan **Flutter** dan **CodeIgniter 4** sebagai backend REST API. Pada pertemuan 11 ini, aplikasi telah di-refactor untuk mengimplementasikan **BLoC (Business Logic Component)** pattern sebagai state management solution.

Aplikasi mendemonstrasikan implementasi lengkap operasi CRUD (Create, Read, Update, Delete) produk dengan sistem autentikasi berbasis token menggunakan arsitektur BLoC yang memisahkan business logic dari presentation layer.

## 🏗️ Arsitektur Aplikasi

### 1. Struktur Projek dengan BLoC
```
tokokita/
├── lib/                           # Flutter Frontend
│   ├── main.dart                  # Entry point dengan BlocProvider
│   ├── bloc/                      # 🆕 BLoC Layer
│   │   ├── login_bloc.dart       # LoginBloc, Events & States
│   │   ├── registrasi_bloc.dart  # RegistrasiBloc, Events & States
│   │   └── produk_bloc.dart      # ProdukBloc, Events & States
│   ├── helpers/
│   │   ├── api_url.dart          # Konfigurasi endpoint API
│   │   └── user_info.dart        # Manajemen token & user data
│   ├── model/
│   │   ├── produk.dart           # Model Produk
│   │   ├── login.dart            # Model Response Login
│   │   └── registrasi.dart       # Model Response Registrasi
│   └── ui/                        # 🔄 Presentation Layer (refactored)
│       ├── login_page.dart       # Halaman Login dengan BLoC
│       ├── registrasi_page.dart  # Halaman Registrasi dengan BLoC
│       ├── produk_page.dart      # Halaman List Produk dengan BLoC
│       ├── produk_form.dart      # Halaman Form dengan BLoC
│       └── produk_detail.dart    # Halaman Detail dengan BLoC
│
└── toko-api/                      # CodeIgniter 4 Backend
    ├── app/
    │   ├── Controllers/
    │   │   ├── LoginController.php
    │   │   ├── RegistrasiController.php
    │   │   └── ProdukController.php
    │   └── Models/
    │       ├── MMember.php
    │       ├── MLogin.php
    │       └── MProduk.php
    └── public/
        └── index.php             # Entry point API
```

### 2. BLoC Pattern State Management

Aplikasi ini menggunakan **flutter_bloc** package untuk implementasi BLoC pattern. BLoC memisahkan business logic dari UI layer, making code lebih testable, maintainable, dan scalable.

#### Komponen BLoC Pattern

**1. Events** - User actions yang trigger BLoC
```dart
class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
}
```

**2. States** - Kondisi UI yang di-emit BLoC
```dart
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState { final Login login; }
class LoginFailure extends LoginState { final String error; }
```

**3. BLoC** - Proses business logic & HTTP calls
```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  on<LoginButtonPressed>(_onLoginButtonPressed);
  // Handler: emit(LoginLoading) → http.post → emit(LoginSuccess/Failure)
}
```

**4. UI Integration**
```dart
// main.dart - Setup provider
MultiBlocProvider(
  providers: [
    BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
    // ... other BLoCs
  ],
  child: MaterialApp(...),
)

// UI - Listen & Build
BlocListener<LoginBloc, LoginState>( // Side effects (navigation, dialog)
  listener: (context, state) { /* Navigate on success */ },
  child: BlocBuilder<LoginBloc, LoginState>( // Rebuild UI
    builder: (context, state) { /* Show loading or form */ },
  ),
)

// Trigger event
context.read<LoginBloc>().add(LoginButtonPressed(...));
```

#### Keuntungan BLoC Pattern
✅ **Separation of Concerns**: UI terpisah dari business logic  
✅ **Testability**: BLoC mudah di-test tanpa dependency UI  
✅ **Reusability**: BLoC dapat digunakan di multiple screens  
✅ **Maintainability**: Kode lebih terstruktur dan mudah dikelola  
✅ **State Management**: Centralized state management dengan stream  

### 3. API Integration dengan BLoC
Komunikasi dengan backend menggunakan HTTP requests yang dihandle oleh BLoC:

#### GET - Mengambil Data dengan BLoC
```dart
// Event
class LoadProduk extends ProdukEvent {}

// Handler di BLoC
Future<void> _onLoadProduk(
  LoadProduk event,
  Emitter<ProdukState> emit,
) async {
  emit(ProdukLoading());
  
  try {
    final response = await http.get(Uri.parse(ApiUrl.listProduk));
    var data = json.decode(response.body);
    
    if (data['code'] == 200) {
      List<Produk> listProduk = (data['data'] as List)
          .map((json) => Produk.fromJson(json))
          .toList();
      emit(ProdukLoaded(listProduk: listProduk));
    }
  } catch (e) {
    emit(ProdukFailure(error: e.toString()));
  }
}

// Trigger dari UI
context.read<ProdukBloc>().add(LoadProduk());
```

#### POST - Menambah Data dengan BLoC
```dart
// Event
class CreateProduk extends ProdukEvent {
  final String kodeProduk;
  final String namaProduk;
  final int hargaProduk;
}

// Handler di BLoC
Future<void> _onCreateProduk(
  CreateProduk event,
  Emitter<ProdukState> emit,
) async {
  emit(ProdukLoading());
  
  try {
    final response = await http.post(
      Uri.parse(ApiUrl.createProduk),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "kode_produk": event.kodeProduk,
        "nama_produk": event.namaProduk,
        "harga": event.hargaProduk,
      }),
    );
    
    var data = json.decode(response.body);
    
    if (data['code'] == 200) {
      emit(ProdukOperationSuccess(message: 'Produk berhasil ditambahkan'));
      add(LoadProduk()); // Auto-reload data
    }
  } catch (e) {
    emit(ProdukFailure(error: e.toString()));
  }
}

### 3. API Integration dengan BLoC

**GET - Load Data**
```dart
// Event: LoadProduk → BLoC: http.get() → State: ProdukLoaded(listProduk)
context.read<ProdukBloc>().add(LoadProduk());
```

**POST - Create Data**
```dart
// Event: CreateProduk → BLoC: http.post() → State: ProdukOperationSuccess
context.read<ProdukBloc>().add(CreateProduk(kode, nama, harga));
```

**PUT - Update Data**
```dart
// Event: UpdateProduk → BLoC: http.put() → State: ProdukOperationSuccess
context.read<ProdukBloc>().add(UpdateProduk(id, kode, nama, harga));
```

**DELETE - Delete Data**
```dart
// Event: DeleteProduk → BLoC: http.delete() → State: ProdukOperationSuccess
context.read<ProdukBloc>().add(DeleteProduk(id: produk.id));
```

## 📋 Penjelasan Proses CRUD dengan BLoC Pattern

### 🔐 A. Proses Registrasi

<img src="screenshots/ss%20registrasi%20tokokita.png" width="300" alt="Registrasi Page">

**Flow Registrasi:**
```
User Input (nama, email, password) 
  → RegistrasiButtonPressed event
  → RegistrasiBloc emit RegistrasiLoading
  → HTTP POST ke /registrasi
  → API simpan data (password di-hash)
  → RegistrasiSuccess/Failure
  → Dialog sukses → Navigate ke LoginPage
```

### 🔓 B. Proses Login

<img src="screenshots/ss%20login%20tokokita.png" width="300" alt="Login Page">

**Flow Login:**
```
User Input (email, password)
  → LoginButtonPressed event
  → LoginBloc emit LoginLoading
  → HTTP POST ke /login
  → API validasi & generate token
  → Save token ke SharedPreferences
  → LoginSuccess → Navigate ke ProdukPage
```

### 📦 C. Proses Melihat List Produk (READ)

<img src="screenshots/ss%20list%20produk%20tokokita.jpg" width="300" alt="List Produk">

**Flow Read:**
```
initState() → LoadProduk event
  → ProdukBloc emit ProdukLoading
  → HTTP GET /produk
  → Parse JSON ke List<Produk>
  → ProdukLoaded(listProduk)
  → ListView.builder tampilkan data
```

### ➕ D. Proses Tambah Produk (CREATE)

<img src="screenshots/ss tambah produk tokokita.jpg" width="300" alt="Tambah Produk">

**Flow Create:**
```
User klik FAB (+) → ProdukForm
  → User isi form (kode, nama, harga)
  → Klik "Simpan" → Validasi form
  → CreateProduk event
  → HTTP POST /produk
  → ProdukOperationSuccess
  → Auto-trigger LoadProduk() (refresh list)
  → Dialog sukses → Navigate back
```

### ✏️ E. Proses Ubah Produk (UPDATE)

<img src="screenshots/ss%20ubah%20produk%20tokokita.jpg" width="300" alt="Ubah Produk">

**Flow Update:**
```
User klik produk → ProdukDetail
  → Klik "EDIT" → ProdukForm (pre-filled)
  → User ubah data
  → Klik "Ubah" → UpdateProduk event
  → HTTP PUT /produk/{id}
  → ProdukOperationSuccess
  → Auto-reload → Dialog sukses
```

### 🗑️ F. Proses Hapus Produk (DELETE)

<img src="screenshots/ss%20detail%20produk%20tokokita.jpg" width="300" alt="Detail Produk">

**Flow Delete:**
```
User klik "DELETE" → Dialog konfirmasi
  → User konfirmasi → DeleteProduk event
  → HTTP DELETE /produk/{id}
  → ProdukOperationSuccess
  → Auto-reload → Dialog sukses → Navigate back
```

### 🚪 G. Proses Logout

**Flow Logout:**
```
User klik Drawer → "Logout"
  → UserInfo().logout() (clear SharedPreferences)
  → Navigator.pushAndRemoveUntil → LoginPage
  → Clear navigation stack
```