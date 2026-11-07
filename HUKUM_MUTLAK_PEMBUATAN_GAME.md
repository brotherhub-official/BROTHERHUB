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

## 🗺️ MASTER SPATIAL ALLOCATION REGISTRY (PROYEK HOROR / BACKROOMS)

| Zona / Stage | Bounding Box X | Bounding Box Y (Elevasi Aman) | Bounding Box Z | Deskripsi & Fungsi |
|:---|:---:|:---:|:---:|:---|
| **Stage 1 (Level 0: The Maze)** | `0 .. 600` | `200 .. 216` | `0 .. 600` | Labirin tak berujung 600x600, wallpaper mono-yellow, karpet basah, 64 array lampu neon, bukaan Selatan di `X=500, Z=600`. |
| **The Bathrooms (Sub-Stage)** | `450 .. 550` | `200 .. 216` | `600 .. 720` | Kamar mandi marmer 100x120 studs, 6 wastafel porselen single MeshPart, 6 bilik toilet single MeshPart, cermin continuous, bukaan prosotan di `X=500, Z=720`. |
| **The Yellow Slide (Chute)** | `485 .. 515` | `62 .. 214` | `718 .. 1100` | Prosotan tabung kuning tertutup 380 studs meluncur dari `Y=202` ke `Y=62`, through-wall collar kedap void, landing pavilion rumput Suburbs. |
| **Stage 2 (Level 9: The Dark Suburbs)** | `-100 .. 1100` | `60 .. 100` | `900 .. 2100` | Jalan aspal 1,200x1,200 studs, trotoar beton, lampu jalan berkabut, 3 rumah suburban enterable, tangga basement Rumah 1 menuju Level 37. |
| **Stage 3 (Level 37: The Poolrooms)** | `-300 .. 700` | `15 .. 50` | `800 .. 1800` | Kompleks kolam renang porselen 1,000x1,000 studs, AIR NYATA (Terrain Water), kolam olimpiade, palka menuju Level 1. |
| **Stage 4 (Level 1: Parking Garage)** | `700 .. 1500` | `60 .. 85` | `1200 .. 2000` | Garasi parkir beton 800x800 studs, 36 kolom bernomor hazard yellow, palka ke mall. |
| **Stage 5 (Level 33: The Abandoned Mall)** | `1100 .. 1900` | `60 .. 110` | `2000 .. 2800` | Mall megah 2 lantai 800x800 studs, atrium kaca, toko retro arcade & cafe, pintu Fun Zone. |
| **Stage 6 (Level 18: The Playrooms)** | `-300 .. 300` | `60 .. 95` | `2100 .. 2700` | Taman bermain 600x600 studs, mandi bola raksasa 100x100 studs, tabung merangkak warna-warni. |
