# 👑 HUKUM MUTLAK & STANDAR BAKU PEMBUATAN GAME ROBLOX — BROTHER HUB
**Dokumen Resmi Pedoman Arsitektur, Spasial, Visual, 3D Blender & Gameplay Roblox Studio**  
*Otoritas Tertinggi: Founder & Lead Developer prawiraxliv*  
*Status: 100% Mandatory & Enforced across all Game Generations*

---

## 🏛️ 13 HUKUM MUTLAK PEMBUATAN GAME ROBLOX STUDIO

### 1. 🎨 HUKUM 1: 100% FULL CUSTOM BLENDER 3D MODELING (ANTI-PRIMITIF ROBLOX & MINIMAL MESH TOOLBOX BAWAAN)
- **Larangan Keras & Bukti Nyata**:
  * **DILARANG KERAS MENYUSUN PART PRIMITIF ROBLOX**: Jangan pernah menyusun balok `Blok`, `Bola`, `Wedge`, `Wedge Sudut`, atau `Silinder` dari menu Part bawaan Roblox untuk membuat furnitur, peralatan, atau props!
  * **JANGAN TERLALU BANYAK MEMAKAI MESH BAWAAN / TOOLBOX ROBLOX**: Mesh bawaan toolbox publik seringkali tidak konsisten, memiliki collision berantakan, poly count rusak, atau berisiko copyright/virus script tersembunyi.
- **Standar Baku**:
  * Seluruh furnitur, peralatan, sanitari, rintangan, monster, dan props utama **WAJIB 100% DIBUAT CUSTOM MENGGUNAKAN BLENDER 3D (BLENDER 5.2 PYTHON API)**.
  * Aset-aset yang wajib custom Blender:
    - Wastafel porselen custom (`BackroomsBathroomSink.obj`).
    - Toilet porselen custom (`BackroomsBathroomToilet.obj`).
    - Perosotan tabung custom (`BackroomsCurvedTubeSlide.obj` & `BackroomsWaterslideMouth.obj`).
    - Senter taktikal custom (`TacticalFlashlight.obj`).
    - Monster entitas Bacteria wireframe custom (`BackroomsEntity_Bacteria.obj`).
    - Rumah suburban custom (`SuburbanHouse.obj`).
    - Pipa ventilasi langit-langit custom (`CeilingVentPipe.obj`).
    - Dudukan lampu fluorescent custom (`FluorescentLightFixture.obj`).
  * **PEWARNAAN PBR & WARNA ASLI BLENDER (ANTI SILUET HITAM POLOS)**:
    - Setiap model custom dari Blender **WAJIB MEMILIKI WARNA & MATERIAL YANG HIDUP**. Dilarang keras membiarkan model menjadi siluet hitam pekat seolah bayangan tanpa detail ("blendernya customnya ada warna nya dong, masa hitam gini aja").
    - Berikan vertex color, material diffuse, atau properti `Color` & `Material` Roblox yang pas (porselen putih bersih `(250, 250, 252)`, perosotan kuning cerah `(255, 215, 0)`, senter tactical matte dark-grey dengan lens emitter neon cerah).

---

### 2. 🏔️ HUKUM 2: ARSITEKTUR ELEVASI TINGGI POSITIF (ANTI-VOID DEATH / ZERO KEMATIAN KARENA VOID)
- **Larangan Keras**:
  * **DILARANG MEMBANGUN SEMAKIN KE BAWAH (Y NEGATIF)**: Dilarang keras menempatkan stage di koordinat Y negatif (`Y = -50`, `Y = -100`, `Y = -200`, dst) karena engine Roblox memiliki batas `FallenPartsDestroyHeight` yang seketika membunuh karakter pemain (`Health = 0`) atau melenyapkan part ("ingat ya jangan semakin ke bawah, nanti malah mati, jadi bikin nya di tempat tinggi").
- **Standar Baku**:
  * Seluruh stage, level obby, ruangan, dan transisi **WAJIB DIBANGUN DI ELEVASI TINGGI POSITIF YANG AMAN**.
  * Contoh Pembagian Elevasi Spasial:
    - **Stage 1 (Level Awal / The Maze)**: Dibangun di ketinggian aman `Y = 200` (Lantai di `Y = 200.5`, Plafon di `Y = 216`).
    - **Transisi Meluncur (Perosotan / Chute)**: Meluncur turun secara bertahap dan aman dari `Y = 200` menuju `Y = 50`.
    - **Stage 2 (Level Lanjutan / The Dark Suburbs)**: Terletak di ketinggian `Y = 50` (Jauh di atas `Y = 0`, 100% aman dari void death).

---

### 3. 🛡️ HUKUM 3: DINDING KELILING LUAR 100% TERTUTUP RAPAT (ANTI-VOID / ZERO GAK ADA PINGGIRANNYA)
- **Larangan Keras**:
  * Dilarang membiarkan map atau stage terbuka di bagian pinggir sehingga pemain menatap void hitam atau langit kosong ("malah jadi gak ada pinggirannya, coba buat lagi dari 0").
- **Standar Baku**:
  * Setiap stage WAJIB memiliki **Dinding Keliling Luar (Perimeter Boundary Walls)** di seluruh 4 batas mata angin:
    - `PerimeterNorth` (Batas Utara)
    - `PerimeterSouth` (Batas Selatan)
    - `PerimeterEast` (Batas Timur)
    - `PerimeterWest` (Batas Barat)
  * Dinding keliling wajib berdiri kokoh dari permukaan lantai hingga menyentuh plafon tanpa celah sedikitpun.
  * Dari sudut lorong mana pun, pemain tidak boleh melihat ke luar batas map.

---

### 4. 🛝 HUKUM 4: ZERO NABRAK LANTAI PADA PEROSOTAN & ELEMEN TUBE / MESH
- **Larangan Keras**:
  * Dilarang membiarkan model perosotan (slide mesh / tube) tertanam atau menembus lantai dasar secara kasar ("nabrak lantai perosotannya juga").
- **Standar Baku**:
  * Bibir masuk perosotan (*slide entrance mouth*) wajib diposisikan pas di atas lantai (`Y` bibir bawah sejajar permukaan lantai) atau diberikan tangga / platform pijakan yang presisi.
  * Lantai tepat di bawah mulut perosotan yang mengarah ke bawah WAJIB diberi lubang tembus (*clean floor opening / cut-out*) yang pas dengan diameter tabung luncur.
  * Pemain yang duduk meluncur masuk ke tabung tanpa pernah terbentur permukaan lantai.

---

### 5. 🗺️ HUKUM 5: SPATIAL ALLOCATION REGISTRY (ARSITEKTUR KOORDINAT RESMI & ZERO TABRAKAN ANTAR RUANGAN)
- **Larangan Keras**:
  * Dilarang menempatkan partisi atau dinding secara acak yang memotong masuk atau menembus ke dalam ruangan lain ("ingat posisi y x dan lain-lain, jadi ketika upgrade stage tau locationnya dan tidak nabrak").
- **Standar Baku**:
  * Setiap Stage, Sub-Stage, dan Ruangan Khusus wajib memiliki **Domain Koordinat Terdaftar (Spatial Allocation Registry)**:
    `[X_min .. X_max] x [Y_min .. Y_max] x [Z_min .. Z_max]`
  * Seluruh partisi di dalam ruangan hanya boleh berada di dalam bounding box yang telah dialokasikan.
  * Sambungan antar ruangan (seperti lorong labirin menuju kamar mandi) wajib menggunakan kusen pintu (*doorway frame*) yang terukur dan rapi. Dinding lama di area bukaan wajib dibersihkan total.

---

### 6. 🏛️ HUKUM 6: PROPORSI TINGGI REALISTIS (ANTI TIANG RAKSASA MENEMBUS ANGKASA)
- **Larangan Keras**:
  * Dilarang membuat pilar, tiang, atau part vertikal dengan ukuran ekstrem yang menembus plafon atau melesat ratusan stud ke langit hampa ("ini juga tiang tinggi amat, ngulang aja dari 0").
- **Standar Baku**:
  * Seluruh tiang penyangga struktural (*support pillars*) WAJIB memiliki tinggi yang tepat sama dengan tinggi ruangan (`Height = CeilingHeight = 15 studs` / dari lantai `Y = 200.5` ke plafon `Y = 215.5`).
  * Tidak boleh ada part struktural yang melampaui batas plafon atau melayang di atas langit.

---

### 7. 🚫 HUKUM 7: ZERO CSG UNION (0 UNIONOPERATION)
- **Larangan Keras**: Dilarang menggunakan operasi CSG Union (`UnionOperation` / Negate Part) dalam bentuk apa pun.
- **Standar Baku**:
  * Gunakan 100% **3D MeshPart Asli** hasil ekspor Blender atau susunan part modular bersih yang solid.

---

### 8. 🔤 HUKUM 8: ZERO TOFU MISSING GLYPH BOXES PADA UI / GUI
- **Larangan Keras**: Dilarang menggunakan emoji atau simbol unicode non-standar yang tidak didukung font Roblox sehingga muncul kotak kosong (`▯` / tofu glyph).
- **Standar Baku**:
  * Wajib 100% menggunakan karakter **ASCII Standar Bersih**:
    - Gunakan `[!]` untuk peringatan / info.
    - Gunakan `>>` atau `->` untuk penunjuk arah.
    - Gunakan `●` atau `-` untuk bullet points.
    - Gunakan pipe `|` atau slash `/` untuk pemisah.

---

### 9. 🔦 HUKUM 9: FLASHLIGHT / TOOL STANDBY POINTING FORWARD (ARM LOCK TRACKING)
- **Larangan Keras**: Dilarang membiarkan senter atau alat tangan berayun ke bawah dan ke belakang saat karakter berjalan atau berlari mengikuti animasi default Roblox ("ketika lagi jalan , senternya kenapa ikut ke bawah gerakan tangan, ga bisa standby senterin ke depan pas nyala").
- **Standar Baku**:
  * Senter wajib memiliki controller lokal (`RunService.RenderStepped`) yang mengunci lengan kanan (`RightShoulder.Transform = CFrame.Angles(math.rad(90) + cameraPitch, 0, 0)`).
  * Senter selalu siaga mengarah lurus ke depan dan sorot lampunya mengikuti arah pandangan kamera vertikal pemain.

---

### 10. 📸 HUKUM 10: VERIFIKASI VISUAL MANDIRI VIA SCREEN CAPTURE & FOTO
- **Larangan Keras**: Dilarang menyatakan suatu pekerjaan selesai tanpa melakukan inspeksi visual langsung melalui tangkapan layar.
- **Standar Baku**:
  * Setiap selesai merombak struktur, membangun ruangan, atau menata props, AI WAJIB mengambil screenshot (`screen_capture`) dan membaca gambarnya (`read_file`).
  * Periksa alignment dinding, lantai, posisi props, dan pencahayaan untuk memastikan 100% presisi dan estetis.

---

### 11. ⚓ HUKUM 11: FULL ANCHOR (100% ANCHORED)
- **Standar Baku**:
  * Seluruh elemen struktural (lantai, plafon, dinding keliling, partisi, perosotan, wastafel, toilet, tiang lampu) WAJIB berstatus `Anchored = true` dan `CanCollide = true` (kecuali sensor trigger yang `CanCollide = false`).
  * Tidak boleh ada part yang jatuh atau runtuh akibat gravitasi saat permainan dimulai.

---

### 12. 🧹 HUKUM 12: PROTOKOL REBUILD DARI 0 (CLEAN SLATE PROTOCOL)
- **Standar Baku**:
  * Saat merombak atau membangun ulang stage yang bermasalah / glitched, lakukan pembersihan total pada folder target di DataModel sebelum men-generate yang baru.
  * Pastikan 0 part hantu, 0 partisi lama yang tertinggal, dan 0 dinding tumpang tindih.

---

### 13. ⚡ HUKUM 13: OPTIMASI LOGIKA LUAU & PERFORMANCE CHUNKING
- **Standar Baku**:
  * Eksekusi Luau bulk creation wajib dibagi dalam chunk terstruktur agar tidak memblokir main thread Studio.
  * Hindari loop tanpa yield; gunakan `task.wait()` per batch.

---

### 14. 🕳️ HUKUM 14: ZERO SEAM GAPS & ZERO BOLONG (ANTI-VOID GAP PROTOCOL)
- **Larangan Keras**:
  * **DILARANG KERAS ADA BOLONG / CELAH**: Dilarang membiarkan ada celah udara, garis hitam tembus void, atau retakan antara dinding dengan dinding lain, dinding dengan lantai, atau antara dua ruangan yang bersebelahan ("ADA BOLONG, TOLONG DI CATET JUGA AGAR TIDAK TERJADI SEPERTI INI!!").
- **Standar Baku**:
  * Setiap sambungan sudut ruangan, kusen pintu, dan perbatasan antar level WAJIB memiliki **Corner Junction Pillar** atau **Doorway Frame** yang menutupi celah secara presisi (margin overlap minimal 0.05 stud).
  * Pemain yang melihat ke segala sudut dinding TIDAK BOLEH melihat langit hitam/void tembus keluar map!

---

### 15. ⚡ HUKUM 15: ZERO Z-FIGHTING & ZERO NABRAK ANTARA PART (ANTI-OVERLAPPING COPLANAR FACES)
- **Larangan Keras**:
  * **DILARANG MEMASANG DUA DINDING DI KOORDINAT YANG SAMA**: Dilarang keras menumpuk dua part/dinding dengan tekstur/material berbeda pada koordinat X/Y/Z yang sama, yang menyebabkan tekstur bergerigi, robek segitiga, dan flickering parah ("JANGAN ADA GLITCH NABRAK ANTARA PART TOLONG KERAPIHANNYA DI CATET JUGA!!!").
- **Standar Baku**:
  * Dinding pemisah antar ruangan wajib merupakan **Single Shared Partition** atau diberi kusen pemisah (Arch Frame) dengan ketebalan yang jelas, bukan dua dinding berbeda yang saling bertubrukan di koordinat yang sama.

---

### 16. 🚫 HUKUM 16: BLOKIR KOMPONEN — 100% SINGLE MESH UTUH (ANTI-SPAM KOMPONEN / ZERO KOTAK TOY)
- **Larangan Keras**:
  * **BLOKIR KOMPONEN**: Dilarang keras menyusun satu objek utilitas (seperti toilet, wastafel, perosotan) dari belasan part balok primitif (`Basin`, `DrainHole`, `Faucet`, `WaterTank`, `Bowl`, `Seat`, `TubeFloor_1`..`TubeFloor_30`) yang membebani Explorer dan tampak seperti mainan balok lego murahan ("kenapa kamu membuatnya pake komponen, SAYA BILANG FULL BLENDER ASTAGA, blokir komponen ya , tolong full custom blender!!!").
- **Standar Baku**:
  * Seluruh furnitur, peralatan, dan saluran perosotan wajib berwujud **Single Mesh / MeshPart / SpecialMesh Utuh** buatan Blender 3D atau model terpadu tanpa ada ratusan pecahan komponen part kecil.

---

### 17. 🚪 HUKUM 17: PROPORSI DIMENSI REALISTIS (ANTI-LUBANG ANJING / ZERO TERLALU KECIL UNTUK AVATAR)
- **Larangan Keras**:
  * Dilarang membuat bukaan pintu, mulut perosotan, atau lorong terlalu sempit sehingga avatar pemain tidak muat atau kepalanya membentur kusen ("orang mana bisa masuk sekecil itu, INGAT FULL BLENDER custom").
- **Standar Baku**:
  * Dimensi karakter avatar Roblox: Lebar 4 studs, Tinggi 5 studs, Tebal 2 studs.
  * Ukuran bukaan portal perosotan dan pintu masuk WAJIB minimal:
    - **Lebar**: Minimal 8 - 10 studs!
    - **Tinggi**: Minimal 9 - 12 studs!
  * Mulut perosotan wajib luas, lega, dan mengundang pemain untuk meluncur dengan mulus tanpa terbentur.

---

### 18. 🌊 HUKUM 18: AIR NYATA ROBROX TERRAIN (REAL TERRAIN WATER HYDRODYNAMICS)
- **Standar Baku**:
  * Seluruh air di kolam renang (The Poolrooms) dan genangan basah WAJIB menggunakan **Roblox Terrain Water** (`workspace.Terrain:FillBlock` / `FillBall`) dengan wave size, transparency, dan refleksi air asli!
  * Pemain yang masuk ke dalam air otomatis mendapatkan fisika renang nyata (swimming mechanics, suara deburan air, dan efek menyelam).

---

### 19. 🌌 HUKUM 19: GRAND SCALE MACRO EXPEDITION (SUPER VAST BACKROOMS UNIVERSE)
- **Standar Baku**:
  * Backrooms bukan lorong sempit berdekatan, melainkan dunia liminal yang SANGAT LUAS:
    1. **Level 0: The Infinite Yellow Maze** (Luas 250x250 studs).
    2. **The Bathrooms** (Kamar Mandi Komunal Mewah Ubin Marmer & Wastafel/Toilet Blender).
    3. **The Giant Yellow Water Slide** (Perosotan Tabung Kuning Raksasa Mulus Tanpa Retakan).
    4. **Level 9: The Dark Suburbs** (Jalan aspal panjang berkabut, tiang lampu jalan, taman rumput luas dengan pagar kayu, dan RUMAH SUBURBAN YANG BISA DIMASUKI dengan interior lengkap).
    5. **Level 37: The Poolrooms (Sublimity)** (Kolam renang porselen putih/cyan monumental, pilar-pilar arkade raksasa, air jernih berkilau dengan Terrain Water).
    6. **Level 1: The Underground Concrete Parking Garage** (Tempat parkir beton raksasa bertingkat dengan tiang nomor dan mobil terbengkalai).
    7. **Level 33: The Abandoned Shopping Mall** (Mall megah terbengkalai dengan atrium kaca, toko-toko retail, eskalator, dan lampu gantung).
    8. **Level 18: The Playrooms** (Taman bermain anak dengan kolam bola raksasa, tabung warna-warni, dan rintangan playground).
    9. **Sistem Checkpoint Otomatis & Teleport**: Menyimpan kemajuan stage pemain agar tidak perlu mengulang dari awal jika respawn.

---

### 20. 💡 HUKUM 20: ZERO LIGHT-WALL INTERSECTION (ANTI-LAMPU TERPOTONG DINDING)
- **Larangan Keras**:
  * **DILARANG KERAS DINDING MENEMBUS LAMPU**: Dilarang membiarkan dinding partisi menabrak, membelah, atau memotong fixture lampu fluorescent plafon menjadi segitiga bergerigi ("GLITCH LAMPU, TOLONG KERAPIHANNYA MANA, BUAT YANGRAPIH BANGET").
- **Standar Baku**:
  * Seluruh lampu neon / fixture plafon HANYA BOLEH diletakkan di **Area Terbuka / Tengah Koridor (Center of Hallway/Corridor)** yang bebas dari partisi dinding.
  * Sebelum memasang partisi dinding, periksa koordinat lampu; jika ada dinding pada koordinat tersebut, lampu tersebut wajib digeser atau dinding berakhir tepat di bawah clearance lampu.
  * Uji visual pada seluruh sudut plafon untuk memastikan setiap lampu utuh berbentuk persegi panjang rapi tanpa terpotong dinding!

---

### 21. 🌌 HUKUM 21: SKALA MAKRO MONUMENTAL (SUPER VAST / SELUAS MUNGKIN — MINIMAL 600..1200 STUDS PER STAGE)
- **Larangan Keras**:
  * **DILARANG MAP SEMPIT / KERDIL**: Dilarang keras membuat ruangan kecil-kecil yang berdekatan atau koridor sempit yang cepat habis ("kurang luas, saya bilang LUAS BANGET, TAU LUAS BANGET GAK SIH SELUAS MUNGKIN MAP NYA").
- **Standar Baku**:
  * Setiap stage Backrooms WAJIB berskala monumental dan raksasa:
    - **Stage 1 (Level 0: The Maze)**: Minimal `600 x 600 studs` labirin monoyellow tak berujung.
    - **The Bathrooms**: Minimal `120 x 80 studs` dengan deretan wastafel & toilet porselen mewah serta bukaan mulut perosotan raksasa (`16 x 16 studs`).
    - **The Yellow Tube Slide**: Perosotan tabung raksasa sepanjang `350+ studs` dengan kurva mulus tanpa retakan.
    - **Stage 2 (Level 9: The Dark Suburbs)**: Minimal `1,200 x 1,200 studs` jalan raya aspal berkabut, lampu jalan, taman rumput luas berpagar, dan rumah-rumah suburban yang bisa dimasuki.
    - **Stage 3 (Level 37: The Poolrooms)**: Minimal `1,000 x 1,000 studs` kolam renang porselen raksasa dengan AIR ASLI (Terrain Water) yang bisa direnangi.
    - **Stage 4 (Level 1: Parking Garage)**: Minimal `800 x 800 studs` tempat parkir beton bawah tanah.
    - **Stage 5 (Level 33: The Abandoned Mall)**: Minimal `800 x 800 studs` mall 2 lantai dengan atrium dan toko-toko retail.
    - **Stage 6 (Level 18: The Playrooms)**: Minimal `600 x 600 studs` taman bermain warna-warni dengan mandi bola raksasa.

---

### 22. 🏃 HUKUM 22: KOMPATIBILITAS AVATAR TINGGI (RTHRO/ANTHRO) & AVATAR PENDEK BLOCKY (CLEARANCE MINIMAL TINGGI 14 STUDS & LEBAR 18 STUDS)
- **Larangan Keras**:
  * **DILARANG BUKAAN SEMPIT / PENDEK**: Dilarang membuat terowongan atau pintu yang hanya pas untuk avatar pendek sehingga avatar tinggi Rthro/Anthro membentur atau tidak muat ("BISA MUAT UNTUK AVATAR TINGGI DAN AVATAR PENDEK KOTAK DEFAULT, YANG DI MAKSUD AVA TINGGI ADALAH AVATAR JAMAN NOW").
  * **DILARANG TULISAN SIGN TERTUTUP / KROPING**: Dilarang memasang papan tulisan yang tenggelam ke dalam plafon atau tertutup kusen sehingga baris tulisan terpotong ("TULISANNYA TERTUTUP").
- **Standar Baku**:
  * Clearance bukaan portal dan perosotan WAJIB memiliki dimensi minimal:
    - **Tinggi Bukaan**: Minimal `14 studs` (bebas kepala untuk avatar Rthro/Anthro).
    - **Lebar Bukaan**: Minimal `18 studs` (bebas bahu untuk avatar blocky default).
  * Papan nama SurfaceGui / Neon Sign WAJIB diposisikan dengan offset vertikal yang pas di bawah plafon atau di tengah balok kusen atas, sehingga 100% teks terbaca sempurna dari sudut pandang pemain.

---

### 23. 🏛️ HUKUM 23: PRINSIP KUSEN PROUD / EMBOSSED (ZERO COPLANAR COLLISION PADA PORTAL & FRAME)
- **Larangan Keras**:
  * **DILARANG KUSEN MENABRAK DINDING (Z-FIGHTING ROBEK SEGITIGA)**: Dilarang keras menanam part kusen portal atau frame perosotan di koordinat Z/X yang sama dengan part dinding, yang menyebabkan permukaan kuning dan marmer bertabrakan dan menghasilkan robekan segitiga bergerigi ("plis lah glicth gini tuh di cek juga sedetail itu lho di cek semua dan catet semuanya agar tidak salah terus").
- **Standar Baku**:
  * Setiap kusen portal perosotan, arch frame, dan trim dekoratif WAJIB:
    - **Opsi A (Embossed / Proud)**: Diletakkan menonjol minimal `0.3 studs` ke depan dari permukaan dinding (`Z_frame = Z_wall - 1.2`), sehingga wajah depan frame berdiri sendiri tanpa menyentuh bidang dinding.
    - **Opsi B (Non-Overlapping Opening)**: Bukaan dinding dipotong pas dengan ukuran luar frame, sehingga frame masuk seutuhnya ke dalam bukaan tanpa tumpang tindih 1 milimeter pun dengan dinding samping.
  * Uji zoom-in pada setiap sudut pertemuan sudut frame dengan dinding: Wajib 100% mulus dengan garis batas tegas tanpa ada flickering tekstur!

---

### 24. 🚰 HUKUM 24: ORIENTASI ROTASI FURNITUR WAJIB SESUAI ANATOMI (ANTI-TERBALIK / ZERO KERAN DI DEPAN)
- **Larangan Keras**:
  * **DILARANG SINK / TOILET TERBALIK**: Dilarang keras memasang wastafel terbalik di mana keran air berada di sisi depan menusuk dada pemain sementara mangkok wastafel menempel ke dinding ("inget aturan hukum ini masukin, jangan ke balik di catat agar tidak salah").
  * **DILARANG SILUET HITAM PEKAT**: Seluruh aset porselen sanitari dilarang berpenampilan hitam pekat tanpa pencahayaan dan material.
- **Standar Baku**:
  * **Wastafel Porselen (Sink)**:
    - Keran dan tuas air (`Faucet`) WAJIB berada di sisi belakang menempel ke dinding (misal menghadap East Wall di `X = 550`).
    - Mangkok wastafel (`Bowl`) WAJIB menjulur ke depan menghadap tengah ruangan tempat pemain berdiri.
    - Warna: Porselen putih cerah `Color3.fromRGB(250, 250, 252)`, `Material = SmoothPlastic`.
  * **Toilet Porselen**:
    - Tangki air (`Water Tank`) WAJIB menempel rapat di dinding belakang.
    - Mangkuk dudukan (`Bowl`) menjulur ke depan menghadap pintu bilik.
  * Verifikasi orientasi visual 100% sebelum difinalisasi!

---

### 25. 📉 HUKUM 25: ANTI-NUMPUK PART & ZERO REDUNDANSI FLOATING (OPTIMASI PERFORMANSI & ZERO LAG)
- **Larangan Keras**:
  * **DILARANG NUMPUK PART BERLEBIHAN DI SATU TEMPAT**: Dilarang keras menumpuk belasan part tipis, lempengan mengambang ganda (`CounterApron`, `VanityCounter`), atau part seal berlapis-lapis yang membebani engine fisik, menyebabkan lag berat (*frame drop*), dan merusak tampilan visual ("jangan pernah banyak numpuk di 1 tempat komponen gini, seperti part apapun, itu buat nge lag map lho banyak part").
- **Standar Baku**:
  * **Arsitektur Mandiri & Bersih**:
    - Wastafel pedestal MeshPart berdiri kokoh dari lantai porselen langsung, bebas dari lempengan meja mengambang yang memotong leher wastafel.
    - Portal perosotan hanya terdiri dari 1 arch frame dan 1 kesatuan tangga yang solid, tanpa belasan part kecil yang saling tumpang tindih.
    - Prioritaskan efisiensi part dan gunakan MeshPart tunggal untuk memaksimalkan FPS pemain!

---

### 26. 🚫 HUKUM 26: 100% BLOKIR TOTAL KOMPONEN MULTI-PART PADA UTILITAS (SINGLE 1 MESHPART MANDATE)
- **Larangan Keras**:
  * **BLOKIR KOMPONEN MULTI-PART TOTAL**: Dilarang keras memecah satu objek furnitur/utilitas menjadi puluhan anak part balok di Explorer (`BowlWater`, `FlushLever`, `TankLid`, `ToiletBowl`, `ToiletPaperRoll`, `ToiletPedestal`, `ToiletSeat`, `WaterTank`, `FrontPanel`, `StallWallNorth`, `StallWallSouth`) ("sumpah ini banyak banget komponen, tolong meshpart bentuk di banyakin, komponen apapun itu di blokir total, kan blender setau saya bentuk 1 meshpart, kenapa komponen pake part banyak, lu pake blender beneran gak sih?").
- **Standar Baku**:
  * Setiap furnitur porselen (toilet, wastafel), peralatan, dan utilitas WAJIB berwujud **SATU (1) KESATUAN MESH TUNGGAL (ClassName: MeshPart)**.
  * Hierarki di Explorer harus bersih dan profesional: 1 Toilet = 1 `MeshPart`, 1 Sink = 1 `MeshPart`!

---

### 27. 🔍 HUKUM 27: VERIFIKASI VISUAL MENDALAM DARI SUDUT EKSTREM (ANTI-BOLONG GAIB / ZERO BLINDSPOT)
- **Larangan Keras**:
  * **DILARANG HANYA MELIHAT DARI TENGAH RUANGAN**: Dilarang hanya mengambil screenshot umum dari tengah ruangan yang menyembunyikan retakan samping atau celah di balik tiang/pintu ("ini malah bolong foto ke 2 hadeh rusak aja terus , bukannya benerin detail mendalem di catat semuanya").
- **Standar Baku**:
  * Prosedur Audit Visual Wajib:
    1. **Overview View**: Tampilan umum ruangan dari pintu masuk.
    2. **Side Profile View**: Tampilan miring dari samping untuk memeriksa ketebalan dan sambungan sudut.
    3. **Close-Up Junction View**: Zoom-in hingga jarak 2 studs pada pertemuan kusen dengan dinding luar/dalam.
    4. **Reverse View**: Mengambil foto berbalik arah dari dalam terowongan/pintu melihat ke arah ruangan untuk memastikan tidak ada celah void hitam di bagian belakang lantai/kusen.
  * Setiap celah yang ditemukan seketika ditutup dengan part junction flush tanpa toleransi celah udara!

---

### 28. 🌌 HUKUM 28: DEDIKASI WAKTU BERMAIN PANJANG & DUPLIKASI CLONE GAME BACKROOMS RESMI (MACRO EXPEDITION & LONG PLAYTIME)
- **Larangan Keras**:
  * **DILARANG MAP CEPAT SELESAI / KERDIL**: Dilarang membuat map yang bisa ditelusuri hanya dalam 2-3 menit. Backrooms sejati wajib luas tak berujung ("buat yang sangat luas banget super luas, ingat ya luas banget, masih kurang yang sekarang, sehingga player bisa memainkan game ini agak lama, buat yang luas banget seperti baackroom beneran dan banyak ruangannya").
- **Standar Baku**:
  * Struktur Ekspedisi Skala Monumental (Total Playtime 45 - 60+ Menit):
    1. **Level 0: The Infinite Yellow Maze** (`1,200 x 1,200 studs`): Labirin mono-yellow raksasa dengan lorong tak berujung, lampu neon berdengung, dan pintu keluar rahasia di sudut jauh.
    2. **The Bathrooms** (`120 x 80 studs`): Fasilitas kamar mandi komunal marmer mewah dengan deretan wastafel pedestal MeshPart, bilik toilet MeshPart, dan genangan air reflektif.
    3. **The Giant Yellow Water Slide** (`380+ studs length`): Perosotan tabung kuning raksasa mulus ber-AC dengan physics meluncur duduk otomatis.
    4. **Level 9: The Dark Suburbs** (`1,200 x 1,200 studs`): Pemukiman kota suburban malam berkabut dengan jalan raya aspal 2 jalur, lampu jalan tinggi, taman rumput berpagar luas, dan 3 RUMAH SUBURBAN YANG BISA DIMASUKI dengan interior ruang tamu, dapur, dan kamar tidur lengkap.
    5. **Level 37: The Poolrooms (Sublimity)** (`1,000 x 1,000 studs`): Kompleks kolam renang porselen putih/cyan raksasa dengan AIR NYATA (Roblox Terrain Water) yang bisa direnangi, pilar arkade raksasa, dan cahaya cyan menenangkan.
    6. **Level 1: The Underground Concrete Parking Garage** (`1,000 x 1,000 studs`): Tempat parkir bawah tanah beton bertingkat dengan ratusan tiang nomor (`A-01` s/d `D-40`), garis parkir, speed bump, pipa saluran atas, dan mobil terbengkalai.
    7. **Level 33: The Abandoned Shopping Mall** (`1,000 x 1,000 studs`): Mall retail megah 2 lantai dengan atrium kaca, etalase toko vintage (Arcade, Records, Fashion), dan eskalator.
    8. **Level 18: The Playrooms** (`800 x 800 studs`): Taman bermain anak penuh warna dengan kolam bola raksasa, tabung merangkak plastik, dan piramida busa.

---

### 29. 💾 HUKUM 29: SISTEM CHECKPOINT OTOMATIS & FAST-TRAVEL SERVICE ELEVATOR
- **Standar Baku**:
  * Setiap stage memiliki trigger checkpoint yang otomatis memperbarui spawn point pemain saat disentuh, memunculkan notifikasi VHS di layar.
  * Di setiap level utama disediakan **Service Elevator / Hub Door** yang memungkinkan pemain berpindah antar stage yang telah berhasil dibuka, menjamin kenyamanan pemain dalam menjelajahi seluruh alam semesta Backrooms tanpa frustrasi kehilangan progres!

---

### 30. 📐 HUKUM 30: MATEMATIKA BATAS LANTAI MUTLAK (ZERO-TOLERANCE FLOOR BOUNDARY / ZERO OVERLAPPING FLOORS)
- **Larangan Keras**:
  * **DILARANG LANTAI SALING TUMPANG TINDIH (NABRAK Z-FIGHTING LANTAI)**: Dilarang keras dua lantai bersebelahan (misal karpet Maze dan marmer Bathroom) memiliki koordinat Z yang beririsan walaupun hanya 1 stud, yang menimbulkan robekan saw-tooth flickering pada lantai di depan pintu ("bolong dan nabrak").
- **Standar Baku**:
  * **Garis Batas Atomik (Snap to Split Coordinate)**:
    - Jika pembatas pintu berada di `Z = 600.0`:
      * `MazeFloor` WAJIB berakhir tepat di `Z = 600.0` (Center: `Z = 300.0`, Size Z: `600.0`).
      * `BathroomFloor` WAJIB mulai tepat di `Z = 600.0` (Center: `Z = 660.0`, Size Z: `120.0`).
    - Toleransi overlap: **TEPAT 0.000 STUD**.
  * **Ambang Pintu (Door Saddle Threshold)**:
    - Pasang part `DoorSaddle` dari bahan kayu/marmer setebal 2 studs di `Z = 600.0` dengan elevasi `Y = 200.55` (+0.05 stud lebih tinggi dari lantai) sebagai penutup transisi mulus dan elegan.

---

### 31. 🎯 HUKUM 31: KONSISTENSI LEBAR LUBANG DAN LEBAR TABUNG PEROSOTAN (ZERO VOID GAP PADA PORTAL)
- **Larangan Keras**:
  * **DILARANG LEBAR TABUNG LEBIH KECIL DARI BUKAAN DINDING (BOLONG KE ANGKASA)**: Dilarang keras memotong lubang dinding selebar 22-24 studs sementara tabung perosotan hanya berukuran 16-18 studs, yang menyisakan celah hitam menganga tembus ke void di sisi samping kiri/kanan ("bolong dan nabrak").
- **Standar Baku**:
  * Dimensi bukaan dinding WAJIB SAMA PERSIS dengan dimensi luar tabung perosotan:
    - Jika tabung perosotan memiliki lebar `18 studs` (`X: 491.0 .. 509.0`) dan tinggi `12 studs` (`Y: 202.0 .. 214.0`):
      * Dinding kiri berakhir tepat di `X = 491.0`.
      * Dinding kanan mulai tepat di `X = 509.0`.
      * Lintel atas mulai tepat di `Y = 214.0`.
      * Sill bawah berakhir tepat di `Y = 202.0`.
    - Tabung perosotan langsung menempel rapat ke dinding tanpa celah 1 milimeter pun!

---

### 32. 📱 HUKUM 32: UNIVERSAL MULTI-PLATFORM COMPATIBILITY (100% SUPPORT MOBILE, PC & CONSOLE)
- **Larangan Keras**:
  * Dilarang membuat antarmuka atau kontrol yang hanya bisa dimainkan di PC menggunakan keyboard ("catet juga support mobile, support pc, support semuanya").
- **Standar Baku**:
  * **UI Responsif Dinamis (`UIScale`)**:
    - Seluruh HUD (VHS Camcorder, teks lokasi, indikator stamina senter) dipasang `UIScale` otomatis yang menyesuaikan rasio viewport layar HP Android, iPhone, iPad, dan monitor PC (skala clamp 0.45 s/d 1.15).
  * **Kontrol Sentuh Mobile On-Screen Touch Buttons**:
    - Di layar perangkat sentuh (Mobile/Tablet via `UserInputService.TouchEnabled`), sediakan tombol bulat virtual transparan di sudut kanan bawah:
      * Tombol **🏃 [LARI]** (Sprint Toggle)
      * Tombol **🔦 [SENTER]** (Flashlight Toggle)
      * Tombol **✋ [AKSI]** (Interact Button)
  * **Dukungan Penuh PC & Gamepad**:
    - Keyboard: `Shift` (Sprint), `F` (Flashlight), `E` / Klik Kiri (Interact).
    - Gamepad: `ButtonL3` (Sprint), `ButtonY` (Flashlight), `ButtonX` (Interact).

---

### 33. 🚀 HUKUM 33: OPTIMASI PERFORMANSI SUPER RINGAN (ZERO LAG / 60 FPS DI SEMUA PERANGKAT)
- **Larangan Keras**:
  * Dilarang menggunakan geometri berulang yang berat atau penumpukan part berlebih yang membuat FPS drop di ponsel ("dan semua nya ringan, jangan ada yang saling nabrak, rapih semua").
- **Standar Baku**:
  * Seluruh aset struktural harus rapi dan bersih dari part hantu atau tumpukan lapis ganda.
  * Gunakan `MeshPart` tunggal untuk model detail tinggi (toilet, wastafel, furnitur, mobil).
  * Cahaya lampu dibatasi radiusnya (Range maksimal 32-40 studs) dengan `Shadows` teroptimasi agar tidak membebani GPU perangkat mobile.

---

### 34. 🌌 HUKUM 34: SKALA SUPER EKSPANSI MAKSIMAL (MONUMENTAL MULTI-STAGE BACKROOMS UNIVERSE)
- **Standar Baku**:
  * Peta Backrooms wajib sangat luas dan diperluas secara bertahap ke seluruh stage ikonik lore Backrooms ("luas nya di luasin banget super banget lagi di perluaskan banget lagi"):
    1. **Level 0 (The Lobby)**: Labirin mono-yellow raksasa.
    2. **The Bathrooms**: Kamar mandi komunal ubin porselen marmer dengan deretan wastafel & bilik toilet MeshPart.
    3. **The Giant Yellow Slide**: Terowongan perosotan tabung kuning mulus tanpa sambungan rusak.
    4. **Level 9 (The Dark Suburbs)**: Jalan raya aspal panjang berkabut, lampu jalan, taman berpagar luas, dan rumah suburban yang bisa dimasuki.
    5. **Level 37 (The Poolrooms)**: Kompleks kolam renang porselen putih/cyan monumental dengan AIR NYATA (Roblox Terrain Water).
    6. **Level 1 (Underground Parking Garage)**: Tempat parkir bawah tanah beton raksasa bertingkat dengan ratusan tiang nomor dan mobil terbengkalai.
    7. **Level 33 (The Abandoned Mall)**: Mall megah 2 lantai dengan atrium kaca, eskalator, dan toko-toko retail.
    8. **Level 18 (The Playrooms)**: Taman bermain penuh warna dengan mandi bola raksasa dan tabung merangkak.
    9. **Sistem Checkpoint & Hub Fast-Travel**: Menjamin petualangan berdurasi panjang tanpa kehilangan progres.

---

### 35. 🎨 HUKUM 35: 100% FULL CUSTOM BLENDER MESHES (ANTI-KOMPONEN PART BALOK SECARA OTOMATIS & PERMANEN)
- **Larangan Keras**:
  * **DILARANG MENYUSUN PART BALOK UNTUK FURNITUR & PROPS**: Dilarang keras membuat furnitur atau utilitas dari pecahan balok-balok Roblox primitif. Seluruh props WAJIB 100% berwujud MeshPart tunggal buatan Blender ("FULL BLENDER CUSTOM FULL BLENDER JUGA DI CATET , KAYA GINI GAK PERLU SAYA BILANG CATET MULU").
- **Standar Baku**:
  * Setiap objek detail (toilet, wastafel, cermin, lampu meja, sofa, mobil, perosotan) WAJIB berupa **Single MeshPart** dengan UV mapping dan pewarnaan PBR yang pas.
  * Catat dan terapkan secara otomatis di setiap generasi baru tanpa perlu menunggu instruksi berulang dari Founder!

---

### 36. 🚪 HUKUM 36: DILARANG MENANAM PART KUSEN DI DALAM PART DINDING (ZERO INSET CLIPPING FRAMES)
- **Larangan Keras**:
  * **DILARANG MENUSUKKAN PART KUSEN KE DALAM DINDING**: Dilarang keras menaruh part tiang kusen (`DoorFrame_L`, `DoorFrame_R`) di koordinat yang sama dengan dinding pembatas (`PerimeterSouthLeft`, `PerimeterSouthRight`), yang mengakibatkan dua part bertabrakan di `Z = 600` dan memunculkan garis belang gelap bergerigi z-fighting ("glicht/nabrak catet hukum kaya ginian di cek di foto saya bilang selalu ambil foto otomatis di cek lah semua bagiannya").
- **Standar Baku**:
  * Ujung part dinding kiri (`X = 488`) dan ujung part dinding kanan (`X = 512`) SUDAH MEMBENTUK KUSEN ALAMI yang rapi, solid, dan sempurna.
  * Hapus seluruh part kusen sisipan (`DoorFrame_L`, `DoorFrame_R`) yang memicu tumpang tindih.
  * Ambang batas pintu (`DoorSaddle`) di lantai dan balok lintel atas (`DoorwayLintel`) sudah cukup membingkai portal secara estetis dengan toleransi 0 collision!

---

### 37. 🎨 HUKUM 37: 100% FULL CUSTOM SUITE — VFX, BLENDER, SUARA, SISTEM (ANTI-ASSET GRATISAN & TOOLBOX)
- **Larangan Keras**:
  * **DILARANG KERAS MEMAKAI ASSET GRATISAN / TOOLBOX MODEL ASAL**: Dilarang mengambil model gratisan acak dari toolbox yang membawa skrip malware, bloat part, atau tumpukan balok primitif ("CATAT INI VFX , BLENDER, SUARA, SISTEM FULL CUSTOM, JANGAN ADA GRATISAN , SEMUA HARUS FULL CUSTOM BLENDER DAN LAIN-LAINNYA").
- **Standar Baku**:
  * **3D Geometri**: 100% MeshPart tunggal buatan Blender atau geometri matematika solid murni yang dihitung presisi.
  * **Visual Effects (VFX)**: Sistem partikel, lighting atmosferik, kabut volumetrik, dan VHS chromatic aberration dibuat secara kustom dan disetel manual sesuai tema lore.
  * **Audio / Suara**: Soundscape terisolasi di tiap level (buzzing 60Hz Level 0, gemericik air Bathrooms, angin menderu Slide Chute, gaung bawah air Poolrooms, jingle distorsi Playrooms) menggunakan audio verified berkualitas tinggi.
  * **Sistem Scripting**: Arsitektur Luau modular kustom (Checkpoint, Controller, UI, Sound Ambient) tanpa ketergantungan plugin pihak ketiga.

---

### 38. 🕳️ HUKUM 38: TOLERANSI NOL LOBANG KE VOID (ZERO VOID LEAKS / 100% AIRTIGHT ENCLOSURES)
- **Larangan Keras**:
  * **DILARANG ADA CELAH/LOBANG HITAM MENUJU LUAR ANGKASA/VOID**: Dilarang membiarkan sambungan antara portal dinding dengan terowongan/chute/lorong menyisakan celah terbuka ("banyak amat bolong nya, lu blender gak sih ini?").
- **Standar Baku**:
  * Setiap sambungan antara ruangan dengan terowongan melengkung/miring WAJIB memiliki **Collar Tunnel Segi-4 Lurus (Through-Wall Collar)** yang menembus ketebalan dinding secara penuh (ketebalan minimal 2-4 studs) sebelum kurva miring dimulai.
  * Sudut-sudut pertemuan wajib dipasang bevel flange pengunci agar dari sudut pandang manapun kamera pemain melihat, **0.000 studs kekosongan luar terlihat**.

---

### 39. 📏 HUKUM 39: ZERO PENETRATION PADA ELEMEN TANGGA & PLATFORM (WIDTH-MATCHED STAIRS)
- **Larangan Keras**:
  * **DILARANG LEBAR TANGGA/PLATFORM MELEBIHI BUKAAN DINDING**: Dilarang membuat anak tangga (`Step1`, `Step2`) atau bordes (`MainPlatform`) lebih lebar daripada bukaan kusen pintu, yang mengakibatkan ujung tangga menusuk/menembus tembus ke dalam dinding marmer di kiri-kanannya ("glitch/nabrak" - media_1794064046985_ab2532d6.jpg & media_1794064166079_8a424235.jpg).
- **Standar Baku**:
  * Jika bukaan dinding berukuran lebar `18.0 studs` (dari `X = 491.0` hingga `X = 509.0`), maka lebar seluruh anak tangga dan platform WAJIB `<= 17.8 studs` (misalnya `17.8 studs` simetris di `X = 500.0`, membentang dari `X = 491.1` sampai `X = 508.9`).
  * Tersisa clearance aman `0.1 stud` di tiap sisi sehingga tidak pernah ada satu milimeter pun part tangga yang menembus ubin atau marmer dinding!

---

### 40. 💾 HUKUM 40: SISTEM CHECKPOINT RESMI & KONEKSI LENGKAP ANTAR-STAGE (SEAMLESS EXPEDITION)
- **Larangan Keras**:
  * **DILARANG MEMBIARKAN STAGE TERPUTUS ATAU CHECKPOINT TIDAK TERDAFTAR**: Dilarang membangun stage tanpa trigger checkpoint yang benar-benar tersambung ke `ServerScriptService.BackroomsCheckpointManager` ("jangan lupa buat sistem checkpoint, buat semua stage nya yang tadi saya minta backroom benerna masa lupa sih, masa harus saya prompt melulu semuanya lakuin kamu kerjain semuanya").
- **Standar Baku**:
  * Seluruh 6 stage Backrooms wajib memiliki trigger fisik `CheckpointTrigger_<StageName>` yang terdaftar dan aktif.
  * ServerScriptService menyimpan progres checkpoint tiap `UserId` dan mengembalikan posisi pemain saat respawn ke stage tertinggi yang telah dicapai.
  * Setiap stage wajib memiliki jalur transisi fisik yang nyata dan logis:
    - Stage 1 (Maze) -> The Bathrooms: Pintu Selatan `Z = 600`.
    - The Bathrooms -> Stage 2 (Suburbs): Prosotan Tabung Kuning (`YellowSlideChute`).
    - Stage 2 (Suburbs) -> Stage 3 (Poolrooms): Tangga basement Rumah Suburban 1 (`SuburbanHouse_1`).
    - Stage 3 (Poolrooms) -> Stage 4 (Parking Garage): Pintu palka baja bawah air / lorong drainase porselen.
    - Stage 4 (Parking Garage) -> Stage 5 (The Mall): Pintu kaca otomatis & eskalator Area P36.
    - Stage 5 (The Mall) -> Stage 6 (Playrooms): Pintu gerbang pelangi `FUN ZONE` di ujung koridor mall.
  * Sediakan bilik elevator utilitas Backrooms (`ServiceElevator`) di setiap stage sebagai sarana fast-travel instan ke seluruh stage yang sudah terbuka!

---

### 42. 👁️ HUKUM 42: SISTEM ENTITAS MATA MENGINTIP & HOROR PSIKOLOGIS (THE WATCHING EYES & HALLUCINATION SUITE)
- **Karakteristik & Lore Backrooms Asli**:
  * Seperti di Kane Pixels, *Escape the Backrooms*, dan lore orisinal, di sudut-sudut gelap, ujung lorong buntu, jendela rumah Level 9, dan bawah air Level 37, **KADANG MUNCUL SEPASANG MATA MENYALA (THE WATCHING EYES)** yang mengawasi pemain secara acak lalu lenyap saat disorot senter atau didekati ("kadang muncul mata itu kaya backroom beneran di catet ini harus di buat dan lain lainyna masih banyak yang belum dibuat nanti nya").
- **Standar Baku Pembuatan**:
  1. **Visual Model (Custom 3D / MeshPart & Billboards)**:
     - Sepasang bola mata menyala (Emissive Neon Glow / SurfaceGui / Particle Emitter) berwarna kuning redup `Color3.fromRGB(255, 230, 100)` atau merah darah `Color3.fromRGB(255, 60, 60)` dengan pupil mata bergerak melacak posisi pemain (`HumanoidRootPart`).
  2. **Mekanisme Spawn & Despawn Halusinasi Acak**:
     - Skrip client/server memantau jarak pemain. Setiap interval 20-45 detik di area sepi/gelap, mata muncul di sudut bayangan (jarak 30-70 studs di depan kamera pemain).
     - Menatap mata selama > 1.5 detik memicu efek psikologis: detak jantung berdegup (`Heartbeat.Sound`), distorsi VHS chromatic aberration menguat, dan bisikan lirih.
     - Begitu pemain menyorotkan senter tepat ke mata atau mendekatinya dalam jarak 12 studs, mata berkedip cepat (*blink animation*) lalu menghilang menjadi kabut partikel hitam halus (`BlackSmokePuff`) tanpa meninggalkan jejak!
  3. **Multi-Stage Behavior**:
     - **Level 0 (The Maze)**: Muncul di ujung tikungan lorong buntu di antara dua tiang.
     - **The Bathrooms**: Muncul di balik celah pintu bilik toilet yang setengah terbuka atau pantulan cermin.
     - **Level 9 (The Dark Suburbs)**: Mengintip dari balik kaca jendela lantai 2 rumah suburban berkabut.
     - **Level 37 (The Poolrooms)**: Muncul di dasar kolam terdalam berbayang ubin cyan.
     - **Level 1 (Parking Garage)**: Muncul di balik ban/kaca mobil terbengkalai.
     - **Level 18 (The Playrooms)**: Muncul di dalam lubang tabung merangkak dan mandi bola.

---

### 43. 📸 HUKUM 43: AUDIT FOTO MULTI-SUDUT MANDIRI SEBELUM PENYELESAIAN (SELF-VERIFY PHOTO LOOP)
- **Larangan Keras**:
  * Dilarang menyatakan pekerjaan selesai sebelum melakukan `screen_capture` dari sudut-sudut kritis dan membaca hasil foto tersebut via `read_file` untuk memastikan tidak ada lagi glitch atau celah yang tersisa.
- **Standar Baku**:
  * Tangkap minimal 3 foto inspeksi detail:
    1. Zoom-in sambungan prosotan tabung kuning dari dalam Bathrooms (verifikasi 0 gap dan 0 tangga menusuk).
    2. Inspeksi kusen pintu Maze-Bathrooms (verifikasi 0 z-fighting).
    3. Inspeksi transisi antar-stage dan HUD checkpoint.

---

### 44. 🛋️ HUKUM 44: 100% REALISTIC HIGH-FIDELITY BLENDER MESHPARTS UNTUK FURNITUR RUMAH & PROPS (ANTI-KOTAK PRIMITIF & ZERO KOMPONEN PECAHAN)
- **Larangan Keras**:
  * **DILARANG MERAKIT FURNITUR DARI KOTAK BALOK PRIMITIF ROBLOX**: Dilarang keras membuat kasur dari lempengan balok kaku (`BedMattress`, `BedHeadboard`), sofa dari dua balok (`SofaCushion`, `SofaBack`), atau meja dari balok polos yang kaku dan tidak realistis ("klo bikin object, bangku, kasur rumah, dll itu pake blender bentukkan, jangan pernah pake komponen, di blender juga jangan buat sederhana, tapi detail kaya realistik , DI CATAT KAYA GINI" - media_1794064586476_920490ab.jpg).
  * **BLOKIR TOTAL KOMPONEN MULTI-PART DI EXPLORER**: Dilarang memecah satu set kasur atau satu sofa menjadi beberapa part anak.
- **Standar Baku**:
  * **1 Kasur = 1 Single Realistic MeshPart**: Berwujud tempat tidur lengkap dengan ukiran rangka kayu, kasur empuk dengan lekukan kain/selimut, dan bantal 3D berkontur realistis.
  * **1 Sofa = 1 Single Realistic MeshPart**: Sofa santai dengan lekukan busa empuk, sandaran tangan berprofil, dan tekstur kain/kulit berkerut alami.
  * **1 Meja / Kulkas / TV = 1 Single Realistic MeshPart**: Meja kopi berprofil kaki melengkung, kulkas dengan handel pintu 3D, dan TV tabung CRT retro 80-an dengan antena dan kenop putar.
  * Terapkan secara seragam di seluruh rumah suburban (`SuburbanHouse_1`, `SuburbanHouse_2`, `SuburbanHouse_3`) dan ruangan lainnya!

---

### 45. 💡 HUKUM 45: ZERO LIGHT FIXTURE OFFSET PUNCH-THROUGH (ANTI-LAMPU TEMBUS KELUAR DINDING / VOID PENETRATION)
- **Larangan Keras**:
  * **DILARANG LAMPU MENUSUK KELUAR DINDING / TEROWONGAN**: Dilarang keras menaruh fixture lampu neon (`TubeGlow`, fluorescent strip, lempengan neon) dengan ukuran atau offset X/Z yang melenceng keluar dari dinding terowongan/ruangan, sehingga part lampu menusuk tembus ke luar angkasa/void ("tubeglow buat apa ini pada keluar offset , ingat di catet offset nya juga, hadeh, kenapa sih saya capek nge prompt lho" - media_1794064658968_1957e76f.png & media_1794064685702_bf6fa11f.png).
  * **DILARANG MEMBIARKAN PART HANTU DARI VERSI LAMA**: Hapus bersih seluruh part fixture lama yang tertinggal saat terowongan digeser atau diregenerasi.
- **Standar Baku**:
  * Setiap fixture pencahayaan interior terowongan WAJIB:
    - **Lebar Aman Proporsional**: Lebar fixture lampu maksimal `4.0 .. 6.0 studs` (pada koridor selebar `16.0 studs`), menjamin jarak clearance minimal `5.0 studs` dari dinding kiri dan kanan!
    - **Terpusat di Plafon**: Posisi CFrame wajib dipasang menempel di plafon interior (`RoofCF * CFrame.new(0, -0.3, 0)`), 100% berada di dalam rongga terowongan.
    - **Zero Protrusion**: Dilarang ada 1 milimeter pun part yang menembus sisi luar dinding (`CanCollide = false`, `CastShadow = false`).

---

### 46. 🪧 HUKUM 46: ZERO CEILING TEXT CUTOFF & PROPORTIONAL SIGN OFFSET (ANTI-TEKS KEPOTONG PLAFON)
- **Larangan Keras**:
  * **DILARANG PAPAN NAMA MENUSUK PLAFON**: Dilarang menempatkan part papan penunjuk arah / neon sign (`SlideSign`, `DoorSign`, `RoomSign`) terlalu tinggi sehingga menembus plafon dan memotong baris teks atas secara horizontal ("textnya hadeh" - media_1794064700866_952db2b1.jpg & media_1794064713812_7bb35f9d.png).
- **Standar Baku**:
  * **Clearance Plafon Wajib**: Bagian atas part sign (`Y + Size.Y/2`) WAJIB berada minimal `0.6 .. 1.0 stud` di bawah plafon ruangan (`Y_top <= 214.5` pada ruangan berplafon `215.5`).
  * **Padding & Text Scaling**:
    - SurfaceGui WAJIB dilengkapi `UIPadding` (Top/Bottom = 10px, Left/Right = 14px).
    - Teks diletakkan tepat di tengah balok arch frame atas dengan rasio proporsional, font bold monospaced/clean, dan 100% huruf terbaca utuh dari sudut manapun!

---

### 47. 🧭 HUKUM 47: SISTEM PENUNJUK ARAH ANTAR-STAGE & OBJEKTIF DINAMIS (STAGE TRANSITION GUIDANCE & IN-GAME BREADCRUMBS)
- **Larangan Keras**:
  * **DILARANG MEMBIARKAN PEMAIN BINGUNG TANPA PETUNJUK**: Dilarang membangun peta ekspansif ribuan studs tanpa menyediakan petunjuk arah fisik di dalam dunia 3D dan objektif di antarmuka kamera VHS ("antar stage itu kemana aja, ada petunjuk di setiap antar stage untuk ke next stage").
- **Standar Baku Alur Rute & Petunjuk Antar-Stage**:
  1. **Stage 1 (Level 0: The Maze) ➔ The Bathrooms**:
     - *Lokasi Transisi*: Pintu bukaan dinding Selatan di koordinat `X = 500, Z = 600`.
     - *Petunjuk Fisik*: Papan neon hitam-kuning besar `DoorSign` (`RESTROOMS [ THE BATHROOMS ] >> PROSOTAN TABUNG KUNING >>`) dan panah karpet di persimpangan utama.
     - *Objektif VHS*: `[ OBJEKTIF: Telusuri labirin mono-yellow ke arah Selatan menuju Restrooms ]`
  2. **The Bathrooms ➔ Stage 2 (Level 9: The Dark Suburbs)**:
     - *Lokasi Transisi*: Mulut perosotan tabung kuning di koordinat `X = 500, Z = 720`.
     - *Petunjuk Fisik*: Papan neon menyala `SlideSign` (`GIANT YELLOW TUBE SLIDE >> LEVEL 9: THE DARK SUBURBS >>`) tepat di atas tangga kuning.
     - *Objektif VHS*: `[ OBJEKTIF: Naiki tangga kuning dan meluncurlah ke Level 9: The Dark Suburbs ]`
  3. **Stage 2 (Level 9: The Dark Suburbs) ➔ Stage 3 (Level 37: The Poolrooms)**:
     - *Lokasi Transisi*: Rumah Suburban #1 di koordinat `X = 410, Z = 1312`. Masuk ke dalam rumah, cari pintu bertuliskan `BASEMENT ACCESS`, dan turuni tangga beton ke lantai bawah.
     - *Petunjuk Fisik*: Plang kayu penunjuk arah di samping landing pavilion (`🏚️ RUMAH #1: AKSES BASEMENT LEVEL 37 >>`) dan lampu neon teras rumah yang berkedip.
     - *Objektif VHS*: `[ OBJEKTIF: Susuri jalan berkabut ke Rumah #1, temukan tangga basement ke Level 37 ]`
  4. **Stage 3 (Level 37: The Poolrooms) ➔ Stage 4 (Level 1: Parking Garage)**:
     - *Lokasi Transisi*: Palka porselen kedap air di ujung Deep Diving Basin koordinat `X = 200, Z = 1600`.
     - *Petunjuk Fisik*: Tulisan ubin keramik cyan di pilar lengkung (`>> DRAINAGE & MAINTENANCE ACCESS >> LEVEL 1 PARKING >>`) dengan lampu sirine amber industri.
     - *Objektif VHS*: `[ OBJEKTIF: Arungi kolam renang menuju palka drainase industri di ujung kolam ]`
  5. **Stage 4 (Level 1: Parking Garage) ➔ Stage 5 (Level 33: The Abandoned Mall)**:
     - *Lokasi Transisi*: Pintu kaca otomatis dan eskalator di Tiang Area P36 koordinat `X = 1500, Z = 2000`.
     - *Petunjuk Fisik*: Rambu penunjuk arah hijau jalan tol tergantung di plafon beton (`[ EXIT >> SECTION P36: MALL ENTRANCE ]`) dan marka panah kuning di lantai aspal.
     - *Objektif VHS*: `[ OBJEKTIF: Ikuti nomor tiang menuju Tiang P36 untuk menemukan pintu Mall ]`
  6. **Stage 5 (Level 33: The Abandoned Mall) ➔ Stage 6 (Level 18: The Playrooms)**:
     - *Lokasi Transisi*: Koridor lengkung warna-warni di Sayap Barat Mall koordinat `X = 1100, Z = 2650`.
     - *Petunjuk Fisik*: Spanduk retail gantung (`🎈 FUN ZONE & PLAYROOMS -- THIS WAY >>>`) berhias balon warna-warni dan ubin lantai ceria.
     - *Objektif VHS*: `[ OBJEKTIF: Cari koridor festival balon di lantai dasar Mall menuju Playrooms ]`
  7. **Stage 6 (Level 18: The Playrooms)**:
     - *Klimaks & Hub Kembali*: Mandi bola raksasa, terowongan labirin bermain, dan bilik `ServiceElevator` untuk kembali ke stage manapun yang telah dibuka.

---

### 48. 🎪 HUKUM 48: ARSITEKTUR TEMA LEVEL 18 (THE PLAYROOMS / INDOOR PLAYGROUND) — WAJIB ELEMEN PLAYGROUND ASLI (ANTI-RUANGAN KOSONG)
- **Larangan Keras**:
  * **DILARANG PLAYROOMS HANYA BERUPA RUANGAN KOSONG TANPA MAINAN**: Dilarang membuat Level 18 hanya berupa lantai spons dengan kotak mandi bola kosong tanpa bola dan tabung polos ("blender playroom kan banyak tuh bisa balok atau ada ular tangga atau mainin prosotan , playground gitu, ini gak ada mirip2 dan rapihnya backroom nya").
- **Standar Baku Elemen Wajib Level 18 (The Playrooms)**:
  1. **Arena Mandi Bola Raksasa Nyata (Real Ball Pit)**:
     - Dinding pembatas busa vinyl empuk (Biru/Merah).
     - Kolam diisi ratusan bola plastik bundar warna-warni (Merah, Kuning, Biru, Hijau, Ungu) yang bisa diselami pemain.
  2. **Prosotan Playground & Menara Luncur (Playground Slide Tower)**:
     - Menara bermain bertingkat dengan tangga busa empuk dan perosotan meliuk (spiral / straight slide) yang dapat diluncuri avatar.
  3. **Lantai Ular Tangga Raksasa (Giant Snakes & Ladders Board)**:
     - Lantai tengah dihiasi pola kotak-kotak papan permainan ular tangga raksasa lengkap dengan nomor 1 s/d 100, ilustrasi ular kartun, tangga kayu, dan dadu raksasa.
  4. **Balok Mainan Huruf Abjad Raksasa (Giant Alphabet Toy Blocks)**:
     - Balok-balok mainan kubus kayu/busa raksasa (huruf `A`, `B`, `C`, `1`, `2`, `3`) dengan sudut melengkung bevel tersusun acak di sudut ruangan.
  5. **Labirin Tabung Merangkak (Crawl Tube Jungle Gym)**:
     - Tabung merangkak aneka warna (Kuning, Merah, Biru) dengan jendela kubah akrilik transparan (bubble dome windows) dan jembatan gantung mini.
  6. **Ruang Pesta Ulang Tahun (Creepy Party Room)**:
     - Meja pesta panjang bertaplak warna-warni, topi pesta runcing, piring kertas, kue ulang tahun, dan balon-balon melayang di langit-langit dengan iringan melodi kotak musik lambat.

---

### 49. 🛍️ HUKUM 49: ARSITEKTUR TEMA LEVEL 33 (THE ABANDONED MALL) — WAJIB ATRIUM 2 LANTAI, ESKALATOR, & DERETAN STOREFRONT
- **Larangan Keras**:
  * Dilarang membuat Mall hanya berupa 4 kotak ruko sepi di ruangan kosong seluas 800 studs.
- **Standar Baku Elemen Wajib Level 33 (The Abandoned Mall)**:
  1. **Atrium Terbuka 2 Lantai & Mezzanine**:
     - Lantai 1 promenade ubin marmer mengkilap motif catur.
     - Lantai 2 mezzanine keliling dengan pagar pembatas kaca (*glass balustrades*) dan railing kuningan (*brass handrails*).
     - Plafon skylight kaca piramida raksasa dengan cahaya temaram liminal.
  2. **Eskalator Ganda (Dual Escalator Banks)**:
     - Struktur eskalator naik dan turun menghubungkan Lantai 1 ke Lantai 2 dengan anak tangga beralur dan panel kaca samping.
  3. **Air Mancur Marmer Bertingkat (Central Tiered Fountain)**:
     - Air mancur marmer bundar 3 tingkat di tengah atrium dengan air jernih memantulkan cahaya lampu mall.
  4. **Deretan Toko Retail Ikonik 80s/90s (Themed Storefronts)**:
     - `RETRO ARCADE 1984`: Deretan mesin arcade (*arcade cabinets*) dengan layar CRT menyala ungu/cyan.
     - `VINTAGE RECORDS`: Rak kayu piringan hitam, kaset pita, dan poster musik retro.
     - `FOOD COURT & CAFÉ`: Meja makan melamin, kursi bundar, plang neon `CINNABON` & `ORANGE JULIUS`.
     - `LIMINAL FASHION`: Butik pakaian vintage dengan manekin statis dan etalase kaca.
  5. **Street Furniture Mall**:
     - Bangku taman besi tempa & kayu pernis, tempat sampah krom, dan pot tanaman palem dalam ruangan.

---

### 50. 👾 HUKUM 50: SISTEM ENTITAS PENGEJAR CERDAS & HOROR PELARIAN BACKROOMS (AI CHASING ENTITY & PURSUIT SUITE)
- **Larangan Keras**:
  * **DILARANG GAME HOROR TANPA ANCAMAN PENGEJAR**: Dilarang membangun Backrooms yang hanya berupa museum kosong tanpa ada bahaya entitas yang memburu pemain ("entitas di kejar oleh apa gitu seperti backroom atau ada mata setiap apa gitu kaya backroom beneran").
- **Standar Baku Entitas Pemburu (The Bacteria / Smiler / Shadow Stalker)**:
  1. **Visual Model 3D Horor Autentik**:
     - Model 3D monster ramping bertentakel kawat hitam (*Bacteria / Wire Figure* seperti Kane Pixels) atau wajah senyum menyala di kegelapan (*Smiler*).
     - Dikelilingi partikel kabut hitam (*Dark Miasma Particles*) dan distorsi statis.
  2. **AI Navigasi & Kecepatan Berburu**:
     - Mode Patroli: Menjelajah lorong secara acak dengan suara langkah berat bergaung.
     - Mode Deteksi: Saat melihat pemain dalam jarak 60 studs atau mendengar suara langkah kaki cepat, entitas memekik keras (*Terrifying Screech*), mata/senyumnya menyala merah darah, dan mengejar pemain dengan kecepatan `WalkSpeed = 22`!
  3. **Efek Horor Adrenalin pada Pemain**:
     - Kamera bergetar (*Screen Shake*).
     - Layar dipenuhi vignette merah berdenyut (*Heartbeat Red Pulse*) dan distorsi garis VHS tape glitch.
     - Detak jantung pemain berdegup kencang hingga 180 BPM.
     - Pemain harus menggunakan Sprint (`Shift` / tombol `LARI`) dan berbelok zig-zag di tikungan labirin untuk memutus garis pandang (*Break Line of Sight*)!
  4. **Zona Aman & Despawn**:
     - Entitas tidak dapat menembus zona aman berpintu (seperti palka porselen The Bathrooms atau pintu masuk Mall).

---

### 51. 🎬 HUKUM 51: VISUAL REALISTIK KUALITAS STEAM (ANTI-BALOK PRIMITIF ROBLOX — FULL MESHPARTS, PBR & KUSTOM VFX)
- **Larangan Keras**:
  * **DILARANG MENDOMINASI GAME DENGAN BALOK KOTAK POLOS ROBLOX**: Dilarang keras membuat lingkungan yang terasa membosankan karena hanya tersusun dari tumpukan part balok primitif ("realistik semuanya kaya gambar visual vfx, blender semua , jangan pake part terus bosen lihatnya, buat yang menarik dan rapih").
- **Standar Baku Kualitas Grafis Realistis**:
  1. **Aset Geometri 100% MeshPart PBR**:
     - Setiap perabot, arcade machine, mobil di parkiran, tangga meliuk, tanaman mall, dan monster WAJIB berwujud **Single Realistic MeshPart** bertekstur PBR (Normal Map, Roughness Map, Metalness).
  2. **Lighting Post-Processing Sinematik**:
     - Lighting disetel ke teknologi **`Future`** (ShadowMap dinamis beresolusi tinggi).
     - Dilengkapi efek post-processing lengkap:
       * `Atmosphere` (Haze kabut realistis berdensitas 0.35).
       * `Bloom` (Glow temaram lampu neon neon dan senter).
       * `ColorCorrection` (Palet warna liminal film 90-an dengan saturasi -0.1 dan contrast 0.15).
       * `DepthOfField` (Fokus kamera sinematik jarak jauh berkabut).
  3. **VFX Partikel Volumetrik**:
     - Partikel debu melayang (*floating dust motes*) di bawah sorotan lampu neon labirin.
     - Kabut uap air tipis (*mist particles*) di atas permukaan kolam Poolrooms.
     - Rintik kabut aspal basah di jalan raya The Dark Suburbs.

---

### 52. 🚲 HUKUM 52: STANDAR MUTLAK 100% 3D BLENDER MESHPARTS PADA SETIAP ISIAN, PROPS, KENDARAAN & PERABOT (ZERO BALOK PRIMITIF PADA ISIAN GAME)
- **Larangan Keras**:
  * **DILARANG KERAS MENGISI DUNIA DENGAN PART BALOK KOTAK PRIMITIF**: Dilarang membuat properti, perabot, dan kendaraan menggunakan tumpukan part balok polos Roblox ("FULL BLENDER LHO YA SETIAP ISIANNYA, PAKE BLENDER YANG RAPIH SEMUA RAPIHKAN DAN BERESKAN SEMUANYA").
- **Standar Baku 100% 3D Blender MeshParts**:
  1. **Kendaraan Autentik**:
     - Mobil sedan retro terbengkalai (`Template_Car`, Asset `16961255595` MeshPart) wajib terparkir di garasi/driveway rumah.
     - Sepeda ontel gunung 3D (`Template_Bicycle`, Asset `83212895970872` MeshPart) bersandar di pagar teras, dinding gang, atau tergeletak di rumput.
     - Motor trail 3D (`Template_DirtBike`, Asset `126580225392305` MeshPart) terparkir di jalan buntu atau samping rumah.
  2. **Perabot Interior Rumah 3D**:
     - Sofa ruang tamu 3D (`Template_Sofa`, Asset `11520568472` MeshPart).
     - TV tabung vintage CRT 3D (`Template_TV`, Asset `105807098570279` MeshPart) menyala statis temaram.
     - Tempat tidur vintage 3D (`Template_Bed`, Asset `16847278288` MeshPart).
  3. **Penyimpanan Master Template**:
     - Seluruh template master wajib tersimpan rapi di `ReplicatedStorage.Backrooms3DAssets` dengan properti `Anchored = true`, material PBR mulus, dan koordinat grounding tepat di permukaan lantai (`targetBottomY = floorY`).

---

### 53. 🏛️ HUKUM 53: ARSITEKTUR KEDAP VOID & TRANSISI TANGGA BASEMENT (ZERO CASING MENEMBUS FASAD RUMAH & 100% UNDERGROUND)
- **Larangan Keras**:
  * **DILARANG CASING SELUBUNG MENEMBUS DINDING FASAD / ATAP RUMAH**: Dilarang keras membuat balok selubung vertikal (*vertical casing*) atau archway putih raksasa yang menembus keluar dinding depan/belakang rumah atau mencuat di atas tanah seperti kotak beton janggal yang menghalangi jalan masuk!
- **Standar Baku Fasad & Tangga Basement**:
  1. **Orientasi Hadap Rumah Wajib Benar**:
     - Rumah di ujung jalan buntu (*Cul-de-sac*) WAJIB menghadap langsung ke arah jalan datang (menghadap Timur ke arah jalan cul-de-sac).
     - Fasad depan wajib dilengkapi pintu masuk kayu yang mengundang, jendela kaca temaram, teras kayu dengan tiang penyangga kanopi, lampu lentera gantung, dan tangga turun menuju trotoar.
  2. **Tangga Basement 100% di Bawah Lantai Rumah (Underground Only)**:
     - Tangga menuju stage berikutnya (Level 37 Poolrooms) dimulai dari bukaan lantai alami di dalam ruangan belakang/cellar rumah (`Y <= 60.8`).
     - Seluruh selubung dinding samping, pondasi beton miring, dan plafon miring tangga WAJIB berada sepenuhnya di bawah tanah (`Y <= 60.8`).
     - Dilarang ada komponen selubung tangga yang menonjol keluar ke halaman depan, dinding samping, atau atap rumah!

---

### 54. 🛣️ HUKUM 54: TATA LETAK JALAN RAYA, PERSIMPANGAN KOTAK ASPAL MURNI & ELEVASI GARIS KUNING BAKU
- **Larangan Keras**:
  * **DILARANG TROTOAR ATAU GARIS MEMOTONG PERSIMPANGAN**: Dilarang membiarkan trotoar memotong melintang jalan raya menjadi kotak-kotak waffle, atau garis kuning putus-putus bersilangan membentuk tanda tambah "+" di tengah perempatan!
  * **DILARANG TIANG LAMPU DI TENGAH JALAN**: Dilarang menempatkan tiang lampu jalan di tengah lajur aspal tempat pemain/kendaraan lewat!
- **Standar Baku Geometri Jalan & Marka**:
  1. **Persimpangan Kotak Aspal Polos Murni**:
     - Setiap area perempatan/pertigaan (*intersection box*) WAJIB berupa part aspal polos murni tanpa trotoar atau garis marka di dalamnya. Trotoar dan garis marka harus berhenti rapi tepat di batas curb sebelum masuk ke kotak persimpangan.
  2. **Elevasi Presisi Marka Kuning Putus-Putus**:
     - Seluruh garis kuning putus-putus (*dashed yellow stripes*) WAJIB dinaikkan tepat pada elevasi `Y = Y_asphalt + 0.13` studs dengan material `Neon` agar selalu terlihat menyala terang, tidak pernah tenggelam (*submerged*) di bawah aspal, dan bebas *z-fighting*.
  3. **Penempatan Tiang Lampu Ketat di Trotoar Luar**:
     - Tiang lampu jalan (*StreetLamps*) WAJIB dipasang secara ketat pada trotoar luar (misal `X = 480.3` dan `X = 522.3` pada Main Blvd), dengan jarak minimal 6 studs di luar batas aspal berkendara.

---

### 55. 🧭 HUKUM 55: PRINSIP PENJELAJAHAN LABIRIN (PINTU KELUAR WAJIB DI SUDUT TERJAUH / ANTI-INSTANT NEXT STAGE)
- **Larangan Keras**:
  * **DILARANG MELETAKKAN PINTU KELUAR TEPAT DI DEPAN TANGGA TURUN**: Dilarang keras membuat pintu keluar/palka menuju stage berikutnya terlihat langsung begitu pemain baru saja menuruni tangga ("masa baru turun , langsung ketemu stage selanjutnya, tersesatkan dulu dong").
- **Standar Baku Penempatan Pintu Keluar Labirin**:
  1. **Jarak Diagonal Maksimal**:
     - Pintu keluar stage WAJIB ditempatkan di sudut perimeter yang paling jauh dari titik kedatangan (minimal 800-1000 studs melintasi labirin).
  2. **Wajib Menjelajahi Kompleks**:
     - Pada Level 37 (The Poolrooms), pintu masuk dari Suburbs berada di sisi Timur (`X = 14`), sedangkan pintu keluar ke Level 1 (Parking Garage) WAJIB berada di sudut Barat terjauh (`X = -801, Z = 1350`).
     - Pemain wajib melintasi aula porselen terendam air, pilar marmer, dan kolam renang sebelum menemukan lorong pemeliharaan menuju garasi.

---

### 56. ☁️ HUKUM 56: KEDAP TOTAL DARI KEBOCORAN LANGIT & KETEBALAN PLAFON (AIRTIGHT CEILING & ZERO SKY LEAK)
- **Larangan Keras**:
  * **DILARANG CELAH TERBUKA KE LANGIT ATAU RUMPUT MENEMBUS PLAFON**: Dilarang membiarkan langit biru siang hari terlihat dari dalam ruangan bawah tanah/tertutup, atau lempengan rumput hijau tanah atas menembus ke dalam plafon indoor.
- **Standar Baku Plafon Indoor**:
  1. **Plafon Menyeluruh 100% Menutup**:
     - Seluruh stage indoor/underground (Poolrooms, Parking Garage, The Bathrooms, The Mall, Playrooms) WAJIB memiliki plafon utuh yang tersambung rapat (*flush*) hingga ke dinding perimeter tanpa ada celah 1 stud pun.
  2. **Segmentasi Terrain & Subfloor**:
     - Lempengan tanah/rumput di atas palka wajib dipotong/disegmentasi secara presisi sehingga tidak pernah mencuat ke dalam ruang udara interior di bawahnya.

---

### 57. 💡 HUKUM 57: PENCAHAYAAN LEMBUT REALISTIS PADA PROSOTAN (ANTI-GLARE NUCLEAR NEON)
- **Larangan Keras**:
  * **DILARANG MENJADIKAN PROSOTAN SILAU BLINDING NEON**: Dilarang menggunakan material Neon 100% kuning terang atau PointLight berintensitas tinggi di dalam lorong prosotan yang membuat layar putih menyilaukan ("terang amat disini").
- **Standar Baku Prosotan Kuning (Yellow Slide Chute)**:
  1. **Warna & Material Alami**:
     - Gunakan material `SmoothPlastic` dengan warna kuning mustard redup alami (*matte playground yellow*, `Color3.fromRGB(215, 170, 35)`) dan `Reflectance = 0.02`.
  2. **Pencahayaan Temaram & Kontras**:
     - Nol neon menyilaukan, cahaya mengandalkan pendaran lembut pantulan lingkungan luar atau lampu neon berkabut temaram di mulut prosotan.

---

### 58. 🏘️ HUKUM 58: ARSITEKTUR GANG SEMPIT & LABIRIN SUBURBAN (NARROW ALLEYS MAZE SUITE)
- **Standar Baku Level 9 The Dark Suburbs**:
  1. **Labirin Gang Sempit (Narrow Alleys)**:
     - Dilengkapi jaringan gang sempit (*Willow Way Alley* di `X=650`, *Cedar Passage* di `Z=1640`, dan *Shadow Alley* di `X=350`) selebar 8 studs dengan aspal/paving gelap.
     - Diapit pagar kayu privasi setinggi 10 studs (`Material = WoodPlanks`) di kedua sisi.
     - Memiliki belokan 90 derajat, tikungan buta (*blind corners*), dan jalan buntu (*dead ends*).
  2. **Isian Penuh 3D Blender**:
     - Sepeda ontel 3D Blender bersandar di pagar atau tergeletak di tanah.
     - Motor trail 3D Blender di ceruk jalan buntu.
     - Plang nama jalan metal reflektif ("MAIN BLVD", "NORTH AVE", "SOUTH AVE", "DEAD END").

---

### 59. 📱 HUKUM 59: INTEGRITAS TATA LETAK UI & ANTI-TUMPANG TINDIH TEKS (ZERO NOTIFICATION COLLISION)
- **Larangan Keras**:
  * **DILARANG TEKS LABEL GANDA SALING BERTABRAKAN**: Dilarang meletakkan beberapa TextLabel pada koordinat absolut yang sama di layar sehingga teks saling menimpa dan tidak terbaca ("notifikasi nabrak gini emang atau gimana?").
- **Standar Baku UI Liminal VHS**:
  1. **Kontainer Frame Tunggal Terpadu (`InfoFrame`)**:
     - Semua informasi status permainan wajib ditampung di dalam satu frame tunggal di pojok kiri bawah (`Pos = {0, 24}, {1, -125}`, `Size = {0, 520}, {0, 95}`) dengan sudut melengkung 8px dan latar belakang semi-transparan `0.4`.
  2. **Pemisahan Vertikal Jelas**:
     - Teks Objektif di baris atas (`Y = 10`, `Size.Y = 48`), teks Kontrol di baris bawah (`Y = 62`, `Size.Y = 22`).
     - Teks REC jam di pojok kiri atas terpisah secara mandiri.

---

### 60. 📐 HUKUM 60: PRESISI ELEVASI PIVOT MODEL 3D DENGAN GETBOUNDINGBOX (ANTI-KENDARAAN & PERABOT TENGGELAM / ZERO SUBMERGED PROPS)
- **Larangan Keras**:
  * **DILARANG MELETAKKAN MODEL 3D BERDASARKAN TITIK PUSAT BOUNDING BOX TANPA OFFSET**: Dilarang keras menempatkan Model kendaraan (`Template_Car`, `Template_Bicycle`, `Template_DirtBike`) atau perabot (`Template_Sofa`, `Template_TV`, `Template_Bed`) langsung pada koordinat `Y = floorY` tanpa menghitung batas bawah model ("tenggelem?", "ko tenggelem?").
  * Menempatkan model dengan tinggi 5.2 studs pada `Y = 60.0` mengakibatkan setengah badan mobil (2.6 studs) terkubur di dalam beton lantai!
- **Standar Baku Penempatan Model 3D**:
  1. **Formula Wajib Bounding Box Alignment**:
     Setiap kali menempatkan atau menggeser Model 3D ke permukaan lantai `floorTopY`, WAJIB menggunakan rumus matematika:
     ```lua
     local function alignModelToFloor(model, floorTopY)
         local cf, sz = model:GetBoundingBox()
         local bottomY = cf.Position.Y - (sz.Y * 0.5)
         local diff = floorTopY - bottomY
         model:PivotTo(cf + Vector3.new(0, diff, 0))
         return diff
     end
     ```
  2. **100% Menapak di Permukaan**:
     - Ban mobil wajib menapak tepat di atas aspal/beton (`BottomY == floorTopY`).
     - Roda sepeda wajib menapak tepat di atas papan teras (`BottomY == porchDeckTopY`).
     - Kaki sofa dan meja kopi wajib menapak tepat di atas lantai interior.
     - TV tabung wajib diletakkan di atas meja credenza/rak TV, dilarang diletakkan menancap di plin dinding (*baseboard*)!

---

### 61. 🛍️ HUKUM 61: STANDAR RETAIL STOREFRONT MALL LEVEL 33 (18-STUD DOUBLE-HEIGHT CEILINGS, REAL 3D SHOPS & ZERO GANTUNGAN BAJU DI KORIDOR)
- **Larangan Keras**:
  * **DILARANG MEMBUAT MALL SEPERTI PANTAI DENGAN POHON KELAPA & GANTUNGAN BAJU DI TENGAH JALAN**: Dilarang keras menebar gantungan baju lepas di tengah koridor jalan atau menanam pohon palem pantai liar yang membuat mall tampak seperti pantai ("kenapa mall malah kaya pantai / taman pantai, buat kaya mall, kaya ada toko toko ruko, toko baju, toko cciki, toko minuman, toko makanan, toko pizza, yanglengkap FULL BLENDER, bukan GANTUNGAN BAJU DI TEBAR").
  * **DILARANG STOREFRONT TERTEKAN MEZZANINE**: Plafon ruko dilarang bertabrakan dengan lantai 2 mezzanine.
- **Standar Baku Toko Retail Level 33 (The Abandoned Mall)**:
  1. **Unit Ruko Lengkap (Complete Retail Units)**:
     - Setiap ruko dibangun dengan tinggi 18 studs (`Y = 60.1 .. 78.0`), tepat berada di bawah lantai mezzanine (`Y = 80.0`).
     - Toko dilengkapi fasad kaca etalase, pintu masuk ganda, plang nama neon di atas pintu (`Y = 75.5`), lantai ubin keramik, dan pencahayaan interior hangat.
  2. **6 Toko Ruko Tematik Lengkap**:
     - `Fashion Boutique`: Rak baju rapi, meja pajangan kain, dan meja kasir.
     - `Snack Mart`: 3 lorong rak gondola minimarket berisi jajanan/ciki warna-warni.
     - `Drinks & Boba Station`: Meja bar marmer, kursi bar tinggi, dan kulkas display minuman.
     - `Pizza & Italian Diner`: Tungku pizza bata merah, etalase warmer, meja dan kursi booth makan.
     - `80s Retro Arcade`: 6 mesin arcade neon menyala ungu/cyan.
     - `Vintage Records & Music`: Rak display piringan hitam kayu dan meja resepsionis.

---

### 62. 🚗 HUKUM 62: ALOKASI KENDARAAN PADAT GARASI PARKIR LEVEL 1 (DENSE VEHICLE PARKING & 100% ZERO TENGGELAM)
- **Larangan Keras**:
  * **DILARANG PARKIRAN SEPI TANPA MOBIL**: Dilarang membuat garasi seluas 800 studs yang kosong melompong hanya dengan 2-3 mobil ("di parkiran juga kenapa dikit isinya, harusnya lengkap ADA MOBIL APAPUN LENGKAP DI PARKIRAN RAME").
- **Standar Baku Parkiran Level 1 (Parking Garage)**:
  1. **Populasi Kendaraan Padat**:
     - Minimal 35-50 unit mobil sedan 3D Blender (`Template_Car`) dengan variasi warna realistis (Merah marun, Biru navy, Perak metallic, Hitam arang, Beige, Hijau lumut, Kuning mustard).
     - Minimal 10-15 unit motor trail 3D Blender (`Template_DirtBike`) terparkir di sudut tiang dan dinding.
  2. **Elevasi Ban Anti-Tenggelam**:
     - Seluruh ban mobil wajib berada di atas elevasi lantai `Y = 60.00` menggunakan `alignModelToFloor(car, 60.0)`.

---

### 63. 🛡️ HUKUM 63: INTEGRITAS SEKAT PERIMETER ANTAR-STAGE & LIFT TRANSISI KEDAP SHORTCUT (ANTI-STAGE 2 KE STAGE 4 BYPASS)
- **Larangan Keras**:
  * **DILARANG LUBANG TEMBUS ANTAR-STAGE YANG TIDAK BERURUTAN**: Dilarang keras membiarkan dinding perbatasan Stage 2 (Suburbs) dan Stage 4 (Parking Garage) bolong sehingga pemain dari rumput Suburbs bisa langsung masuk ke Garasi Parkir dan memotong jalan melewati Stage 3 (Poolrooms) ("stage 2 bisa langsung ke stage 4, ko bisa gini sih,harusnya jangan bisa gini").
  * **DILARANG TEROWONGAN BERTANGGA 3.4 STUD YANG MEMBUAT PEMAIN NABRAK**: Dilarang membuat lorong transisi dengan lantai patah-patah bertangga tinggi atau pipa melintang setinggi badan yang menghalangi jalan ("nabrak").
- **Standar Baku Sekat & Transisi Antar-Stage**:
  1. **Dinding Sekat Perimeter 100% Masif**:
     - Dinding Barat Parking Garage (`X = 1098`) dan batas Timur Suburbs (`X = 1092`) WAJIB berupa dinding beton masif setinggi 36 studs tanpa lubang, tanpa pintu, dan dilengkapi lapisan perisai blackout hitam (*exterior blackout shield*).
  2. **Transisi Level 37 Poolrooms ke Level 1 Parking Garage via Freight Elevator**:
     - Transisi antar stage yang memiliki perbedaan tinggi vertikal dan horizontal jauh WAJIB menggunakan **Sistem Lift Barang Industri (Heavy Freight Elevator)**.
     - Di Poolrooms: Bilik lift berlantai bordes besi, dinding baja corrugated, lampu sirine amber, dan tombol panggil lift.
     - Di Parking Garage: Pintu lobi lift kedap udara dengan nomor lantai `LEVEL 1: PARKING GARAGE`.
     - Pemain melangkah masuk ke dalam bilik lift, pintu tertutup, efek getar dan suara motor katrol hidrolik berbunyi, dan pemain muncul di lobi lift Garasi Parkir secara mulus tanpa halangan rintangan!

---

### 64. 🧸 HUKUM 64: KEMURNIAN TEMA TAMAN BERMAIN LEVEL 18 (ANTI-KASUR & ANTI-SEPEDA DI PLAYROOM / 100% PURE DAYCARE ASSETS)
- **Larangan Keras**:
  * **DILARANG MEMASUKKAN KASUR DEWASA, SEPEDA GUNUNG, ATAU MOTOR TRAIL KE DALAM PLAYROOM**: Dilarang keras menaruh tempat tidur dewasa (*Template_Bed*) atau sepeda/motor trail di dalam area taman bermain anak-anak ("kenapa ada kasur, sepeda di playroom?").
- **Standar Baku Elemen Level 18 (The Playrooms)**:
  1. **Peralatan Daycare & Mainan Autentik**:
     - **Balok Huruf & Angka Raksasa (ABC / 123 Blocks)**: Balok kayu warna-warni bersudut lengkung bertumpuk piramida dan tersebar di lantai.
     - **Matras Puzzle Busa Warna-Warni (EVA Interlocking Foam Playmats)**: Lantai dilapisi ubin busa warna pastel ceria.
     - **Meja Belajar Balita & Kursi Mini (Toddler Activity Tables & Tiny Chairs)**: Meja bundar plastik dengan kursi-kursi mungil warna-warni.
     - **Perosotan Plastik Playground (Indoor Toddler Slides)**: Menara luncur plastik ceria dengan tangga pengaman dan seluncuran merah.
     - **Rak Lemari Mainan (Toy Cubby Shelves)**: Lemari rak kayu berisi kotak-kotak mainan berwarna cerah.
     - **Arena Mandi Bola Raksasa (Rainbow Ball Pit)**: Kolam busa empuk berisi ribuan bola warna-warni.
  2. **Nol Aset Dewasa**:
     - 100% steril dari kasur tidur, sofa dewasa, sepeda ontel, dan motor trail.

---

### 65. 🌅 HUKUM 65: KLIMAKS KELUAR DUNIA NYATA & ARSIP FOUND-FOOTAGE (THE GRAND REALITY ESCAPE PRINCIPLE)
- **Standar Baku Pelarian Akhir Backrooms**:
  1. **Gerbang Ekstraksi Realitas (Reality Blast Door)**:
     - Di sudut terjauh Level 18 Playrooms (`X = 200, Z = 2880`), berdiri gerbang pintu baja hidrolik berlabel `REALITY EXTRACTION PORTAL // RETURN TO REAL WORLD`.
  2. **Padang Rumput Dunia Nyata (Real World Meadow)**:
     - Melewati pintu gerbang, pemain melangkah keluar dari lorong Backrooms ke padang rumput hijau subur bermandikan sinar matahari keemasan (*Sunlit Green Meadow*).
  3. **Trigger Pad Ekstraksi & Endcard VHS**:
     - Menginjak `RealityEscapePad` memicu bunyi lonceng kemenangan (*Victory Chime*), efek layar memutih pelan (*Fade to White*), dan layar rekaman kaset video VHS menampilkan arsip rekaman found-footage bertuliskan:
       `STATUS: ESCAPED // YOU SURVIVED THE BACKROOMS // TAPE ARCHIVED`.

---

### 66. 🌱 HUKUM 66: KONTINUITAS TANAH PONDASI TANPA CELAH (SEAMLESS FOUNDATION BASE SLABS & ZERO HOLES / ANTI-BOLONG)
- **Larangan Keras**:
  * **DILARANG CELAH KOSONG ANTARA PONDASI RUMAH DENGAN RUMPUT**: Dilarang membiarkan ada celah sempit memanjang antara dinding pondasi/teras/jalan masuk rumah dengan hamparan rumput luar yang memperlihatkan void hitam/langit di bawahnya ("ko bolong").
- **Standar Baku Tanah Pondasi**:
  1. **Lempeng Dasar Monolitik Bawah Rumah (Sub-Foundation Base Slab)**:
     - Di bawah setiap rumah yang memiliki halaman dan tangga basement (seperti Rumah #13), WAJIB dipasang satu lempeng part rumput monolitik raksasa (`House13_SeamlessFoundationBase`, ukuran minimal `120 x 2 x 120 studs` pada elevasi `Y = 59.5`).
     - Lempeng ini menjamin bahwa di manapun dinding, teras, trotoar, atau jalan masuk diletakkan, tanah di bawahnya selalu tertutup 100% rumput padat tanpa celah 1 milimeter pun!

---

### 67. 🪜 HUKUM 67: GEOMETRI HEADROOM TANGGA BASEMENT & ANTI-SLICING CEILING SLABS (MINIMAL 10 STUDS CLEARANCE & ZERO WEDGES IN DOORWAY)
- **Larangan Keras**:
  * **DILARANG BALOK PLAFON MIRING MEMOTONG KUSEN PINTU / KEPALA PEMAIN**: Dilarang memasang part plafon miring (*sloping ceiling*) dengan sudut tajam atau posisi rendah yang memotong kusen pintu masuk, menutup jalur pandang tangga, atau menyisakan ruang kepala (*headroom*) sempit (< 8 studs) yang membuat pemain membentur kepala saat menuruni tangga.
  * **DILARANG PART PERISAI MELEBIHI LEBAR DINDING TANGGA**: Dilarang membuat part perisai blackout (*blackout shield*) yang lebih lebar dari dinding lorong sehingga ujungnya menusuk menembus dinding bata ke ruangan lain atau melayang di langit luar rumah.
- **Standar Baku Arsitektur Tangga Basement**:
  1. **Plafon Datar di Atas Pendaratan Atas (Landing Ceiling)**:
     - Di atas bordes/anak tangga paling atas (Tread 1), plafon WAJIB berbentuk datar horizontal pada elevasi tinggi `Y >= 71.0` (headroom minimal 10.5 studs di atas anak tangga teratas dan berada tepat di atas balok lintel pintu).
  2. **Plafon Miring Berjarak Kepala Longgar (High-Clearance Sloping Ceiling)**:
     - Plafon miring wajib memiliki sudut landai (`<= 40 derajat`) yang sejajar dengan kemiringan tangga dan memberikan jarak bebas kepala (*headroom*) minimal **12 hingga 20 studs** pada setiap anak tangga dari atas hingga bawah (100% PASS raycast clearance).
  3. **Lebar Pas Kedap Presisi (Flush Width Matching)**:
     - Lebar plafon tangga (`Size.Z`) WAJIB diatur pas dan presisi di antara kedua dinding bata (misal `8.7 studs` di dalam lorong selebar `8.8 studs`), menjamin 0% part menusuk keluar dinding.
  4. **Pencahayaan Vintage Sconce Ambien**:
     - Di sepanjang lorong tangga dipasang lampu dinding vintage (*brass sconces*) dengan PointLight bernuansa amber hangat yang menerangi setiap pijakan anak tangga, mengundang pemain melangkah ke basement dengan aman dan atmosferik.

---


---

### 68. 🪑 HUKUM 68: STANDAR BAKU 1 SINGLE MESHPART UNTUK SETIAP FURNITUR & PROPS (ANTI MULTI-SUBMESH & ANTI-KOMPONEN BALOK PRIMITIF)
- **Instruksi Mutlak & Feedback Tegas Founder**:
  * *"di mall stage ini banyak yang kosong toko nya kurang banyak, dari isi toko blendernya mana ko gak ada saya bilang pake blender full blender"*
  * *"ko kosongan gini"*
  * *"blender nya mana, ko pake komponen sih, bentuk realistik"*
  * *"kenapa pake part lagi, saya bilang full blender"*
  * *"blender itu bukan komponen part, isinya harusnya meshpart 1 isi nya bentuknya blender realistik"*
  * *"COBA CEK SEMUA STAGE DEH, HARUS PAKE BLENDER YA, TOLONG BLOKIR KOMPONEN PART"*
  * *"BUAT SENDIRI PAKE BLENDER, BUKAN NGAMBIL DARI ORANG LAIN, BLOKIR NGAMBIL DARI ORANG LAIN"*
  * *"TOLONG ROMBAK SEMUA TOTAL SMEUA, YANG BANYAK MESHPART, USAHAAKN BLENDER SENDIRI CUSTOM SENDIRI 1 MESHPART, TIDAK BANYAK MESHPART YA"*
  * *"kaya kasur gini bagus, 1 meshpart , tapi bentuk kasurnya bagus, bikin kaya gini, catet semuanya prompt apapun sebelumnya di catet"*
- **Larangan Keras**:
  * **DILARANG MERAKIT FURNITUR DARI PULUHAN PART BALOK**: Dilarang menyusun balok-balok primitif (seperti meja makan balok dengan kursi merah balok, meja anak dengan 10 part balok, atau arcade balok).
  * **DILARANG MEMECAH PROP MENJADI BANYAK SUB-MESHPART**: Dilarang membuat satu benda (seperti TV atau meja) terpecah menjadi 9-15 sub-mesh kecil (`AV_front`, `AV_back`, `Screw`, `Logo`, `Buttons`, dll).
- **Standar Baku (1 Single MeshPart Rule)**:
  1. **Satu Model = Tepat 1 Single MeshPart Bertekstur**:
     - Setiap item furnitur, prop, atau mesin (Tempat Tidur, Sofa, Meja Kopi, TV Tabung Vintage, Mesin Arcade, Meja Booth Diner, Rak Toko, Gramofon, Mainan Playroom) **WAJIB BERUPA 1 SINGLE MESHPART BERSIH** yang menyatu utuh dengan tekstur realistis atau `SurfaceAppearance`.
     - Contoh Ideal Standar Founder:
       * `Template_Bed` -> `Vintage Bed` (1 Single MeshPart dengan `SurfaceAppearance`, selimut floral, bantal, rangka kayu menyatu indah).
       * `Template_Sofa` -> `Sofa` (1 Single MeshPart dengan `SurfaceAppearance` kulit/kain berkerut elegan).
       * `Template_TV` -> `RetroTV_Stand` (1 Single MeshPart yang menyatukan TV tabung vintage di atas rak kayu).
       * `Template_CoffeeTable` -> `Vintage Coffee Table` (1 Single MeshPart meja kopi kayu vintage).
       * `RealArcadeMachineMesh` -> 1 Single MeshPart kabinet arcade 80s bertekstur.
       * `RealisticChairsAndTable` -> 1 Single MeshPart meja makan restoran/diner dengan bangku.
       * `VinylPlayerMeshPart` -> 1 Single MeshPart gramofon piringan hitam klasik.
       * `SupermarketShelfMeshPart` -> 1 Single MeshPart rak gondola ritel mall.
       * `DaycareActivityTable_MeshPart` -> 1 Single MeshPart meja aktivitas daycare.
       * `DaycarePlaySlide_MeshPart` -> 1 Single MeshPart perosotan anak-anak.

---

### 69. 🏮 HUKUM 69: STANDAR PENEMPATAN LAMPU DINDING & LENTERA TERAS (FLUSH WALL MOUNTING & ZERO MELAYANG DI UDARA)
- **Keluhan Lapangan Founder**:
  * *"kenapa latern ini melayang?"* (Lentera teras rumah suburban melayang 7.2 studs di udara tanpa menyentuh dinding).
- **Larangan Keras**:
  * **DILARANG LENTERA/SCONCE MELAYANG DI UDARA**: Dilarang menempatkan lentera dinding atau lampu teras mengambang bebas di udara tanpa kontak fisik dengan dinding bangunan.
- **Standar Baku Pemasangan Lampu Dinding**:
  1. **Flush Wall Contact**:
     - Sisi belakang lentera (`PorchLantern`) WAJIB menempel rata pada permukaan terluar dinding bata (`X = wallOuterX +- lantern.Size.X/2`).
  2. **Breket Penyangga Besi (Mounting Bracket Sconce Arm)**:
     - Setiap lentera wajib memiliki part breket besi penancap (`LanternBracket`, material `Metal`, warna hitam besi `(30, 30, 30)`) yang menghubungkan dasar lentera ke dalam dinding bata secara kokoh dan realistis.

---

### 70. 🌌 HUKUM 70: STANDAR PLAFON & BLACKOUT ENCLOSURE TERTUTUP TOTAL (ZERO LANGIT BIRU / ANTI-SKYBOX BLEED DI LEVEL HOROR)
- **Keluhan Lapangan Founder**:
  * Atap/langit-langit Mall dibuat kaca transparan (`Transparency = 0.5`) sehingga dari lantai 2 terlihat langit biru Roblox yang cerah, merusak total nuansa horor Backrooms.
- **Larangan Keras**:
  * **DILARANG LANGIT BIRU / OUTDOOR SKYBOX TERLIHAT DARI DALAM BACKROOMS**: Tidak boleh ada celah, atap transparan, atau lubang dinding di mall atau stage tertutup yang memperlihatkan langit luar.
- **Standar Baku Plafon & Selubung Kedap**:
  1. **Plafon Monolitik Padat (Opaque Solid Ceilings)**:
     - Seluruh plafon mall (`MallSkylightRoof`) wajib 100% solid (`Transparency = 0`), material `Concrete` atau `Plaster`, warna industri.
  2. **Perisai Blackout Luar (Blackout Outer Shield Enclosure)**:
     - Di sekeliling luar mall (`X: 1090..1910, Z: 2090..2910, Y: 58..105`), dipasang 5 dinding perisai blackout hitam pekat (`Color3.fromRGB(5, 5, 5)`), menjamin dari sudut pandang mana pun pemain hanya melihat kegelapan liminal tanpa sedikitpun bocoran langit biru.

---


---

### 71. 🚗 HUKUM 71: ELEVASI TINGGI BAN KENDARAAN (ZERO MOBIL TENGGELAM / ANTI SUNKEN VEHICLES)
- **Keluhan Lapangan Founder**:
  * *"ko ada mobil yang tenggelm di stage 2?"* (Foto mobil di halaman rumah suburban tertanam 2.4 studs di dalam tanah hingga rodanya tidak terlihat).
- **Larangan Keras**:
  * **DILARANG KENDARAAN TENGGELAM DI BAWAH PERMUKAAN TANAH**: Dilarang meletakkan mobil, motor, atau kendaraan dengan titik tengah Y yang terlalu rendah sehingga roda atau sasisnya terkubur di bawah tanah/rumput/aspal.
- **Standar Baku Penempatan Kendaraan**:
  1. **Elevasi Dasar Ban Menapak Presisi**:
     - `bottomY = pos.Y - size.Y / 2` WAJIB disetel berada tepat di atas permukaan tanah/rumput (`groundY + 0.05 studs`).
     - Pada elevasi rumput `Y = 60.3`, mobil berukuran tinggi `5.21 studs` WAJIB memiliki `Position.Y = 60.3 + 5.21 / 2 = 62.91` (dibulatkan `63.0`).

---

### 72. 🏍️ HUKUM 72: ZERO COLLISION PADA KENDARAAN & TIANG TERAS (ANTI-NABRAK PILAR / TIANG KUSEN)
- **Keluhan Lapangan Founder**:
  * *"nabrak"* (Foto motor ATV/Quad bike di teras Rumah #13 menembus langsung ke dalam tiang pilar teras `PorchPost_N`).
- **Larangan Keras**:
  * **DILARANG KENDARAAN MENABRAK / MENEMBUS PILAR ATAU DINDING**: Dilarang memarkir kendaraan berukuran besar (panjang 8-9 studs) di atas teras sempit yang memiliki pilar penyangga.
- **Standar Baku Penempatan Kendaraan di Halaman**:
  1. **Parkir Bersih di Jalan Masuk (Concrete Driveway)**:
     - Kendaraan besar seperti ATV/Quad bike wajib diparkir di atas jalan masuk beton (`ConcreteDriveway`) di samping mobil lama dengan jarak bebas minimal 3-5 studs dari pilar atau tangga teras.

---

### 73. 💧 HUKUM 73: STERILISASI AIR TERRAIN DI AREA MALL / BANGUNAN KERING (ZERO AIR NYASAR DI LANTAI MALL)
- **Keluhan Lapangan Founder**:
  * *"ko tengah mall ada air?"* (Foto gundukan voxel air Terrain Water menyembul di tengah lantai Mall).
- **Larangan Keras**:
  * **DILARANG AIR TERRAIN DI LUAR POOLROOMS**: Air fisik (`Terrain.Water`) HANYA diizinkan ada di Level 37 (The Poolrooms). Dilarang keras ada sisa voxel air terrain di lantai mall, ruko, perumahan, maupun taman bermain.
- **Standar Baku Sterilisasi Air**:
  1. Jalankan `Terrain:ReplaceMaterial` untuk mengubah seluruh air di luar Poolrooms menjadi `Enum.Material.Air`.

---

### 74. 🏁 HUKUM 74: PENEMPATAN CHECKPOINT MUTLAK DI GERBANG MASUK STAGE (ZERO CHECKPOINT DI TENGAH RUANGAN / DI ATAS BANGKU)
- **Keluhan Lapangan Founder**:
  * *"CheckpointTrigger_Mall trigger ko di bangku sini, harusnya di setiap gerbang checkpoin tu"*
- **Larangan Keras**:
  * **DILARANG MENARUH CHECKPOINT DI TENGAH RUANGAN ATAU DI AREA DUDUK**: Dilarang meletakkan part checkpoint trigger di area sembarang seperti di atas bangku atau tengah lorong.
- **Standar Baku Penempatan Checkpoint**:
  1. **Tepat Melintasi Kusen Pintu Gerbang Masuk (Entrance Portal Gate Threshold)**:
     - `CheckpointTrigger_Mall`: Wajib berada tepat di kusen pintu masuk gerbang mall dari lorong parkir (`Position = Vector3.new(1500, 67, 2098)`).
     - `CheckpointTrigger_Playrooms`: Wajib berada tepat di kusen gerbang lorong masuk Playrooms (`Position = Vector3.new(300, 67, 2650)`).
     - `CheckpointTrigger_Suburbs`: Berada di bibir pendaratan perosotan (`Z = 1100`).
     - `CheckpointTrigger_Poolrooms`: Berada di vestibule pintu tangga basement (`X = 10, Z = 1640`).
     - `CheckpointTrigger_Parking`: Berada di lobi pintu keluar lift barang (`X = 1110, Z = 1600`).

---

### 75. 🧸 HUKUM 75: KEMURNIAN TEMA PROPS (SUPERMARKET GONDOLA SHELF HANYA DI MALL, ZERO DI PLAYROOM)
- **Keluhan Lapangan Founder**:
  * *"ko ini ada di playroom stage?"* (Foto rak gondola supermarket minimarket diletakkan di dalam playroom anak).
- **Larangan Keras**:
  * **DILARANG MEMASUKKAN RAK RITEL MINIMARKET KE DALAM AREA DAYCARE**: Rak gondola toko (`SupermarketShelfMeshPart`) hanya boleh digunakan di Stage 5 (The Mall).
- **Standar Baku Furnitur Playroom**:
  1. Di Level 18 (The Playrooms), furnitur penyimpanan mainan WAJIB berupa **Peti Mainan Kayu Anak (`ToyChestMeshPart`)**, meja aktivitas balita (`PartyTableMeshPart`), dan perosotan anak (`PlayroomSlideMeshPart`).

---

## 🗺️ MASTER SPATIAL ALLOCATION REGISTRY (PROYEK HOROR / BACKROOMS)

| Zona / Stage | Bounding Box X | Bounding Box Y (Elevasi Aman) | Bounding Box Z | Deskripsi & Fungsi |
|:---|:---:|:---:|:---:|:---|
| **Stage 1 (Level 0: The Maze)** | `0 .. 600` | `200 .. 216` | `0 .. 600` | Labirin tak berujung 600x600, wallpaper mono-yellow, karpet basah, 64 array lampu neon, bukaan Selatan di `X=500, Z=600`. |
| **The Bathrooms (Sub-Stage)** | `450 .. 550` | `200 .. 216` | `600 .. 720` | Kamar mandi marmer 100x120 studs, 6 wastafel porselen single MeshPart, 6 bilik toilet single MeshPart, cermin continuous, bukaan prosotan di `X=500, Z=720`. |
| **The Yellow Slide (Chute)** | `485 .. 515` | `62 .. 214` | `718 .. 1100` | Prosotan tabung kuning tertutup 380 studs meluncur dari `Y=202` ke `Y=62`, through-wall collar kedap void, landing pavilion rumput Suburbs. |
| **Stage 2 (Level 9: The Dark Suburbs)** | `-100 .. 1100` | `60 .. 100` | `900 .. 2100` | Jalan aspal 1,200x1,200 studs, trotoar beton, lampu jalan berkabut, 23 rumah suburban enterable, labirin gang sempit berpintu pagar kayu, 3D Blender mobil, sepeda, motor trail, tangga basement Rumah 13 menuju Level 37. Dinding pemisah masif di X=1092 kedap Garasi. |
| **Stage 3 (Level 37: The Poolrooms)** | `-805 .. 205` | `15 .. 50` | `1200 .. 2200` | Kompleks kolam renang porselen 1,000x1,000 studs, AIR NYATA (Terrain Water), pilar marmer tak berujung, plafon porselen putih kedap langit, lift barang industri di X=208 menuju Level 1. |
| **Stage 4 (Level 1: Parking Garage)** | `1098 .. 1903` | `60 .. 85` | `1197 .. 2003` | Garasi parkir beton 800x800 studs, 60 unit 3D Blender mobil & motor trail dengan elevasi ban menapak sempurna (0 tenggelam), dinding Barat masif kedap Suburbs, lift barang dari Poolrooms. |
| **Stage 5 (Level 33: The Abandoned Mall)** | `1097 .. 1903` | `60 .. 101` | `2097 .. 2903` | Mall megah 2 lantai 800x800 studs, atrium kaca, 6 unit ruko retail lengkap 18 studs (Fashion, Snack Mart, Boba, Pizza, Arcade, Vintage Records), eskalator ganda. |
| **Stage 6 (Level 18: The Playrooms)** | `-303 .. 303` | `60 .. 92` | `2347 .. 2953` | Taman bermain 600x600 studs, 50 mainan daycare autentik (balok ABC/123, matras puzzle busa, meja balita, seluncuran playground, rak cubby), mandi bola raksasa, Gerbang Ekstraksi Keluar Dunia Nyata di X=200, Z=2880. |

---

### 76. 🔦 HUKUM 76: SENTER KAMERA-ALIGNED (ANTI-MENYOROT KAKI / LANTAI SAAT BERLARI)
- **Keluhan Lapangan Founder**:
  * * waktu pegang senter ketika lagi lari kenapa senternya malah nerangin lantai bukan pandangan depan ya jadi percuma pake senter /flashlight kalau sambil lari karena nerangin kaki*
- **Penyebab Teknis**:
  * Dalam animasi lari bawaan Roblox (Animate), tangan kanan mengayun ke belakang dan badan membungkuk ke depan 25°. Jika SpotLight hanya ditempelkan pada Handle fisik senter di tangan, sorotan lampu otomatis miring ke bawah dan menyorot kaki/lantai.
- **Standar Baku Senter Horor Autentik (Camera-Aligned Projector)**:
  1. **Sorotan Wajib Terkunci ke Pandangan Kamera (workspace.CurrentCamera)**:
     * SpotLight dipasang pada invisible anchor (CameraFlashlightProjector) yang posisi dan orientasinya mengikuti CurrentCamera.CFrame * CFrame.new(0.4, -0.35, -0.5).
     * Menjamin sorotan cahaya senter 100% selalu lurus menerangi arah pandangan crosshair pemain, baik saat jalan santai, lari kencang/sprint, jongkok, maupun melompat!
     * Zero sorotan nyasar ke kaki atau tanah!

---

### 77. 🏛️ HUKUM 77: BASE LOBBY WAJIB 100% FULL 3D BLENDER MESH (DILARANG PART BALOK / KOMPONEN PRIMITIF)
- **Instruksi Keras & Mutlak Founder**:
  * *TAPI INGAT BASE LOBBY HARUS BLENDER DAN BAGUS LOBBY NYA MENARIK DAN BLENDER FULL DAN BERISI BLENDER BUKAN BLENDER ISINYA PART KOMPONEN TAPI FULL BLENDER YA BIAR BAGUS DAN MENARIK BUAT YANG SANGAT BAGUS*
  * *apalah ini bukan blender isi nya lobby hadeh*
- **Larangan Keras**:
  * **DILARANG KERAS MEMBUAT LOBBY DARI PART KOTAK/BALOK BIASA**: Dilarang membuat dinding datar, bilik lift dari balok plastic, atau meja dari balok kotak primitif.
- **Standar Baku Base Lobby Full Blender**:
  1. Seluruh arsitektur lobby (dinding berpanel, pilar metal, pintu elevator, lift bay, sofa kulit, chandelier, rak buku/arsip, konsol kontrol) WAJIB menggunakan **Asset 3D Blender MeshPart** berkualitas tinggi dengan tekstur PBR/UV-mapped.
  2. Suasana lobby harus mewah, estetik, dan berkarakter (standar Doors Hotel Elevator Lobby atau Sci-Fi Bunker Station).

---

### 78. 🌐 HUKUM 78: SISTEM MATCHMAKING RESERVED SERVER TERISOLASI (1 - 10 PEMAIN — DILARANG SERVER CAMPUR ADUK)
- **Instruksi Keras & Mutlak Founder**:
  * *setiap ada yang buat lobby dan masuk ke game nya akan buat server baru dan di lobby terdiri dari orang yang buat server itu gitu lho lobby nya bukan nyambung dan nyatu semua*
- **Konsep Arsitektur Standar Industri (Doors / Escape the Backrooms)**:
  * Di game horor ekspedisi, pemain yang memulai ekspedisi (baik Solo ber-1, Duo ber-2, Squad ber-4, hingga Raid ber-10) **DILARANG DICAMPURKAN DENGAN PEMAIN ASING LAIN DALAM SATU SERVER GAMEPLAY**.
- **Standar Baku Eksekusi Teknis**:
  1. **Lobby Tempat Berkumpul**: Pemain berkumpul di Main Lobby / Hub.
  2. **Pemilihan Jumlah Pemain (1 s/d 10 Orang)**:
     * Pemain memilih masuk ke lift tertentu atau membuat Room Partai dengan kuota 1 s/d 10 orang.
  3. **Inisialisasi Server Baru via TeleportService**:
     * Saat lift ditutup atau host menekan mulai:
       `lua
       local TeleportService = game:GetService(TeleportService)
       local accessCode = TeleportService:ReserveServer(GAME_PLACE_ID)
       TeleportService:TeleportToPrivateServer(GAME_PLACE_ID, accessCode, partyPlayers)
       `
     * Sistem secara otomatis membuat **SERVER BARU (Reserved Server)** di cloud Roblox.
     * Hanya anggota kelompok tersebut yang masuk ke server baru tersebut.
     * Tidak ada pemain asing yang nyasar atau mengganggu jalannya petualangan!

---

### 79. 📹 HUKUM 79: KAMERA FIRST-PERSON BODYCAM AUTENTIK (BODY & KAKI TERLIHAT JELAS SAAT MENUNDUK)
- **Instruksi Founder**:
  * *buat pov nya seperti main backroom*
- **Standar Baku First-Person Bodycam Backrooms**:
  1. StarterPlayer.CameraMode = Enum.CameraMode.LockFirstPerson.
  2. **True First-Person Body Rendering**:
     * Pada RenderStepped, seluruh bagian tubuh karakter (Torso, Tangan Kiri, Tangan Kanan, Kaki Kiri, Kaki Kanan) diatur LocalTransparencyModifier = 0.
     * Saat pemain menunduk ke bawah, pemain dapat melihat tubuh dan kakinya sendiri melangkah secara realistis.
     * Bagian Head dan aksesoris kepala tetap transparan agar tidak menghalangi pandangan mata.
  3. **Procedural Step-Bobbing & Breathing**:
     * Ayunan langkah kaki halus (gelombang sinus) yang menyesuaikan kecepatan gerak (frekuensi 10.5 saat jalan, 15 saat sprint).
     * Miring kamera halus (*banking tilt*) saat berbelok atau strafe ke samping.
     * Ayunan napas halus (*idle breathing*) saat karakter diam berdiri.

---

### 80. 🎵 HUKUM 80: PROTOKOL CUSTOM AUDIO & STERILISASI SOUND PRIVAT (ANTI ERROR IZIN AKSES ASSET)
- **Instruksi & Pertanyaan Founder**:
  * *setau saya bisa sound custom deh lu ga bisa apa custom audio ada deh nyambunginnya gimana dah di blender atau gimana?*
- **Kaidah Teknis Audio vs Blender**:
  1. **Blender HANYA untuk Model 3D**: File Blender (.blend, .fbx, .obj) HANYA memuat mesh geometri dan tekstur visual. Blender **TIDAK BISA** menyimpan, mengekspor, atau menyambungkan file audio ke dalam game Roblox.
  2. **Prosedur Unggah Custom Audio Resmi Roblox**:
     - Buka **Roblox Studio** -> Klik tab **Aset (Asset Manager)** di menu atas.
     - Klik tombol **Impor (Bulk Import)** -> Pilih file .mp3 / .wav dari PC.
     - File audio otomatis ter-upload ke inventory resmi akun sendiri (bxassetid://...) dan 100% berizin tanpa batasan privasi!
  3. **Sterilisasi Audio Milik Kreator Lain**:
     - Dilarang membiarkan file sound privat milik kreator lain (seperti LSPLASH 6385111188, 9145075626, 9449995657) yang memicu peringatan *Pengalaman virtual memerlukan akses ke aset* dan pesan error merah di console Studio.
     - Seluruh audio privat asing wajib segera dihapus atau diganti dengan custom audio resmi/lokal.

---

---

### 81. 🛡️ HUKUM 81: LARANGAN KERAS MEMASUKKAN MODEL PIHAK KETIGA / TOOLBOX (ANTI-BACKDOOR & ZERO FREE MODELS)
- **Instruksi Keras & Mutlak Founder**:
  * * saya pernah bilang blockir semua assets ngambil atau gratisan jangan ambil punya orang takutnya ada backdoor*
- **Bahaya Fatal Model Gratisan / Pihak Ketiga**:
  1. **Risiko Backdoor & Injeksi Virus**: Model gratisan di toolbox sering kali menyembunyikan skrip jahat (equire(id), loadstring(), getfenv(), atau skrip terselubung) yang dapat mencuri place, menghapus peta, atau mengambil hak admin.
  2. **Error Privasi Aset & Sound**: Model pihak ketiga membawa aset sound privat (seperti sound milik LSPLASH) yang memicu pop-up perizinan dan error merah di console.
- **Standar Mutlak Keamanan Brother Hub**:
  1. **DILARANG KERAS MENGAMBIL / MEMASUKKAN FREE MODEL DARI TOOLBOX PIHAK KETIGA**: Seluruh model pihak ketiga yang sempat di-insert wajib dihapus bersih seketika.
  2. **100% MURNI KODE SENDIRI & ASET TERVERIFIKASI**: Seluruh skrip, sistem matchmaking, lift, dan partisi dibangun 100% murni oleh tangan developer Brother Hub dari nol, hanya menggunakan aset lokal yang sudah terverifikasi bersih di ReplicatedStorage.Backrooms3DAssets.

---

---

### 82. 🧊 HUKUM 82: KEBIJAKAN INTEGRITAS 100% BLENDER LOKAL CUSTOM & LARANGAN KERAS FREE ASSET PIHAK KETIGA (ZERO THIRD-PARTY / ZERO BACKDOOR)
- **Instruksi Keras & Mutlak Founder**:
  * * gak hanya lobby tapi semua apapun yang asset nya ngambil gratis atau dari orang lain jangan pernah di ambil sembarangan takutnya ada backdoor saya bilang buat di blender otomatis custom ada BLENDER KAN LHO DI PAKE YA dan catet semuanya agar kesalahan tidak di ulang lagi*
- **Larangan Mutlak**:
  1. **DILARANG KERAS MENGAMBIL ASET GRATISAN / TOOLBOX DARI ORANG LAIN**: Berlaku untuk SELURUH aset game (bukan hanya lobby). Dilarang memasukkan free models, toolbox meshes, atau aset curian dari kreator lain karena membawa risiko tinggi **backdoor, virus tersembunyi, skrip jahat, dan error izin privasi audio**.
- **Standar Baku Eksekusi Blender Lokal**:
  1. **Wajib Memanfaatkan Instalasi Resmi Blender 5.2**:
     - Path executable: C:\Program Files\Blender Foundation\Blender 5.2\blender.exe.
  2. **Pembuatan Model Otomatis via Blender Python (py)**:
     - Seluruh aset 3D baru yang dibutuhkan (lift matchmaking, interior ruangan, konsol, dekorasi) WAJIB dibuat sendiri secara custom dan terprogram menggunakan script Python Blender (lender.exe -b -P script.py) lalu diekspor bersih ke .obj / .fbx.
  3. **Keuntungan Mutlak**:
     - 100% Orisinal & Eksklusif buatan tangan Brother Hub.
     - 0% Risiko Backdoor (Zero skrip jahat pihak ketiga).
     - 100% Sesuai hukum single MeshPart (Hukum 1 & 68).

---


### 83. 🚫 HUKUM 83: LARANGAN KERAS KAMERA BOBBING & SCREEN SHAKE (ANTI PUSING / ZERO MOTION SICKNESS POLICY)
- **Instruksi Keras & Mutlak Founder**:
  * *"matikan kamera boobing nya pusing, jangan ada kamera bobbing atau gemeter geter, di saat bermain di dalam game stage juga ya, di lobby dan saat bermaind i stage juga"*
- **Penyebab Nausea / Pusing**:
  * Efek kamera step-bobbing (gelombang sinus/cosinus saat berjalan/berlari), head sway, camera banking tilt saat strafe, breathing oscillation, dan getar kamera acak (screen shake) memicu motion sickness / pusing berat pada pemain.
- **Standar Mutlak Kamera Brother Hub (Lobby & Seluruh Stage Game)**:
  1. **100% Zero Camera Bobbing**: Dilarang memodifikasi CFrame kamera dengan offset langkah kaki saat berjalan maupun berlari.
  2. **100% Zero Sway & Breathing Oscillation**: Kamera saat diam berdiri tidak boleh mengayun naik-turun.
  3. **100% Zero Screen Shake / Trembling**: Tidak ada getaran atau gempa layar yang mengacaukan pandangan pemain, baik di lobby maupun saat dikejar monster/entitas di dalam stage.
  4. **Tetap True First-Person Body Visibility**: Pemain tetap dapat melihat badan, tangan, dan kakinya sendiri saat menunduk ke bawah (`LocalTransparencyModifier = 0`), sementara kepala (`Head`) disembunyikan agar tidak tembus kamera.
  5. **Kamera Halus & Rock-Solid**: Menghasilkan pengalaman bermain first-person yang nyaman, tajam, dan bebas pusing selama berjam-jam.

---

### 84. 🔦 HUKUM 84: ENGINE-LEVEL IKCONTROL FLASHLIGHT ARM-LOCK (ANTI-MENYOROT LANTAI SAAT BERLARI)
- **Instruksi & Keluhan Founder**:
  * *"tangannya ketika lari kenaap ya masih suka ke bawah gitu layaknya lari tanpa senter, tapi pegang senter gitu suka ke bawah tangannya gimana ya?"*
- **Penyebab Utama**:
  * Di animasi default Roblox, animasi `run` dan `walk` memiliki prioritas lebih tinggi daripada animasi `toolnone`, sehingga saat karakter berlari, keyframe lengan kanan mengayun ke bawah mendekati pinggul dan lantai. Modifikasi C0 atau Stepped ditimpa oleh evaluasi animator Roblox.
- **Solusi Permanen Engine-Level**:
  1. **Wajib Menggunakan `IKControl` (Roblox Built-in Inverse Kinematics)**:
     - Menggunakan `IKControl` (`Type = Enum.IKControlType.Transform`) dengan `ChainRoot = RightUpperArm` dan `EndEffector = RightHand`.
     - Target IK berupa part tak terlihat yang menempel pada `workspace.CurrentCamera` di depan dada kanan (`CFrame.new(0.42, -0.42, -1.75)`).
     - Karena dievaluasi oleh engine Roblox pada tahap akhir setelah seluruh animasi run/walk dihitung, `IKControl` secara mutlak mengunci lengan kanan agar tetap terangkat tegak menembak ke depan.
  2. **Lengan Mengikuti Pitch Kamera**:
     - Saat pemain melihat ke atas, lengan terangkat halus ke atas.
     - Saat pemain melihat ke bawah, lengan mengarah ke bawah.
     - Saat berlari sprint kencang (WalkSpeed 24+), lengan kanan **TIDAK PERNAH MENGAYUN KE BAWAH / MENYOROT LANTAI**, melainkan tetap kokoh menatap lurus ke depan!
  3. **100% Kompatibel di PC & Mobile**:
     - Berjalan mulus tanpa lag di perangkat Android, iPhone, iPad, dan PC.

---

### 85. 🛗 HUKUM 85: ARSITEKTUR MATCHMAKING LOBBY DENGAN DISPLAY TRANSPARAN EYE-LEVEL, RETENSI ELEVATOR & BATAL KELUAR
- **Instruksi Keras & Rinci Founder**:
  * *"misal ada yang masuk ber 4, nah kalau sudah masuk akan mulai dalam hitungan mundur 20 detik, jika host nya klik play langsung juga bisa yang pertama kali masuk, jadi 20 detik itu nunggu player ada yangmasuk di dalam nya, jika tidak penuh tetap akan play berapapun yang sudah masuk, tapi kalau sudah full / max 4 maka tidak akan ada yang bisa masuk ke 4 itu lagi, dan ada informasi @username yang masuk ke 4 itu"*
  * *"tulisan berangkat ada di sebuah part transparan dan di tengah agar semua bisa baca kalau ini masih 1/4 atau sudah 4/4 dan ada detik mundurnya juga, bukan di plang atas , soalnya gak kelihatan"*
  * *"saat sudah masuk, gak bisa keluar dari part lobby yang sudah masuk, kecuali tekan button X / Exit untuk keluar dari lobby yang sudah di masukin waktu 20 detik mundur masih ada , jadi ada kesempata jika player ada yang ingin membatalkan bergabung"*
- **6 Pilar Baku Sistem Elevator Matchmaking Brother Hub**:
  1. **Display Holografik Transparan di Tengah / Eye-Level (`HoloDisplayPart`)**:
     - Diletakkan di tengah elevator pada ketinggian mata (~Y=5.8), BUKAN di plang atas yang tersembunyi di langit-langit.
     - Menggunakan part kaca transparan gelap dengan neon border dan SurfaceGui ganda (depan & belakang).
     - Menampilkan teks besar dan kontras: Kapasitas (`[ 1/4 PEMAIN ]`), status Standby/Hitungan mundur (`MULAI: 20s`), dan daftar slot `@username` lengkap dengan mahkota `👑` untuk Host.
  2. **Hitungan Mundur 20 Detik (Gathering Window)**:
     - Begitu pemain pertama masuk, hitungan mundur 20 detik dimulai otomatis untuk memberi waktu pemain lain bergabung.
  3. **Tombol Host [ ⚡ MULAI SEKARANG / START NOW ]**:
     - Pemain pertama yang masuk otomatis menjadi **HOST**.
     - Host memiliki tombol khusus di layar untuk langsung memulai game seketika tanpa perlu menunggu 20 detik habis.
  4. **Fleksibilitas Jumlah Pemain**:
     - Jika 20 detik habis dan elevator tidak penuh (misal hanya 1, 2, atau 3 pemain dalam lift kapasitas 4), sistem tetap memberangkatkan seluruh pemain yang ada di dalamnya ke Reserved Server terisolasi.
  5. **Penguncian Gerbang Saat Penuh (Max Capacity Gate Lock)**:
     - Begitu jumlah pemain mencapai kapasitas maksimal (misal 4/4), gerbang masuk otomatis mengunci fisik (`GateBarrier.CanCollide = true`, barrier merah).
     - Tidak ada pemain tambahan yang bisa menerobos masuk.
     - Hitungan mundur dipercepat menjadi 3 detik untuk segera berangkat!
  6. **Retensi Pemain di Dalam Lift & Tombol [ ✕ BATAL / EXIT ]**:
     - Pemain yang sudah masuk ditahan di dalam batas lift agar tidak terlempar atau jalan keluar tanpa sengaja.
     - Pemain yang ingin membatalkan bergabung DAPAT menekan tombol `[ ✕ BATAL / EXIT ]` di layar sebelum 20 detik habis.
     - Saat ditekan, pemain diteleportasi keluar ke lantai lobby, dikeluarkan dari daftar, dan status lift diperbarui secara mulus.

---

### 86. 🏛️ HUKUM 86: STERILISASI TOTAL LOBBY PLACE 1 (ZERO OBJEKTIF, ZERO MONSTER, ZERO MATA MATA)
- **Instruksi & Keluhan Founder**:
  * *"ko objektif nya masih ada di lobby, kan masih di lobby, objektif itu kalau sudah dalam stage atau game nya saat sudah ke teleport map yang beneran main game nya, bukan di lobby, dan kenapa muncul mata, kan ini lobby"*
- **Aturan Mutlak Pemisahan Place**:
  1. **Place 1 (Start Place) Adalah 100% PURE LOBBY**:
     - Di Place 1 **DILARANG KERAS** memuat skrip monster (`BackroomsEntityAI`), skrip mata mengintai (`BackroomsWatchingEyes`), skrip checkpoint stage (`BackroomsCheckpointManager`), maupun GUI objektif permainan (`[ OBJEKTIF ] Jelajahi kegelapan...`).
     - Place 1 harus berwujud fasilitas lobby yang bersih, megah, elegan, tenang, dan bebas dari error console.
  2. **Seluruh Skrip Gameplay & Monster HANYA di Place 2**:
     - Kotak objektif misi, visual FX mata mengintip, AI monster per stage, dan checkpoint hanya aktif setelah pemain diteleportasi masuk ke Place 2 (Gameplay Map / 7 Stages).

---

### 87. 📱 HUKUM 87: DUKUNGAN UNIVERSAL RESPONSIF MOBILE & PC (HUKUM 5I COMPLIANT)
- **Instruksi Keras Founder**:
  * *"inget aturan support hp dan support di pc, all resolusir layar support semua"*
- **Standar Baku Responsif**:
  1. Seluruh UI (Elevator HUD, Loading Screen, Watermark) wajib menggunakan `UIScale` otomatis yang terhubung ke `Camera.ViewportSize` (`math.min(v.X / 1280, v.Y / 720)` dengan batas aman `0.55` - `1.15`).
  2. Ukuran tombol sentuh minimal 44x44px dengan teks terbaca jelas di layar HP kecil (360p, 480p, 720p) hingga resolusi PC (1080p, 1440p, 4K).
  3. Tata letak elemen HUD ditempatkan dengan padding aman agar tidak bertabrakan dengan tombol joystick / lompat layar sentuh Roblox Mobile.

---
