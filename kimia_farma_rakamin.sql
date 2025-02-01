
SELECT
    -- Memilih kolom transaction_id dan date dari tabel transaksi
    kft.transaction_id,
    kft.date,
    
    -- Mengambil informasi cabang dari tabel kantor cabang (kc)
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,  -- Rating cabang
    
    -- Mengambil nama pelanggan dari tabel transaksi
    kft.customer_name,

    -- Mengambil informasi produk dari tabel produk (kp)
    kft.product_id,
    kp.product_name,

    -- Harga asli produk sebelum diskon
    kft.price AS actual_price,
    
    -- Persentase diskon dari tabel transaksi
    kft.discount_percentage,

    -- Menentukan persentase gross profit berdasarkan harga produk
    CASE 
        WHEN kft.price <= 50000 THEN 0.10
        WHEN kft.price > 50000 AND kft.price <= 100000 THEN 0.15
        WHEN kft.price > 100000 AND kft.price <= 300000 THEN 0.20
        WHEN kft.price > 300000 AND kft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,

    -- Menghitung nett sales setelah diskon diterapkan
    kft.price - (kft.price * kft.discount_percentage) AS nett_sales,

    -- Menghitung nett profit berdasarkan nett sales dan persentase gross laba
    (kft.price - (kft.price * kft.discount_percentage)) *
    CASE 
        WHEN kft.price <= 50000 THEN 0.10
        WHEN kft.price > 50000 AND kft.price <= 100000 THEN 0.15
        WHEN kft.price > 100000 AND kft.price <= 300000 THEN 0.20
        WHEN kft.price > 300000 AND kft.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,

    -- Rating transaksi dari tabel transaksi
    kft.rating AS transaction_rating

-- Mengambil data dari tabel transaksi utama
FROM `kimia_farma.kf_final_transaction` AS kft

-- Menghubungkan dengan tabel kantor cabang berdasarkan branch_id
JOIN `kimia_farma.kf_kantor_cabang` AS kc ON kft.branch_id = kc.branch_id

-- Menghubungkan dengan tabel produk berdasarkan product_id
JOIN `kimia_farma.kf_product` AS kp ON kft.product_id = kp.product_id;


-- Membuat tabel analisis
CREATE TABLE `kimia_farma.tabel_analisis` AS
SELECT
  kft.transaction_id,
  kft.date,
  kc.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  kft.customer_name,
  kft.product_id,
  kp.product_name,
  kp.product_category,
  kft.price AS actual_price,
  kft.discount_percentage,
  CASE 
    WHEN kft.price <= 50000 THEN 0.10
    WHEN kft.price > 50000 AND kft.price <= 100000 THEN 0.15
    WHEN kft.price > 100000 AND kft.price <= 300000 THEN 0.20
    WHEN kft.price > 300000 AND kft.price <= 500000 THEN 0.25
  ELSE 0.30
  END AS persentase_gross_laba,
  kft.price - (kft.price * kft.discount_percentage) AS nett_sales,
  (kft.price - (kft.price * kft.discount_percentage)) *
  CASE 
    WHEN kft.price <= 50000 THEN 0.10
    WHEN kft.price > 50000 AND kft.price <= 100000 THEN 0.15
    WHEN kft.price > 100000 AND kft.price <= 300000 THEN 0.20
    WHEN kft.price > 300000 AND kft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,
  kft.rating AS transaction_rating
FROM `kimia_farma.kf_final_transaction` AS kft
  JOIN `kimia_farma.kf_kantor_cabang` AS kc ON kft.branch_id = kc.branch_id
  JOIN `kimia_farma.kf_product` AS kp ON kft.product_id = kp.product_id
