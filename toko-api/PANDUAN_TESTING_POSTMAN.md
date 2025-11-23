# Panduan Testing API CRUD Produk di Postman

## Persiapan
1. Pastikan server Laragon sudah running
2. Buka Postman
3. Base URL: `http://localhost/toko-api/public`

---

## 1. CREATE - Tambah Produk Baru

**Method:** `POST`  
**URL:** `http://localhost/toko-api/public/produk`

### Headers:
```
Content-Type: application/json
```

### Body (pilih raw - JSON):
```json
{
    "kode_produk": "PRD001",
    "nama_produk": "Laptop ASUS",
    "harga": 7500000
}
```

### Response yang diharapkan:
```json
{
    "code": 200,
    "status": true,
    "data": {
        "id": 1,
        "kode_produk": "PRD001",
        "nama_produk": "Laptop ASUS",
        "harga": 7500000
    }
}
```

---

## 2. READ ALL - Lihat Semua Produk

**Method:** `GET`  
**URL:** `http://localhost/toko-api/public/produk`

### Headers:
```
(tidak perlu headers khusus)
```

### Response yang diharapkan:
```json
{
    "code": 200,
    "status": true,
    "data": [
        {
            "id": 1,
            "kode_produk": "PRD001",
            "nama_produk": "Laptop ASUS",
            "harga": 7500000
        },
        {
            "id": 2,
            "kode_produk": "PRD002",
            "nama_produk": "Mouse Logitech",
            "harga": 150000
        }
    ]
}
```

---

## 3. READ DETAIL - Lihat Detail Produk

**Method:** `GET`  
**URL:** `http://localhost/toko-api/public/produk/1`  
*(angka 1 adalah ID produk)*

### Headers:
```
(tidak perlu headers khusus)
```

### Response yang diharapkan:
```json
{
    "code": 200,
    "status": true,
    "data": {
        "id": 1,
        "kode_produk": "PRD001",
        "nama_produk": "Laptop ASUS",
        "harga": 7500000
    }
}
```

---

## 4. UPDATE - Ubah Data Produk

**Method:** `PUT`  
**URL:** `http://localhost/toko-api/public/produk/1`  
*(angka 1 adalah ID produk yang akan diubah)*

### Headers:
```
Content-Type: application/json
```

### Body (pilih raw - JSON):
```json
{
    "kode_produk": "PRD001",
    "nama_produk": "Laptop ASUS ROG",
    "harga": 9500000
}
```

### Response yang diharapkan:
```json
{
    "code": 200,
    "status": true,
    "data": {
        "id": 1,
        "kode_produk": "PRD001",
        "nama_produk": "Laptop ASUS ROG",
        "harga": 9500000
    }
}
```

---

## 5. DELETE - Hapus Produk

**Method:** `DELETE`  
**URL:** `http://localhost/toko-api/public/produk/1`  
*(angka 1 adalah ID produk yang akan dihapus)*

### Headers:
```
(tidak perlu headers khusus)
```

### Response yang diharapkan:
```json
{
    "code": 200,
    "status": true,
    "data": true
}
```

---

## Tips Testing di Postman:

### 1. Buat Collection Baru
- Klik "New" → "Collection"
- Beri nama: "Toko API - CRUD Produk"
- Simpan semua request di collection ini

### 2. Simpan Request
- Setelah membuat request, klik "Save"
- Beri nama yang jelas seperti:
  - `Create Produk`
  - `Get All Produk`
  - `Get Detail Produk`
  - `Update Produk`
  - `Delete Produk`

### 3. Gunakan Variables (Opsional)
Di Collection → Variables:
```
Variable: base_url
Initial Value: http://localhost/toko-api/public
```

Lalu gunakan di URL: `{{base_url}}/produk`

### 4. Urutan Testing yang Benar:
1. **CREATE** - Tambah beberapa produk dulu
2. **READ ALL** - Lihat semua produk yang sudah ditambah
3. **READ DETAIL** - Cek detail salah satu produk
4. **UPDATE** - Ubah data produk
5. **DELETE** - Hapus produk (testing di akhir)

---

## Troubleshooting

### Error 404 Not Found
- Pastikan URL sudah benar
- Cek Routes.php sudah dikonfigurasi
- Pastikan mod_rewrite Apache aktif

### Error 500 Internal Server Error
- Cek database sudah dibuat
- Cek tabel `produk` sudah ada
- Lihat error di `writable/logs/`

### Data tidak tersimpan
- Pastikan method HTTP sudah benar (POST untuk create)
- Cek Headers `Content-Type: application/json`
- Pastikan Body format JSON valid

---

## Struktur Tabel Database

Pastikan tabel `produk` sudah dibuat:

```sql
CREATE TABLE produk (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_produk VARCHAR(50) NOT NULL,
    nama_produk VARCHAR(100) NOT NULL,
    harga INT NOT NULL
);
```

---

## Contoh Flow Testing Lengkap:

1. **Tambah Produk 1:**
   - POST `/produk` → Laptop ASUS

2. **Tambah Produk 2:**
   - POST `/produk` → Mouse Logitech

3. **Tambah Produk 3:**
   - POST `/produk` → Keyboard Mechanical

4. **Lihat Semua:**
   - GET `/produk` → Lihat 3 produk

5. **Lihat Detail:**
   - GET `/produk/2` → Detail Mouse Logitech

6. **Update Produk:**
   - PUT `/produk/2` → Ubah harga Mouse

7. **Hapus Produk:**
   - DELETE `/produk/3` → Hapus Keyboard

8. **Cek Hasil:**
   - GET `/produk` → Lihat sisa 2 produk

---

**Selamat mencoba! 🚀**
