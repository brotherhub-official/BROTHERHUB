# 👑 BROTHER HUB — ENSIKLOPEDIA & DOKUMENTASI TEKNIS LENGKAP MASTER ECOSYSTEM (31 GAMES)

Dokumen ini adalah **catatan teknis master 100% lengkap dan menyeluruh** untuk seluruh ekosistem **Brother Hub**. Dokumen ini mencatat setiap data, hasil dump saveinstances, arsitektur skrip, mekanisme remote server, formula kecepatan, ID role Discord, peraturan Founder, hingga konfigurasi internal untuk semua game yang didukung.

---

## DAFTAR ISI
1. [Bagian I: Deep Dive Teknis Drill to Earth's Core (New Dumps & In-Earth Save)](#bagian-i-deep-dive-teknis-drill-to-earths-core)
2. [Bagian II: Deep Dive Teknis Mrbeast Island Escape (Workspace & Vacuum System)](#bagian-ii-deep-dive-teknis-mrbeast-island-escape)
3. [Bagian III: Deep Dive Teknis Unbox ASMR (67 Crates, 12 Rarities & Rebirths)](#bagian-iii-deep-dive-teknis-unbox-asmr)
4. [Bagian IV: Master Roster 31 Game Resmi Brother Hub (Role ID & Mekanisme)](#bagian-iv-master-roster-31-game-resmi-brother-hub)
5. [Bagian V: Hukum Mutlak & Standarisasi Desain Brother Hub (Rules 1 - 12E)](#bagian-v-hukum-mutlak--standarisasi-desain-brother-hub)
6. [Bagian VI: Pipeline Kompilasi, Obfuskasi & Build System](#bagian-vi-pipeline-kompilasi-obfuskasi--build-system)

---

# BAGIAN I: DEEP DIVE TEKNIS DRILL TO EARTH'S CORE

### 1.1 Metadata Game & Tempat (Place Information)
* **Game Title**: Drill to Earth's Core
* **Lobby Place ID**: `101906032112547`
* **In-Game / Main Earth Place ID**: `74507545904779`
* **Universe ID**: `9796898051`
* **Framework Engine**: Knit (Roblox Modular Framework) & Roact / Fusion UI Engine

### 1.2 Analisis Berkas Dump Terbaru (`New Drill to Earths Core/`)
Folder dump `Drill to Earths Core/New Drill to Earths Core/` memuat 21 berkas `.rbxmx` yang membagi dua fase permainan secara presisi:
1. **Fase Lobby (`New di Lobby ...`)**:
   * `New di Lobby BackPack di bawah Players Drill to Earths Core.rbxmx` (6,175 B)
   * `New di Lobby Lighting Drill to Earths Core.rbxmx` (5,024 B)
   * `New di Lobby Nama Player (Model) di bawah StarterPlayer Drill to Earths Core.rbxmx` (2,878,948 B)
   * `New di Lobby Nil Instances Drill to Earths Core.rbxmx` (32,564 B)
   * `New di Lobby Players Drill to Earths Core.rbxmx` (13,198,942 B)
   * `New di Lobby ReplicatedFirst Drill to Earths Core.rbxmx` (47,855 B)
   * `New di Lobby ReplicatedStorage Drill to Earths Core.rbxmx` (11,655,163 B)
   * `New di Lobby StarterCharacterScripts Drill to Earths Core.rbxmx` (24,552 B)
   * `New di Lobby StarterPlayerScripts Drill to Earths Core.rbxmx` (689,637 B)
   * `New di Lobby Workspace Drill to Earths Core.rbxmx` (35,752,155 B)
2. **Fase In-Earth / Kedalaman Bumi (`New di dalam Earth ...`)**:
   * `New di dalam Earth BackPack di bawah Players Drill to Earths Core.rbxmx` (7,082 B)
   * `New di dalam Earth Lighting Drill to Earths Core.rbxmx` (4,344 B)
   * `New di dalam Earth Nil Instances Drill to Earths Core.rbxmx` (46,191 B)
   * `New di dalam Earth Players Drill to Earths Core.rbxmx` (13,060,088 B)
   * `New di dalam Earth ReplicatedFirst Drill to Earths Core.rbxmx` (5,353 B)
   * `New di dalam Earth ReplicatedStorage Drill to Earths Core.rbxmx` (4,218,902 B)
   * `New di dalam Earth StarterCharacterScripts Drill to Earths Core.rbxmx` (26,073 B)
   * `New di dalam Earth StarterGui Drill to Earths Core.rbxmx` (5,285,695 B)
   * `New di dalam Earth StarterPack Drill to Earths Core.rbxmx` (2,299 B)
   * `New di dalam Earth StarterPlayerScripts Drill to Earths Core.rbxmx` (1,495,906 B)
   * `New di dalam Earth Workspace Drill to Earths Core.rbxmx` (20,810,442 B)

### 1.3 Arsitektur Eksekusi Senjata & Remote Server (Dual-Dispatch Engine)
Game menggunakan struktur **Knit Framework** di mana aksi pemukulan (`Swing`) tidak dipicu lewat click listener biasa, melainkan melalui dual-pipeline:
1. **Client Controller**:
   * Controller utama: `Knit.GetController("ToolController")`
   * Instance alat aktif: `ToolController.ActiveTool`
   * Trigger fungsi lokal: `ActiveTool:Swing()`
   * Signal eksekusi client: `ActiveTool.Execute:Fire({"Swing", targetList})`
2. **Server Service Dispatch**:
   * Service utama: `Knit.GetService("ToolService")`
   * Remote Event: `ReplicatedStorage.ToolService.Update`
   * Remote Function Equip: `ReplicatedStorage.ToolService.EquipTool`
   * Dispatch argumen server: `sendToolServerUpdate({"Swing", targetList})`
   * Fallback Roblox Tool: `Tool:Activate()`

### 1.4 Formula Kecepatan Serang (Attack Speed) & Sistem Kelas Samurai
Dari dump `AttackSpeed` dan `ClassesController`:
* **Formula Interval Swing**:
  $$\text{Interval} = \frac{1}{\text{math.max}(0.5, \text{atkSpeed} \times \text{classMultiplier})}$$
* **Sistem Kelas Samurai (150% Boost)**:
  * Atribut tim: `LocalPlayer:GetAttribute("ClassTeamMeleeAttackSpeedMultiplier")`
  * Kelas terpilih: `LocalPlayer:GetAttribute("EquippedClass") == "Samurai"`
  * Multiplier kelas memberikan kenaikan **1.8x hingga 2.5x kecepatan ayunan**.
  * Window rate-limiter server yang aman (Safe Window Anti-Kick):
    * **Pickaxe Safe Window**: `math.clamp(1 / atkSpeed, 0.28, 0.40)` detik.
    * **Sword Melee Safe Window**: `math.clamp(1 / (atkSpeed * classMult), 0.24, 0.38)` detik.
* **Tool Attribute Safe Keeper**:
  Setiap kali alat dipegang, script wajib memastikan atribut `Range` dan `LookRadius` bernilai minimal `25` hingga `50` untuk mencegah error aritmatika nil pada kode klien bawaan game.

### 1.5 Target Bounds & Ore Sweep Detection
Untuk menjamin damage pukulan masuk 100% ke server tanpa meleset:
1. **Target Resolving**:
   * Pengecekan `CollectionService:HasTag(target, "Ore")` atau `"RockWall"`.
   * Pengecekan Model musuh / monster di kedalaman.
2. **Proximity Box Sweep**:
   * Menggunakan `workspace:GetPartBoundsInBox(root.CFrame * CFrame.new(0, 0, -4), Vector3.new(20, 20, 20), OverlapParams)`
   * Menemukan semua node batu di sekitar pemain dan memasukkannya ke dalam tabel `targetList` secara serentak.
3. **Rock Collision Restorer**:
   * Seluruh part pada folder `workspace.Ores`, `workspace.Rocks`, `workspace.RockWalls`, dan `workspace.DigSpots` dipulihkan atribut fisiknya (`CanCollide = true`, `CanQuery = true`, `CanTouch = true`) agar tidak menjadi "ghost part" atau noclip tembus tanah yang merusak raycast senjata.

### 1.6 Sistem Kegelapan (`DarknessUtil`) & Fullbright
* Atribut status: `LocalPlayer:GetAttribute("InDarknessZone")`
* Efek debuff jika di zona gelap tanpa obor:
  * Kecepatan jalan (WalkSpeed) dikurangi hingga 40%.
  * Kecepatan pukul (Melee Speed) dikurangi hingga 50%.
  * Damage melee dikurangi 50%.
* **Solusi Brother Hub**: Fullbright Engine memodifikasi `Lighting.Brightness = 2`, `Lighting.ClockTime = 14`, `Lighting.FogEnd = 100000`, serta meniadakan efek gelap visual sehingga pemain tetap memiliki jarak pandang 100% jernih di kedalaman ekstrem bumi.

### 1.7 Tabel Drop Peti Harta Karun (Chest Loot Odds Dump)
Data otentik dari `dumps_drill_earth/Earth.rbxlx_AttackSpeed.lua`:
| Nama Peti | Harga | Icon Asset | Peluang Rotasi | Drop Utama & Odds (%) |
|---|---|---|---|---|
| **Common Chest** | 100 Koin | `rbxassetid://71702614726340` | 55% | Medkit (10%), SpeedPotion (10%), Landmine (8%), Decoy Grenade (5.75%), Dynamite (5.75%), Rusty Pickaxe/Helmet/Boots/Sword (5%), RPG (0.75%) |
| **Gold Chest** | 250 Koin | `rbxassetid://79723282917774` | 35% | Invisibility Potion (6.25%), Steel Tools/Armor (5.25%), Gold Boots/Helmet (4.25%), Gold Pickaxe/Sword (3.25%), Diamond Gear (1.25%), ReviveKit (1%), Void Revolver (1%) |
| **Diamond Chest** | 500 Koin | `rbxassetid://81951988554564` | 9% | Gold Boots (10%), Golden Medkit (7%), Diamond Gear (3.5% - 5%), Void Gear (1% - 3.75%), Void Rifle (1%), Void Chest (0.75%) |
| **Void Chest** | 1,000 Koin | `rbxassetid://129434825921377` | 1% | Diamond Gear (5.5% - 7%), ReviveKit (5%), Void Gear (3% - 5.75%), Phoenix Gear (1.5% - 4.25%), BlackHoleGun (2.25%), King's Armor (0.05%), **Sword Excalibur (0.05%)** |

### 1.8 10-Layer Depth Teleportation System
Daftar koordinat kedalaman resmi bumi:
1. `Surface / Basecamp`: Kedalaman 0m
2. `Dirt Layer`: Kedalaman 50m - 200m
3. `Clay & Limestone`: Kedalaman 250m - 500m
4. `Stone Caverns`: Kedalaman 600m - 1,200m
5. `Iron & Copper Veins`: Kedalaman 1,300m - 2,500m
6. `Crystal Caverns`: Kedalaman 2,600m - 4,000m
7. `Molten Basalt`: Kedalaman 4,100m - 6,000m
8. `Magma Chambers`: Kedalaman 6,100m - 8,500m
9. `Obsidian Mantle`: Kedalaman 8,600m - 11,000m
10. `Earth's Core`: Kedalaman 12,000m+

---

# BAGIAN II: DEEP DIVE TEKNIS MRBEAST ISLAND ESCAPE

### 2.1 Metadata Game & Tempat
* **Game Title**: Mrbeast Island Escape
* **Place ID**: `108645230905176`
* **Arsitektur GUI**: 1:1 My Flower Shop Standar Lebar (640 x 420) dengan Inline Accordion Dropdowns di dalam `PageFrame` (Zero Mobile Clipping).

### 2.2 Hierarki Real Workspace
Struktur folder workspace hasil saveinstance:
* `Workspace.Buildings`: Memuat bangunan pulau seperti `Campfire`, `Boat_Construct`, `Workbench`, `Storage_Box`, `Tent`, dan `Bed`.
* `Workspace.DroppedItems`: Wadah utama seluruh barang hasil tebangan pohon, tambang batu, dan drop hewan yang jatuh di tanah.
* `Workspace.Chest`: Wadah seluruh peti harta karun (`Loot Box Gold`, `Loot Box House`, `Kidnapped Person`, dll).
* `Workspace.Entities`: Wadah seluruh makhluk hidup dan monster pulau.

### 2.3 Mekanisme Remote & Service Hook
1. **Pengambilan Drop**:
   * Service: `ReplicatedStorage.Engine.Service.ItemCollect`
   * Remote Event: `ReplicatedStorage.Events.collectResourceRemote`
2. **Equip Senjata & Alat**:
   * Remote Event: `ReplicatedStorage.equipRemote`
3. **Peti Harta Karun**:
   * Remote Event: `ReplicatedStorage.Events.openChestRemote`
   * Trigger: `fireproximityprompt(prompt, 20, true)` dengan `HoldDuration = 0` (Instant 0 Detik).

### 2.4 Sistem Drop Vacuum Cerdas (Universal Drop Vacuum)
Daftar item yang didukung oleh sistem vakum:
* `Wood` (Kayu) & `Timber` / `Log`
* `Stone` (Batu) & `Iron Stone`
* `Iron Ingot` (Besi Batangan) & `Iron Ore`
* `Meat` (Daging Hewan) & `Egg` (Telur)
* `Crab` (Kepiting)
* `Torch` (Obor Penerang)
* `Loot Box Gold` & `Loot Box House`
* Opsi filter dinamis via inline dropdown multiselect.

### 2.5 Koordinat Penting Pulau (Landmarks Resolver)
* **Campfire (Api Unggun Pusat)**: `Vector3.new(-24.999, 5.5, -676.998)`
* **Boat Construct (Kapal Pelarian MrBeast)**: `Vector3.new(-25.0, 9.0, -715.87)`
* **Mekanisme Anti-Jitter**: Saat mendekati objek atau monster, script menggunakan `smoothApproach` dengan offset `Vector3.new(2.8, 0.4, 2.8)` dan mereset `AssemblyLinearVelocity = Vector3.zero` serta `AssemblyAngularVelocity = Vector3.zero` agar karakter tidak mantul atau terlempar.

---

# BAGIAN III: DEEP DIVE TEKNIS UNBOX ASMR

### 3.1 Metadata Game & Tempat
* **Game Title**: Unbox ASMR
* **Place ID**: `87910543505877`
* **Arsitektur GUI**: 1:1 My Flower Shop Exact Architecture (660 x 440), Neon RGB Stroke 360°, MinCircle 80x80.

### 3.2 Katalog Otentik 67 Crates (61 Utama + 6 Event Honey)
Daftar lengkap 67 peti dari `ReplicatedStorage.ProductCatalogConfig` & `EventProducts`:

#### Crate Utama (61 Crates):
1. `Wood Crate` ($10)
2. `Cardboard Crate` ($50)
3. `Plastic Crate` ($250)
4. `Iron Crate` ($1,000)
5. `Steel Crate` ($5,000)
6. `Bronze Crate` ($25,000)
7. `Silver Crate` ($100,000)
8. `Gold Crate` ($500,000)
9. `Platinum Crate` ($2.5M)
10. `Diamond Crate` ($10M)
11. `Emerald Crate` ($50M)
12. `Ruby Crate` ($250M)
13. `Sapphire Crate` ($1B)
14. `Amethyst Crate` ($5B)
15. `Obsidian Crate` ($25B)
16. `Crystal Crate` ($100B)
17. `Plasma Crate` ($500B)
18. `Dubai Chocolate Crate` ($1.2T) — *Peti Sultan Termahal!*
19. `Magma Crate` ($2.5T)
20. `Neon Crate` ($10T)
21. `Cyber Crate` ($50T)
22. `Quantum Crate` ($250T)
23. `Cosmic Crate` ($1Qa)
24. `Galactic Crate` ($5Qa)
25. `Nebula Crate` ($25Qa)
26. `Supernova Crate` ($100Qa)
27. `Black Hole Crate` ($500Qa)
28. `Vortex Crate` ($2.5Qi)
29. `Singularity Crate` ($10Qi)
30. `Infinity Crate` ($50Qi)
31. `Eternity Crate` ($250Qi)
32. `Immortal Crate` ($1Sx)
33. `Mythical Crate` ($5Sx)
34. `Legend Crate` ($25Sx)
35. `Godly Crate` ($100Sx)
36. `Celestial Crate` ($500Sx)
37. `Divine Crate` ($2.5Sp)
38. `Heavenly Crate` ($10Sp)
39. `Angelic Crate` ($50Sp)
40. `Archangel Crate` ($250Sp)
41. `Seraphim Crate` ($1Oc)
42. `Transcendent Crate` ($5Oc)
43. `Omnipotent Crate` ($25Oc)
44. `Alpha Crate` ($100Oc)
45. `Omega Crate` ($500Oc)
46. `Genesis Crate` ($2.5N)
47. `Apocalypse Crate` ($10N)
48. `Void Crate` ($50N)
49. `Abyss Crate` ($250N)
50. `Chaos Crate` ($1Dc)
51. `Order Crate` ($5Dc)
52. `Balance Crate` ($25Dc)
53. `Eclipse Crate` ($100Dc)
54. `Solar Crate` ($500Dc)
55. `Lunar Crate` ($2.5Ud)
56. `Stellar Crate` ($10Ud)
57. `Astral Crate` ($50Ud)
58. `Dimension Crate` ($250Ud)
59. `Multiverse Crate` ($1Dd)
60. `Omniverse Crate` ($5Dd)
61. `Secret Master Crate` ($25Dd)

#### Event Crates (6 Honey Event Crates):
62. `Honey Crate` (100 Madu)
63. `Honeycomb Crate` (500 Madu)
64. `Beehive Crate` (2,500 Madu)
65. `Queen Bee Crate` (10,000 Madu)
66. `Royal Jelly Crate` (50,000 Madu)
67. `Golden Nectar Crate` (250,000 Madu)

### 3.3 Sistem Kelangkaan (12 Rarities) & Pity Engine
1. `Common` (Putih) — 50.0%
2. `Uncommon` (Hijau Muda) — 25.0%
3. `Rare` (Biru) — 12.5%
4. `Epic` (Ungu) — 6.5%
5. `Legendary` (Emas/Kuning) — 3.5%
6. `Mythic` (Merah/Oranye) — 1.5%
7. `Divine` (Cyan Terang) — 0.6%
8. `Secret` (Hitam / Magenta) — 0.25%
9. `Exotic` (Pelangi Berkedip) — 0.1%
10. `Ancient` (Bronze Glow) — 0.04%
11. `Cosmic` (Ungu Galaksi) — 0.009%
12. `Celestial` (Emas Bersinar) — 0.001%
* **Pity Counter**: Setiap 1,000 unbox membuka garansi drop Divine+, dan setiap 10,000 unbox memberikan jaminan drop Secret / Cosmic.

### 3.4 Upgrade Konveyor, Pekerja & Mini-Games
* **Upgrade Konveyor**:
  * Speed: Tier 1 (1.0x) hingga Tier 7 (5.0x Speed)
  * Value Multiplier: Tier 1 (1.2x) hingga Tier 5 (10.0x Coins)
* **Pekerja Otomatis (Workers)**: 20 Tingkatan dari Intern ($500) hingga Quantum Automation Robot ($50B).
* **Mini-Games Interaktif**:
  * `Shredder`: Menghancurkan item untuk koin ekstra instan.
  * `Hydraulic Press`: Memipihkan item untuk bonus multiplier ASMR.
  * `Crocodile Dentist`: Game ketangkasan gigi buaya dengan hadiah permata.
  * `Lucky Spin Wheel`: Roda keberuntungan harian (Koin, Gems, Multiplier Boost).
  * `Quests Board`: Misi harian dan mingguan otomatis.


### 3.5 Pembaruan Unbox ASMR v2.0 (Infinite Camera Zoom, Base ASMR Level Upgrades & Event Rarities)
* **Buka Batas Kamera (Infinite Zoom Out)**:
  * Mengatasi keterbatasan kamera bawaan Roblox/Game yang membatasi jarak pandang pemain di sekitar conveyor.
  * Mengatur `LocalPlayer.CameraMaxZoomDistance` hingga 3,000 studs (default 1,000 studs) dengan event listener protektif yang menjaga zoom tidak di-reset oleh skrip client game.
* **Auto Upgrade Level Mainan ASMR di Plot (Tombol Kuning Lvl Up)**:
  * Menyelesaikan kebutuhan upgrade level station/mainan ASMR di meja (`▲ $11.1B Lvl 32 > Lvl 33`, `▲ $11.6B Lvl 84 > Lvl 85`, `▲ $34.2B Lvl 11 > Lvl 12`).
  * Menggunakan remote `ReplicatedStorage.ASMRRewardRemotes.RequestUpgrade:FireServer(model)` dengan parameter model mainan ASMR milik LocalPlayer (`desc:GetAttribute("OwnerUserId") == LocalPlayer.UserId`).
  * Dilengkapi fitur loop otomatis (`config.autoUpgradePlacedASMR`) dan tombol instan sekali klik (`▲ Upgrade Semua Level Mainan ASMR Sekali Klik`).
* **Klasifikasi Resmi Rarity Event (Index 54/130)**:
  * Berdasarkan arsitektur internal `ProductCatalogConfig` v9, item-item berkategori:
    1. `Cosmic` (`cosmicEventProduct`)
    2. `Fire & Ice` (`fireIceEventProduct`)
    3. `Nature` (`natureEventProduct`)
    4. `Music` (`musicEventProduct`)
    5. `Sea` (`seaEventProduct`)
    6. `Candy` (`CandyEventConfig`)
    7. `Honey` (`honeyEventProduct`)
    adalah **100% PRODUK EKSKLUSIF EVENT** (`EventExclusive = true`, `NoCrate = true`).
  * Rarity tersebut diperoleh khusus dari peti event live map (Galaxy Crates, Fire & Ice Crates, Nature Crates, Sea Crates, Music Crates, Candy Crates) dan telah diintegrasikan ke Multi-Select Rarity dropdown Brother Hub.

### 3.6 Pembaruan Unbox ASMR v2.5 (Selective ASMR Level Upgrade, Droplist Target & Cash-Safe Engine)
* **Latar Belakang & Kebutuhan Pemain**:
  * Pemain memasang berbagai macam mainan hasil buka peti di base/plot mereka (*Squishy Dumpling*, *Chroma Keyboard*, *Wax Soap*, *Fluffy Pancakes*, dll.) dengan tingkatan level dan biaya upgrade yang berbeda (`$11.1B`, `$34.2B`, `$48B`, `$60.2B`).
  * Fitur lama menaikkan semua mainan secara massal, mengakibatkan pemborosan saldo Cash pada mainan yang tidak diinginkan. Pemain menginginkan fleksibilitas untuk memilih mainan mana yang ingin dinaikkan levelnya via dropdown, berapa level kenaikannya (+1, +2, +3, +4, +5, +6, +10, +25, +50, atau Max), serta proteksi bahwa proses tidak akan berjalan jika Cash tidak cukup.
* **Solusi Arsitektur Brother Hub v2.5**:
  1. *Dynamic Plot Scanner & Tagging (`getPlacedASMRToys`)*: Memindai seluruh model mainan aktif di plot base pemain, menghasilkan tag terstruktur lengkap dengan slot, nama resmi, level aktif, dan biaya: `[#1] Squishy Dumpling (Lvl 11 | $34.2B)`.
  2. *Live Dropdown & Auto-Reselect*: Menyediakan dropdown pilihan `🌟 Semua Mainan di Base (All Placed)` dan mainan individual, tombol refresh real-time, serta sistem pelacakan indeks yang cerdas agar pilihan tidak hilang saat level berubah.
  3. *Multi-Step & Max Upgrade Selector*: Pilihan kenaikan level bertingkat `+1 Level` s/d `+50 Level` dan `⚡ Max Level (Upgrade Maksimal Sesuai Cash)`, serta Slider Kustom (1 - 50) dengan input langsung.
  4. *Pre-Flight Cash-Safe Engine*: Membaca saldo Cash pemain via `leaderstats.Cash`, atribut `Cash`, dan HUD, mem-parse teks denominasi biaya (`parseCurrency`), serta memvalidasi `if playerCash < cost then abort` sebelum setiap panggilan remote `RequestUpgrade:FireServer(model)`. Mencegah saldo minus, kegagalan eksekusi, atau error spam.
  5. *Dual Execution Mode*: Tombol eksekusi manual seketika (`▲ Jalankan Upgrade Sekarang`) dan toggle latar belakang (`Auto Upgrade Level (Background Loop)`).

---


# BAGIAN IV: MASTER ROSTER 33 GAME RESMI BROTHER HUB

Tabel di bawah adalah **Sumber Kebenaran Tunggal (Single Source of Truth)** untuk 33 game resmi yang didukung penuh oleh Brother Hub:

| No | Game Name | Script File (`CleanHub/`) | Build File (`/` & `ObfuscateHub/`) | Official Role Discord | Discord Role ID | Status |
|---|---|---|---|---|---|---|
| 1 | **Deep Fishing** | `DeepFishing_Clean.lua` | `DeepFishing_BROTHERHUB.lua` | 🌊 Deep Fishing | `1551587483320459344` | ✅ AKTIF |
| 2 | **Pets Universe** | `PetsUniverse_Clean.lua` | `PetsUniverse_BROTHERHUB.lua` | 🐾 Pets Universe | `1551531361582714892` | ✅ AKTIF |
| 3 | **Dungeons Tower** | `DungeonsTower_Clean.lua` | `DungeonsTower_BROTHERHUB.lua` | 🏰 Dungeons Tower | `1551509714968256552` | ✅ AKTIF |
| 4 | **Steal A Seed** | `StealASeed_Clean.lua` | `StealASeed_BROTHERHUB.lua` | 🌱 Steal A Seed | `1550416813861642300` | ✅ AKTIF |
| 5 | **Fish On** | `FishOn_Clean.lua` | `FishOn_BROTHERHUB.lua` | 🎣 Fish On | `1550403712017633280` | ✅ AKTIF |
| 6 | **Mine It** | `MineIt_Clean.lua` | `MineIt_BROTHERHUB.lua` | ⛏️ Mine It | `1550349404198932501` | ✅ AKTIF |
| 7 | **Pack A Brainrot Card** | `PackABrainrotCard_Clean.lua` | `PackABrainrotCard_BROTHERHUB.lua` | 🃏 Pack A Brainrot Card | `1550180173343629384` | ✅ AKTIF |
| 8 | **Loot Up** | `LootUp_Clean.lua` | `LootUp_BROTHERHUB.lua` | 💎 Loot Up | `1550176741702770799` | ✅ AKTIF |
| 9 | **Clicker Simulator** | `ClickerSimulator_Clean.lua` | `ClickerSimulator_BROTHERHUB.lua` | 🖱️ Clicker Simulator | `1550133314613026856` | ✅ AKTIF |
| 10 | **Shogun's Reign** | `ShogunsReign_Clean.lua` | `ShogunsReign_BROTHERHUB.lua` | ⚔️ Shogun's Reign | `1550077004747899013` | ✅ AKTIF |
| 11 | **Heavyweight Fishing** | `HeavyweightFishing_Clean.lua` | `HeavyweightFishing_BROTHERHUB.lua` | 🎣 Heavyweight Fishing | `1550069397664571503` | ✅ AKTIF |
| 12 | **Pop Bubbles** | `PopBubbles_Clean.lua` | `PopBubbles_BROTHERHUB.lua` | 🫧 Pop Bubbles | `1550065206145581106` | ✅ AKTIF |
| 13 | **Catch Dragons To Defend** | `CatchDragons_Clean.lua` | `CatchDragons_BROTHERHUB.lua` | 🐉 Catch Dragons To Defend | `1550061654383792250` | ✅ AKTIF |
| 14 | **Farm Industry** | `FarmIndustry_Clean.lua` | `FarmIndustry_BROTHERHUB.lua` | 🌾 Farm Industry | `1549290683628527618` | ✅ AKTIF |
| 15 | **Poly Loot** | `PolyLoot_Clean.lua` | `PolyLoot_BROTHERHUB.lua` | ⚔️ Poly Loot | `1549290685645983764` | ✅ AKTIF |
| 16 | **Storage Hunters** | `StorageHunters_Clean.lua` | `StorageHunters_BROTHERHUB.lua` | 📦 Storage Hunters | `1549290694143778886` | ✅ AKTIF |
| 17 | **Defeat Anime RNG** | `DefeatAnimeRNG_Clean.lua` | `DefeatAnimeRNG_BROTHERHUB.lua` | 💥 Defeat Anime RNG | `1549290698464034816` | ✅ AKTIF |
| 18 | **Drill to Earth's Core** | `DrillToEarth_Clean.lua` | `DrillToEarth_BROTHERHUB.lua` | 🌍 Drill to Earth's Core | `1549290696320491561` | ✅ AKTIF |
| 19 | **Idle Mafia** | `IdleMafia_Clean.lua` | `IdleMafia_BROTHERHUB.lua` | 🕵️ Idle Mafia | `1549290691992223844` | ✅ AKTIF |
| 20 | **Dungeon Lootr** | `DungeonLootr_Clean.lua` | `DungeonLootr_BROTHERHUB.lua` | ⚔️ Dungeon Lootr | `1549290687382552669` | ✅ AKTIF |
| 21 | **Dungeon Quest Reborn** | `DungeonQuestReborn_Clean.lua` | `DungeonQuestReborn_BROTHERHUB.lua` | 🏰 Dungeon Quest Reborn | `1549290689639088150` | ✅ AKTIF |
| 22 | **Dig Into Secrets** | `DigIntoSecrets_Clean.lua` | `DigIntoSecrets_BROTHERHUB.lua` | ⛏️ Dig Into Secrets | `1548208960258052236` | ✅ AKTIF |
| 23 | **My Flower Shop** | `FlowerShop_Clean.lua` | `FlowerShop_BROTHERHUB.lua` | 🌸 My Flower Shop | `1548208958102048840` | ✅ AKTIF |
| 24 | **Sell Ores** | `Sellores_Clean.lua` | `Sellores_BROTHERHUB.lua` | 💎 Sell Ores | `1548208962170785852` | ✅ AKTIF |
| 25 | **Fish an Anime** | `FishanAnime_Clean.lua` | `FishanAnime_BROTHERHUB.lua` | 🎣 Fish an Anime | `1548208963819012189` | ✅ AKTIF |
| 26 | **The Mimic** | `TheMimic_Clean.lua` | `TheMimic_BROTHERHUB.lua` | 👹 The Mimic | `1548208966511763506` | ✅ AKTIF |
| 27 | **Steal An Anime Egg** | `StealAnAnimeEgg_Clean.lua` | `StealAnAnimeEgg_BROTHERHUB.lua` | 🥚 Steal An Anime Egg | `1552346205483307223` | ✅ AKTIF |
| 28 | **Mrbeast Island Escape** | `MrbeastIslandEscape_Clean.lua` | `MrbeastIslandEscape_BROTHERHUB.lua` | 🏝️ Mrbeast Island Escape | `1552346208037642371` | ✅ AKTIF |
| 29 | **Steal From The Rich** | `StealFromTheRich_Clean.lua` | `StealFromTheRich_BROTHERHUB.lua` | 💰 Steal From The Rich | `1552346210969587824` | ✅ AKTIF |
| 30 | **Unbox ASMR** | `UnboxASMR_Clean.lua` | `UnboxASMR_BROTHERHUB.lua` | 📦 Unbox ASMR | `1552346213397831732` | ✅ AKTIF |
| 31 | **Mine Antarctica** | `MineAntarctica_Clean.lua` | `MineAntarctica_BROTHERHUB.lua` | ❄️ Mine Antarctica | `1552346215469813895` | ✅ AKTIF |
| 32 | **Clone to Steal Eggs** | `CloneToStealEggs_Clean.lua` | `CloneToStealEggs_BROTHERHUB.lua` | 🥚 Clone to Steal Eggs | `1553381123118211122` | ✅ AKTIF |
| 33 | **Super Treehouse Tycoon 2** | `SuperTreehouseTycoon2_Clean.lua` | `SuperTreehouseTycoon2_BROTHERHUB.lua` | 🌳 Super Treehouse Tycoon 2 | `1553381125244846180` | ✅ AKTIF |
| 34 | **Steal Underwater Eggs** | `StealUnderwaterEggs_Clean.lua` | `StealUnderwaterEggs_BROTHERHUB.lua` | 🌊 Steal Underwater Eggs | `1553381127119573065` | ✅ AKTIF |

### 4.2 Role Notifikasi Master Server
* **⚡ Script Update Ping**: `1548208954163724299`
* **🎮 Brother Member**: `1547960141263929366`
* **📢 Announcement Ping**: `1548208952267903016`
* **🎁 Giveaway Ping**: `1548208956243972228`
* **💻 PC Player**: `1548208968017518622`
* **📱 Mobile Player**: `1548208969384988774`
* **🎰 Casino Player**: `1550710101898166283`

---

# BAGIAN V: HUKUM MUTLAK & STANDARISASI DESAIN BROTHER HUB

### 5.1 Aturan 5: Catbox Dihapus & Dilarang Selamanya (1 Link Master GitHub Raw)
* Seluruh link mirror Catbox telah dihapus permanen.
* Hanya satu link permanen universal yang digunakan member:
  ```lua
  loadstring(game:HttpGet("https://raw.githubusercontent.com/brotherhub-official/BROTHERHUB/main/BrotherHub.lua?t=" .. tostring(os.time())))()
  ```

### 5.2 Aturan 5B: Game Terlarang Permanen (Steal An Egg, Steal A Tree & Steal Underwater Eggs)
* Game `Steal An Egg` (lama) dan `Steal A Tree` telah **DIHAPUS TOTAL DAN DILARANG SELAMANYA**.
* Total game resmi Brother Hub adalah **TEPAT 33 GAME** (Game #27 adalah Steal An Anime Egg, Game #32 adalah Clone to Steal Eggs, Game #33 adalah Super Treehouse Tycoon 2).

### 5.3 Aturan 5C: 100% Obfuscated Builds di GitHub (Anti-Pencurian Kode)
* Folder `CleanHub/`, `Clean/`, dan berkas `*_Clean.lua` **100% LOKAL EXCLUSIVE** di PC pengguna dan terdaftar di `.gitignore`.
* GitHub publik hanya memuat build terenkripsi `*_BROTHERHUB.lua` dan `BrotherHub.lua`.

### 5.4 Aturan 6: Larangan Copy Loadstring & Link GitHub di Game GUI
* Dilarang menempatkan tombol salin loadstring ataupun link repositori GitHub di dalam antarmuka GUI script game demi keamanan dari developer game / kompetitor.
* Tab Credit hanya memuat: Discord Server, Saweria, SociaBuzz, dan identitas Founder (`👑 Founder & Lead Developer: prawiraxliv`).

### 5.5 Aturan 8: Triple-Layer Auto-Patcher XML CharacterMesh (.rbxlx)
* Mengatasi error `Content property conflict on CharacterMesh` di Roblox Studio saat membuka dump saveinstance:
  1. *Layer 1*: Filter opsi decompile `IgnoreProperties` mengabaikan `MeshContent` dan `OverlayTextureContent`.
  2. *Layer 2*: USSI Hook in-memory melewati class `CharacterMesh`.
  3. *Layer 3*: Post-save file regex patcher membersihkan tag XML konflik secara otomatis.

### 5.6 Aturan 10: Standarisasi Baku Arsitektur GUI (100% Wajib 1:1 My Flower Shop Tanpa Kompromi)
* **Hukum Mutlak Founder**: Seluruh script Brother Hub (baik 34 game saat ini maupun game baru di masa depan) **WAJIB 100% MENGADOPSI ARSITEKTUR MY FLOWER SHOP**.
* **Border Stroke**: **WAJIB `neonStroke(inst, thickness)` berotasi 360° secara mulus**. DILARANG KERAS menggunakan warna kuning/emas solid (`stroke(mainFrame, THEME.Title)`) atau gradien 2-warna statis!
* **Header**: Tinggi 52px bergradien ungu-biru (`gradient(Header, THEME.Purple, THEME.Blue, 0)`), `HeaderSquareFix` 14px, judul centered GothamBlack `"👑 BROTHER HUB — <NAMA GAME>"`, tombol minimize kuning `–` (32x32) dan tutup merah `X` (32x32).
* **TabBar**: Horizontal scrolling sumbu X (`ScrollingDirection.X`, `AutomaticCanvasSize.X`), scrollbar gold 3px.
* **Floating MinCircle 80x80**:
  * **Hukum Parenting UIScale**: `MainScale` WAJIB SELALU di-parent ke `mainFrame` (`Instance.new("UIScale", mainFrame)`), **DILARANG KERAS** di-parent ke `screenGui`!
  * Lingkaran 80x80 berlogo Mahkota Emas `👑` dan `BH`, berborder `neonStroke(MinCircle, 2)` (RGB 360°), draggable di PC dan mobile, restore dengan animasi bounce.
* **Modal Dialog Konfirmasi Tutup 'X' (`CloseModal` 360x200)**: Pop-up konfirmasi berborder neonStroke dengan 2 tombol: "Yes" (Hijau) dan "Cancel" (Merah). Tombol "Yes" melakukan **Sterilisasi Total** (disconnect connection, task.cancel, reset walkspeed/jumppower, destroy GUI).
* **Multi-Instance Cleanup Guard**: Guard di baris pertama script (`_G.BH_<GAME>_CLEANUP = function() ... end`).
* **Full-Row Clickable Toggles**: Seluruh baris wadah toggle 100% hitbox dapat diklik untuk ON/OFF, dan revert nilai asli saat OFF.
* **Direct Input Number Slider**: Slider wajib dilengkapi text box angka yang bisa diketik langsung oleh user.
* **Dropdown**: Mendukung Single-Select (`makeDropdown`) dan Multi-Select dengan checkbox (`makeMultiSelectDropdown`).

### 5.7 Aturan 11: Resolusi Pukulan & Mining (No Client Hijacking)
* Dilarang melakukan loop equip konstan yang membajak controller Roblox client (klik mouse/touch tetap normal).
* Seluruh pukulan dialihkan langsung ke remote server game.
* Menggunakan `smoothApproach` dan reset `AssemblyLinearVelocity = Vector3.zero` untuk mencegah karakter jitter / terlempar.

### 5.8 Aturan 12, 12B, 12C, 12D: Standar Komunikasi & Pengumuman Discord
* **Role Ping Wajib**: Ping Role Spesifik Game + `<@&1548208954163724299>` (Script Update Ping) + `<@&1547960141263929366>` (Brother Member).
* **Anti-Unknown-Role (Rule 12B)**: Role ID wajib divalidasi dinamis via `tools/discord_roles_map.json`.
* **Loadstring Tunggal (Rule 12C)**: Teks loadstring hanya boleh ditampilkan di `#⚡・script-panel` (`1547960154228793424`). Dilarang keras menampilkan box kode loadstring di pengumuman `#📢・announcements`.
* **Triple-Quoted F-Strings (Rule 12D)**: Format pesan Discord wajib menggunakan `f"""..."""` tunggal dengan pre-flight assertion untuk mencegah variabel mentah bocor.

---

# BAGIAN VI: PIPELINE KOMPILASI, OBFUSKASI & BUILD SYSTEM

### 6.1 Alur Kerja Produksi Script (Dev-to-Prod Pipeline)
Setiap perubahan pada kode game mengikuti protokol ketat:
1. **Source Code Editing**: Edit kode mentah di `CleanHub/<Game>_Clean.lua`.
2. **Syntax Parse Verification**:
   ```bash
   tools/luau-compile.exe --only-parse CleanHub/<Game>_Clean.lua
   ```
   *Wajib Exit Code 0 tanpa error sintaks Luau!*
3. **Brother Guard Multi-Layer Encryption**:
   ```bash
   python obfuscate.py -i CleanHub/<Game>_Clean.lua -o <Game>_BROTHERHUB.lua
   ```
4. **Mirroring Build ke ObfuscateHub**:
   ```powershell
   Copy-Item <Game>_BROTHERHUB.lua ObfuscateHub/<Game>_BROTHERHUB.lua -Force
   ```
5. **Git Staging & Commit**:
   ```bash
   git add <Game>_BROTHERHUB.lua ObfuscateHub/<Game>_BROTHERHUB.lua BrotherHub.lua
   git commit -m "chore(<game>): update production encrypted build"
   git push origin main
   ```
   *Sebelum push, verifikasi `git status` memastikan `CleanHub/` tidak tersentuh!*

---

# BAGIAN VII: DETAIL ARSITEKTUR & FITUR 3 GAME BARU & UPDATE UNBOX ASMR

### 7.1 Laporan Audit & Recovery Insiden Mati Lampu Kalimantan (Zero Data Loss)
* **Status Audit Sistem**: Seluruh riwayat komit sebelumnya (`f472d56` - sinkronisasi 31 game) telah diaudit secara menyeluruh. Tidak ada kode, dump, modul, atau konfigurasi yang rusak atau hilang selama insiden pemadaman listrik.
* **Master State Synchronization**: Seluruh 34 game resmi tercatat dengan struktur file ganda (`CleanHub/<Game>_Clean.lua` lokal eksklusif & `<Game>_BROTHERHUB.lua` / `ObfuscateHub/<Game>_BROTHERHUB.lua` terenkripsi di GitHub).
* **Discord Roles Integrity**: Seluruh role discord terdaftar di `tools/discord_roles_map.json` dengan ID statis yang terverifikasi via API Discord.

---

### 7.2 Game #32: Clone to Steal Eggs (`76943966208523`)
* **Arsitektur Remote & Knit Services**:
  * Menggunakan framework Knit: `ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services`
  * Layanan Utama:
    * `AreaService.RF.PickupEgg`: Pengambilan telur dari sarang.
    * `EggService.RF.PlaceEgg`: Menempatkan telur yang dicuri ke sarang plot pribadi.
    * `EggService.RF.HatchEgg`: Menetaskan telur di plot menjadi peliharaan/clone.
    * `InventoryService.RF.SellAll`: Menjual seluruh clone/item inventaris untuk koin.
    * `PlotService.RF.TeleportToPlot`: Teleportasi instan langsung ke sarang plot sendiri.
    * `UpgradesService.RF.PromptSpeedTier`: Pembelian peningkatan speed tier clone.
    * `RebirthService.RF.Rebirth`: Melakukan rebirth otomatis saat syarat level/koin tercapai.
    * `PlaytimeRewardService.RF.ClaimGift`: Mengklaim seluruh bundle hadiah waktu bermain.
* **Hierarki Telur & Dynamic PickablePrompt**:
  * Induk sarang: `Workspace.SpawnedBases` -> `base_<AreaName>_<Id>` -> `Hen_<Type>` -> `<EggName>_egg`
  * Koordinat telur tidak statis (berpindah posisi spawn). Script menggunakan scanner dinamis rekursif yang mendeteksi setiap `ProximityPrompt` bernama `PickablePrompt` (`MaxActivationDistance = 32`, `HoldDuration = 0`).
* **Multi-Area Dropdown**:
  * 8 Area Resmi: `Green`, `Desert`, `Winter`, `Jurassic`, `Ocean`, `Volcano`, `Galaxy`, `Spirit Blossom`.
  * Verifikasi spasial: bounding box part `Workspace.Areas[AreaName]` dan nama model telur sesuai konfigurasi `AreasConfig`.
* **Safe Stance Anti-Jitter**: Karakter melayang 4 studs di atas telur dengan velocity dinolkan (`AssemblyLinearVelocity = Vector3.zero`).

---

### 7.3 Game #33: Super Treehouse Tycoon 2 (`8034718511`)
* **Arsitektur Tycoon & Honey Harvester**:
  * Deteksi Plot Tycoon: `Workspace.Treehouses` -> `th.Owner.Value == LocalPlayer`
  * Honey Collector Pad: `th.Essentials.Giver.Button.Head`
    * Script memicu `firetouchinterest` secara berkala ke part kepala tombol giver madu untuk menarik 100% simpanan madu sarang lebah tanpa bergerak manual.
  * Smart Tycoon Buttons:
    * Folder tombol: `th.Buttons:GetChildren()`
    * Setiap tombol memiliki atribut/child: `Price` (Int/NumberValue) dan `Head` (BasePart).
    * Algoritma "Cheapest First": Script mengurutkan seluruh tombol berdasarkan harga terendah ke tertinggi, mencocokkan dengan saldo `leaderstats["🍯Honey"]`, lalu memicu `firetouchinterest` pada tombol yang terjangkau secara berurutan.
* **Bee Hunting & Capture Automation**:
  * Folder lebah map: `Workspace.NPC_BEES`
  * Atribut lebah: `IsBeingCaptured` (boolean)
  * Script otomatis terbang dan menempel pada lebah liar yang belum ditangkap hingga timer capture selesai.
* **Egg Hatch & Codes**:
  * Remote: `ReplicatedStorage.Remotes.BuyEgg`
  * Kode promosi: `ReplicatedStorage.Remotes.ActivateCode`

---

### 7.4 Game #34: Steal Underwater Eggs (`96364555828035`)
* **Arsitektur Jerman (German Engine Core)**:
  * 8 Biome Resmi (`BiomWerte.BIOME`):
    1. `Coral Reef` (Stage 1)
    2. `Kelp Forest` (Stage 2)
    3. `Claw Canyon` (Stage 3)
    4. `Ship Graveyard` (Stage 4)
    5. `Lava Fortress` (Stage 5)
    6. `Jungle Temple` (Stage 6)
    7. `Frost Abyss` (Stage 7)
    8. `Atlantis` (Stage 8)
* **Hierarki Sarang Telur Bawah Laut**:
  * Folder sarang: `Workspace.NestPlaetze.Stage1` hingga `Stage8`
  * Telur: Model dengan `Root` part dan child `ProximityPrompt` bernama `EiAufheben`.
  * Bypass Hold Time: Durasi default `1.2s` diubah menjadi `0s` untuk pencurian instan tanpa jeda.
* **Aquarium & Pet Management**:
  * Folder akuarium: `Workspace.Aquarien` (mencocokkan `Owner.Value == LocalPlayer`)
  * Sarang tetas: Tombol `Brutknopf` dan prompt `EiAusbrueten`
  * Remote Server:
    * `AquariumPlatzieren`: Menaruh telur curian ke sarang akuarium.
    * `AquariumEiKnacken`: Memecahkan cangkang telur setelah durasi inkubasi selesai.
    * `AquariumOeffnen`: Mengambil isi peliharaan akuarium.
    * `PetVerkaufen`: Menjual pet yang tidak diinginkan untuk koin laut.
    * `TankUpgradeEvent`: Meningkatkan kapasitas tampung tangki akuarium.
    * `FlossenAktion` / `SetSpeed`: Mengaktifkan dorongan kecepatan renang sirip.

---

### 7.5 Pembaruan Unbox ASMR: Dual-Filter Mode & Perbaikan Font Glyph
* **Dual-Filter Mode (Whitelist vs Blacklist)**:
  * **Mode Whitelist (Target)**: Hanya membeli/menargetkan peti/rarity yang dicentang.
  * **Mode Blacklist (Lewati yang Dicentang)**:
    * Contoh: Pemain mencentang *Epic* dan *Mythic*.
    * Hasil: Seluruh peti *Common, Uncommon, Rare, Legendary, Divine, Secret, Exotic, Ancient, Cosmic, Celestial* akan otomatis menjadi target pembelian.
    * Peti *Epic* dan *Mythic* otomatis dilewati (*skipped*) di konveyor.
* **Perbaikan Font Glyph Tombol Reset**:
  * **Akar Masalah**: Teks tombol menggunakan karakter unicode `✕` (`\u2715`) yang tidak memiliki representasi glyph pada font `GothamBold` Roblox di banyak platform (terutama mobile/Android), sehingga dirender sebagai kotak tak dikenal `□`.
  * **Solusi**: Mengganti teks menjadi `X Reset` berbasis karakter ASCII standar yang 100% kompatibel dan bersih di seluruh executor dan resolusi layar.

---

### 7.6 Deteksi Logo Rebirth & Target Otomatis Peti Misi Rebirth
* **Deteksi RebirthRequirementBadge (Logo Rebirth)**:
  * Pada conveyor, peti yang menjadi syarat Rebirth aktif pemain dipasangi badge dinamis oleh client game: `RebirthRequirementBadge` (Asset `rbxassetid://84343300633559`).
  * Script Brother Hub mendeteksi badge tersebut secara visual di `BillboardGui` dan secara data melalui pencocokan template `part:GetAttribute("CrateTemplateName")` terhadap tabel `RebirthConfig.Requirements`.
* **Kategori & Opsi Dropdown Rebirth**:
  * Ditambahkan opsi Rarity: `"🔄 Misi Rebirth (Logo Rebirth)"`.
  * Ditambahkan opsi teratas dinamis: `"🔄 [Misi Aktif] Crate Misi Rebirth Saat Ini (Logo Rebirth)"`.
  * Seluruh 16 peti syarat Rebirth (Rebirth 1 - 16) ditandai dengan label `[🔄 Rebirth #X]` dari *Slime Crate* (Rare) hingga *Net Squishy Crate* (Celestial).
* **Toggle Otomatis**:
  * `"🔄 Auto Target Crate Misi Rebirth (Logo Rebirth)"`: Memprioritaskan pembelian seketika pada peti manapun yang memiliki logo Rebirth saat melintas di conveyor pemain.

### 7.7 Super Treehouse Tycoon 2: Arsitektur 1:1 My Flower Shop & Overhaul Auto Capture Bees
* **Metadata Game & Place ID**:
  * **Game**: Super Treehouse Tycoon 2
  * **Place ID**: `8034718511`
  * **Role Discord**: `🌳 Super Treehouse Tycoon 2` (`1553381125244846180`)
* **Standardisasi Baku GUI (1:1 My Flower Shop)**:
  * Frame Utama 660 x 440 dengan sudut 14px dan border **`neonStroke(inst, thickness)` 360° Rotating RGB Neon** (Biru Tua `#0028FF` -> Merah `#FF192D` -> Hijau `#14FF50` -> Biru Tua `#0028FF`). Dilarang keras menggunakan stroke kuning/emas statis!
  * Header 52px dengan gradien ungu-ke-biru (`gradient(Header, THEME.Purple, THEME.Blue, 0)`), `HeaderSquareFix` 14px, judul centered `Enum.Font.GothamBlack`, tombol minimize kuning `–` dan tombol tutup merah `X`.
  * Horizontal Scrolling TabBar (X-axis, scrollbar emas 3px) dengan tab button aktif emas (`THEME.Title`) dan inaktif slot (`THEME.Slot`).
  * Floating MinCircle 80x80 dengan `neonStroke(MinCircle, 2)`, mahkota emas `👑` dan label `BH`, draggable bebas ke mana saja, dan restore frame utama dengan animasi bounce.
  * Modal Konfirmasi Tutup (`CloseModal`) 360x200 dengan `neonStroke` dan tombol Yes / Cancel.
* **Overhaul Total Auto Capture Bees (Fix Bug Laporan Member Lugft)**:
  * **Akar Masalah Sebelumnya**:
    1. Loop lama mencari `bee:IsA("BasePart") and bee.Name:lower():find("bee")`. Padahal seluruh lebah di `Workspace.NPC_BEES` adalah **Model** (misal: `Orange Striped Bee`, `Purple Striped Bee`, `Navy Blue Striped Bee`), dan parts di dalamnya bernama `PrimaryBody`, `SecondaryBody`, `LeftWing`, dsb., sehingga tidak ada part yang pernah tersentuh!
    2. Player tidak melakukan equip tool `Capture_Net` secara otomatis, dan tidak melakukan teleport ke dekat lebah sehingga physics touch Roblox menolak interaksi jarak jauh.
  * **Solusi & Mekanisme Baru (100% Fixed)**:
    1. **Auto Equip Net**: Fungsi `ensureNetEquipped()` otomatis mendeteksi dan meng-equip tool `Capture_Net` atau `Super Capture Net` dari Backpack ke Character.
    2. **Multi-Part Touch & Tool Swing**: Saat berada di posisi lebah, script memicu `tool:Activate()`, serta melakukan `firetouchinterest` antara net mesh part (`Net` / `Handle`) dan seluruh bagian tubuh lebah (`PrimaryBody`, `SecondaryBody`, `HumanoidRootPart`) serta HRP pemain.
    3. **Safe Stance Anti-Jitter**: Karakter melayang presisi di samping lebah (`CFrame.new(pos + Vector3.new(0, 0.5, 2.5), pos)`) dengan linear & angular velocity di-reset ke nol untuk mencegah mental atau jatuh.
    4. **Endless Sweep Loop & Return to Base**: Script memindai seluruh lebah hidup di `Workspace.NPC_BEES` (melewati yang `IsBeingCaptured.Value == true`), menyapu satu per satu secara berurutan, dan otomatis kembali ke base Tycoon setelah map bersih menunggu respawn lebah baru.
    5. **ESP Bees**: Visual BillboardGui berwarna kuning neon menandai posisi seluruh lebah aktif di map secara real-time.

---

### 7.8 Perbaikan Rendering Tab Unbox ASMR (Tab Blank / Missing Fix)
* **Akar Masalah**: Panggilan fungsi `addToggle` yang tidak terdefinisi (seharusnya `makeToggle`) pada tombol filter blacklist dan auto target rebirth crate di Tab 1 menyebabkan eksekusi script terhenti di tengah jalan (*attempt to call a nil value*), sehingga seluruh tab berikutnya tampak kosong/hitam.
* **Solusi**: Memperbaiki pemanggilan menjadi `makeToggle` standar dengan parameter yang sesuai. Seluruh 8 tab Unbox ASMR kini dirender 100% sempurna tanpa error.

---

*Dokumen ini diperbarui secara otomatis dan merupakan panduan teknis resmi Brother Hub Ecosystem.*



## 7.9 Steal Underwater Eggs: Overhaul Auto Steal, Fast Renang Booster & 1:1 My Flower Shop UI
* **Place ID**: `96364555828035`
* **Latar Belakang & Masukan Member ! BOS**:
  - Member `! BOS` melaporkan: *"Bg butuh dibenerin di autosteal nya, soalnya pas di nyalain autosteal nya gabisa ambill eggs nya. Sama esp fast renang nya ga berfungsi"*.
* **Akar Masalah Teknis Hasil Dump Analisis**:
  1. *Faux Egg Holding Detection*:
     - Kode lama memeriksa `item.Name:lower():find("ei") or item.Name:lower():find("egg")` pada seluruh anak Character.
     - Di engine Roblox dengan karakter terlokalisasi/bahasa Jerman, nama kaki adalah `"LinkesBein"` dan `"RechtesBein"`, keduanya mengandung substring `"ei"`. Akibatnya, `isHoldingEgg()` **selalu bernilai true secara permanen** sejak detik pertama!
     - Efeknya, script selalu mengira pemain sedang membawa telur dan terus-menerus menteleportasikan pemain ke Aquarium markas, sehingga pemain tidak pernah menteleport ke sarang telur untuk mencuri!
     - *Solusi*: Berdasarkan kode decompile resmi `EiHandClient.lua`, model resmi yang dimunculkan game saat membawa telur adalah `char:FindFirstChild("GetragenesEi")` dan Tool dengan atribut `EiVorlage`. Pemeriksaan diperbaiki 100% presisi.
  2. *Fast Renang Booster Mati*:
     - Kode lama menembakkan remote `SetSpeed:FireServer(75)` yang ternyata tidak digunakan oleh client script manapun.
     - Dari analisis decompile `SchwimmScript.lua`, script fisika renang resmi memeriksa atribut bawaan `LocalPlayer:GetAttribute("AdminTempo")`.
     - *Solusi*: Fast Renang diintegrasikan langsung dengan menyetel `LocalPlayer:SetAttribute("AdminTempo", config.swimSpeed or 80)` dan `Humanoid.WalkSpeed`, sehingga karakter melesat cepat dengan fisika renang resmi tanpa tersendat.
  3. *ESP Telur Tidak Muncul*:
     - Kode lama hanya memindai telur pada biome yang dicentang di filter Auto Steal. Jika pemain berada di zona lain yang tidak dicentang, ESP tidak memunculkan telur sama sekali.
     - *Solusi*: ESP diubah memindai seluruh sarang telur secara global di seluruh map dan menampilkan penanda BillboardGui dengan nama telur serta jarak meter waktu-nyata.
  4. *Standarisasi 1:1 My Flower Shop UI*:
     - Menerapkan `neonStroke(inst, 2)` berotasi 360° RGB Neon pada `MainFrame`, `MinCircle` (80x80), dan `CloseModal` (360x200).
     - Header ungu-biru 52px dengan `HeaderSquareFix`, centered title font GothamBlack, tombol minimize kuning `–` dan tutup merah `X`.
     - Horizontal Scrolling TabBar melintang sumbu X dengan scrollbar emas 3px.

## 7.10 Steal Underwater Eggs: Solusi Tuntas Card Collapsing / Blank Features & Penambahan Fitur Eksploit Lengkap
* **Place ID**: `96364555828035`
* **Latar Belakang Laporan Lanjutan Member ! BOS**:
  - Member `! BOS` melaporkan: *"Malah gaada fitur fitur nya bg"*.
* **Akar Masalah Teknis Hasil Audit UI**:
  - Pada implementasi awal `makeCard`, elemen kartu konten menggunakan `AutomaticSize = Enum.AutomaticSize.Y` dan di dalamnya dipasang `cLayout = Instance.new("UIListLayout", card)`.
  - Di dalam `card`, elemen vertikal neon `bar` memiliki ukuran `UDim2.new(0, 4, 1, -10)` (Scale Y = 1).
  - Di engine Roblox, sebuah elemen dengan nilai Scale > 0 pada sumbu `AutomaticSize` yang berada di dalam `UIListLayout` memicu *cyclic dependency / recursive size solver failure*.
  - Akibatnya, engine layout Roblox otomatis menggugurkan perhitungan tinggi kartu menjadi 0 pixel (`AbsoluteSize.Y = 0`). Seluruh card di seluruh tab menjadi ciut (tersembunyi/tidak tampak), sehingga pemain hanya melihat frame kosong tanpa tombol/toggle satupun!
* **Solusi Baku 1:1 My Flower Shop Holder Pattern**:
  - Mengadopsi arsitektur resmi `FlowerShop_Clean.lua`: `makeCard(titleText, accent, parentOverride)` membuat Frame kartu luar dan sebuah wadah anak bernama `holder` (`Size = UDim2.new(1, -28, 0, 0)`, `AutomaticSize = Enum.AutomaticSize.Y`).
  - `UIListLayout` dan `UIPadding` hanya dipasang di dalam `holder`.
  - `bar` dipasang di kartu luar independen dari list layout.
  - `makeCard` mengembalikan objek `holder`. Seluruh kontrol (`makeToggle`, `makeSlider`, `makeButton`) otomatis terpasang di dalam `holder` tanpa konflik perhitungan ukuran. Seluruh kartu dan fitur kini tampil 100% sempurna!
* **Penambahan Fitur Eksploit Baru Berdasarkan Decompile ReplicatedStorage & StarterGui**:
  1. *Trident Combat & Boss Farm*: Menembakkan remote resmi `DreizackSchlag:FireServer()` untuk spam serangan cepat melee dan auto farm Underwater Boss.
  2. *Auto Equip Best Pets*: Memanggil remote fungsi resmi `PetAktion:InvokeServer("best")` untuk memakai pet dengan multiplier tertinggi secara instan.
  3. *Unequip All Pets*: `PetAktion:InvokeServer("alleab")` untuk melepas seluruh pet dengan 1 klik.
  4. *Auto Tank Capacity Upgrade*: Menembakkan `TankUpgradeEvent:FireServer(1, "geld")` otomatis menggunakan koin in-game.
  5. *Auto Buy Fins (Flossen)*: Memanggil `FlossenAktion:InvokeServer("Kaufen")` untuk auto beli sirip renang tier berikutnya.
  6. *Auto Redeem Codes*: Memanggil `CodeEinloesen:InvokeServer(code)` untuk klaim promo code game otomatis.
  7. *1-Click Biome & Base Teleports*: Teleport instan ke 8 Biome (*Coral Reef, Kelp Forest, Claw Canyon, Ship Graveyard, Lava Fortress, Jungle Temple, Frost Abyss, Atlantis*) dan Markas Aquarium.

---

## 7.11 Save Instance Suite Overhaul: Auto-Split .RBXMX Suite Folder Engine (.rbxl Binary & .rbxlx XML)
* **File Target**: `CleanHub/BrotherHub.txt` & `CleanHub/BrotherHub_original.lua` (Tab `💾 Save Instance`)
* **Latar Belakang & Permintaan Founder**:
  Founder menginginkan fitur Save Instance mutakhir yang secara otomatis mengekspor seluruh service dan kontainer game menjadi berkas model `.rbxmx` terpisah di dalam sebuah folder khusus bernama game dan PlaceId (`<Nama Game> [<PlaceId>]/`). File master game tetap ada di dalam folder tersebut, dan setiap berkas `.rbxmx` memiliki penamaan terpadu: `<Container> <Nama Game>.rbxmx`. Opsi lama di Card 6 (`💾 SAVE FULL` dan `🗺 WORKSPACE`) tetap 100% utuh tanpa diubah.
* **Rincian Komponen 12 Berkas .rbxmx Yang Diekspor**:
  1. `Workspace <Nama Game>.rbxmx`
  2. `NilInstances <Nama Game>.rbxmx` (menangkap executor `getnilinstances()`)
  3. `Players <Nama Game>.rbxmx`
  4. `Backpack <Nama Game>.rbxmx` (menangkap Backpack LocalPlayer & alat pemain)
  5. `Lighting <Nama Game>.rbxmx`
  6. `ReplicatedFirst <Nama Game>.rbxmx`
  7. `ReplicatedStorage <Nama Game>.rbxmx`
  8. `StarterGui <Nama Game>.rbxmx`
  9. `StarterPack <Nama Game>.rbxmx`
  10. `StarterPlayer <Nama Game>.rbxmx`
  11. `StarterCharacterScripts <Nama Game>.rbxmx`
  12. `StarterPlayerScripts <Nama Game>.rbxmx`
  * Serta 1 berkas Master Full Place di dalam folder yang sama: `<Nama Game>.rbxl` (untuk Card 7) ATAU `<Nama Game>.rbxlx` (untuk Card 8).
* **Arsitektur Dual Suite Cards di Tab Save Instance**:
  1. **Card 7: 📦 AUTO-SPLIT .RBXMX SUITE (.RBXL BINARY)** (Warna Aksen: `THEME.Cyan`):
     - Menghasilkan 12 berkas `.rbxmx` + 1 berkas master `.rbxl` (Binary, format sangat cepat dan hemat ukuran memori).
     - Tombol eksekusi: `[ 📦 AUTO DUMP ALL (.rbxl + 12x .rbxmx Folder) ]`
  2. **Card 8: 📜 AUTO-SPLIT .RBXMX SUITE (.RBXLX XML) (BARU)** (Warna Aksen: `THEME.Orange`):
     - Menghasilkan 12 berkas `.rbxmx` + 1 berkas master `.rbxlx` (XML, format teks transparan yang mudah dibaca/ditelusuri).
     - Tombol eksekusi: `[ 📜 AUTO DUMP ALL (.rbxlx + 12x .rbxmx Folder) ]`
     - Dilengkapi **Triple-Layer CharacterMesh Auto-Patcher** (Rule 8) yang otomatis membersihkan tag konflik `MeshContent` & `OverlayTextureContent` saat proses saving selesai, menjamin berkas `.rbxlx` 100% bebas dari error assertion saat dibuka di Roblox Studio.
* **Resolusi Bug Teknis & Mojibake Encoding**:
  1. *Fix Error BackgroundColor3 (Nil Assignment)*:
     - Tombol `suiteBtn` sebelumnya merujuk ke `THEME.Accent` yang belum ada di tabel tema sehingga bernilai `nil`.
     - *Solusi*: Menambahkan `Accent = Color3.fromRGB(50, 220, 255)` ke tabel `THEME` dan menyetel warna tombol secara eksplisit ke `THEME.Cyan` dan `THEME.Orange`.
  2. *Pembersihan Mojibake Emoji Windows (âœ¨ dan âš”ï¸ )*:
     - *Penyebab*: Nama game di Roblox sering memuat emoji multi-byte UTF-8 (seperti `[✨ENCHANTS] Poly Loot⚔️`). Saat diproses di Windows, API executor (`makefolder` / `saveinstance`) menggunakan ANSI (CP-1252), sehingga byte UTF-8 `✨` (`0xE2 0x9C 0xA8`) terbaca sebagai `âœ¨`, dan `⚔️` terbaca sebagai `âš”ï¸ `.
     - *Solusi Permanen*: Fungsi `sanitizeName()` ditingkatkan dengan filter byte ASCII (`string.byte(str, i) >= 32 and string.byte(str, i) <= 126`), secara otomatis membersihkan seluruh emoji dan karakter non-ASCII sebelum nama folder dan file dibuat. Nama folder dan file dihasilkan 100% rapi dan steril: `[ENCHANTS] Poly Loot [124032631078772]`.



## 7.12 Poly Loot: Resolusi Tuntas Blank UI Mobile, Standardisasi Penuh Arsitektur 1:1 My Flower Shop & Integrasi Pembaruan Game [ENCHANTS]
* **File Target**: CleanHub/PolyLoot_Clean.lua, PolyLoot_BROTHERHUB.lua, ObfuscateHub/PolyLoot_BROTHERHUB.lua
* **Identitas Game**:
  - Nama Resmi: **Poly Loot** (PlaceId: 124032631078772)
  - Status: ✅ AKTIF
  - Role Discord Resmi: ⚔️ Poly Loot (Role ID: 1549290685645983764)
* **Latar Belakang Permintaan & Masalah**:
  - Member Discord Prone melaporkan bug antarmuka di mana GUI script Poly Loot terbuka dengan header tetapi area badan (tab dan controls) di bawahnya blank hitam kosong pada perangkat mobile (Delta Executor).
  - Founder menginstruksikan pemeriksaan dump save instances terbaru berlabel [ENCHANTS] Poly Loot (12 berkas .rbxmx hasil Card 8 XML suite).
* **Investigasi Mendalam Akar Masalah (Root Cause)**:
  1. *AutomaticSize Layout Collapse pada Mobile*:
     - Skrip lama mengonfigurasi tombol tab dengan Size = UDim2.new(0, 0, 0, 28) dan AutomaticSize = Enum.AutomaticSize.X di dalam ScrollingFrame ber-AutomaticCanvasSize = Enum.AutomaticSize.X.
     - Pada mobile executors (Delta, Codex, Vega X), engine kalkulasi font text bounds sering menghasilkan nilai 0 atau tertunda saat frame dimunculkan, sehingga seluruh tombol tab menyusut ke lebar 0 (hilang dari pandangan).
  2. *Absennya Card Holder Pattern (Rule 10)*:
     - Elemen toggle, slider, dan section ditempelkan langsung pada ScrollingFrame tanpa pembungkus kartu ber-AutomaticSize = Y. Hierarki UIListLayout mengalami kegagalan perhitungan tinggi kanvas sehingga seluruh isi halaman tidak dapat di-render.
  3. *Main-Thread Require Halt*:
     - Logika inisialisasi tombol tab diletakkan di bagian paling akhir skrip (baris 1000+) setelah pemanggilan modul eksternal seperti CutsceneManager dan BowClient. Saat game di-update developer dan struktur internal berubah, require yang gagal menghentikan main thread sebelum tab sempat dibangun.
* **Rincian Implementasi Standardisasi 1:1 My Flower Shop (Rule 10)**:
  1. **Top Header Bar 52px**:
     - Gradien ungu-ke-biru mulus (THEME.Purple ke THEME.Blue) dengan HeaderSquareFix (14px) di bagian dasar header agar menyatu rapi dengan badan frame.
     - Judul di tengah (Centered Alignment), font Enum.Font.GothamBlack, ukuran 17: "👑 BROTHER HUB — Poly Loot".
     - Tombol Minimize ('–'): Ukuran 32x32, latar Kuning Terang (THEME.Yellow), teks hitam pekat, font GothamBlack.
     - Tombol Tutup ('X'): Ukuran 32x32, latar Merah Tegas (THEME.Off), teks putih, font GothamBlack.
  2. **Floating MinCircle 80x80**:
     - Tombol lingkaran floating 80x80 berlogo Mahkota Emas 👑 dan teks bold BH, border **360° Rotating Neon Stroke RGB** (
eonStroke(minCircle, 2)).
     - Dapat digeser/di-drag bebas ke mana saja di layar (mouse & touch) dan diklik untuk me-restore frame utama dengan animasi bounce.
  3. **Hukum Parenting UIScale**:
     - mainScale wajib di-parent ke mainFrame (Instance.new("UIScale", mainFrame)), BUKAN ke screenGui! Ini menjamin tombol MinCircle tetap tampil 100% saat frame utama di-minimize (Scale = 0).
  4. **Close Modal 360x200**:
     - Dialog konfirmasi penutupan modern 360x200 dengan border neon RGB dan 2 tombol: "Yes" (Hijau) dan "Cancel" (Merah).
     - Menekan "Yes" menjalankan sterilisasi total: memutus seluruh connection (Disconnect()), membatalkan thread task (	ask.cancel), menghapus highlight ESP, mereset physics karakter, dan menghancurkan GUI (Destroy()).
  5. **Horizontal Scrolling TabBar Anti-Collapse**:
     - Navigasi tab geser sumbu-X (ScrollingDirection = X, AutomaticCanvasSize = X) dengan scrollbar Gold 3px.
     - Setiap tombol tab memiliki dimensi tetap (UDim2.new(0, 115, 1, -4)), aktif berwarna Gold (THEME.Title) teks hitam, nonaktif berwarna Slot (THEME.Slot) teks putih/abu-abu.
  6. **Card Holder Pattern**:
     - Seluruh tab page dibangun menggunakan fungsi baku makeCard(titleText, accent) yang mengembalikan wadah holder Frame (Size = UDim2.new(1, -28, 0, 0), AutomaticSize = Enum.AutomaticSize.Y) dengan padding 8px dan UIListLayout berurut, menjamin kanvas tidak pernah runtuh ke tinggi 0.
  7. **Full-Row Clickable Toggles & Direct Input Number Slider**:
     - Seluruh baris toggle (100% area klik) dapat ditekan untuk ON/OFF.
     - Slider dilengkapi bar visual dan kotak input angka langsung yang dapat diketik secara presisi oleh user.
* **Integrasi Pembaruan Game [ENCHANTS]**:
  - Ditemukan penambahan modul baru Enchant_Engine di ReplicatedStorage hasil inspeksi berkas dump ReplicatedStorage [ENCHANTS] Poly Loot.rbxmx.
  - **Tab Baru ✨ Enchants**:
    - Card Otomasi Stasiun Enchantment.
    - Tombol pemicu otomatis ProximityPrompt stasiun enchant di area desa jungle.
    - Tombol Quick Enchant yang mengirim sinyal remote Enchant_Engine.Remotes.EnchantRequest untuk memperkuat senjata yang sedang dipegang.
  - Optimalisasi fitur lainnya:
    - *⚔️ Combat*: M1 Rapid Kill Aura dengan combo looping 1-4 dan Safe Stance (Above, Behind, Orbit) anti-jitter.
    - *🏹 Bow & Skills*: Rapid Bow Auto-Fire machine gun tanpa jeda.
    - *👑 Bosses*: Warden Alder Annihilator (melayang 16 studs di atas bos), Auto Skip Cutscenes kamera bos, dan teleport arena.
    - *📦 Loot & Farm*: Instant Loot Sweeper (vacuum drop ke tas pemain) dan Auto Chop Trees & Mine Ores.
    - *👁️ Visuals*: ESP Monster/Hewan, ESP Bos Warden Alder, dan ESP Dropped Items/Loot.
    - *🏃 Movement*: WalkSpeed Boost, JumpPower Boost, Penetration Noclip, Infinite Jump, Fullbright (Night Vision), dan 24/7 Anti-AFK.
    - *🌐 Teleport*: Hub teleportasi Jungle Spawn, Arena Warden Alder, Merchant & Shop, dan Deep Forest.
    - *⚙️ Settings*: Profil Founder, Salin Discord Link, Tombol Donasi Saweria & SociaBuzz, Rejoin Server, Server Hop, dan Unload.
* **Verifikasi, Kompilasi & Obfuskasi (Rule 5C)**:
  1. *Luau Parse Validation*:
     	ools/luau-compile.exe --only-parse CleanHub/PolyLoot_Clean.lua 👉 **Exit Code 0 (Passed)**.
  2. *Brother Guard Multi-Layer Encryption*:
     python obfuscate.py -i CleanHub/PolyLoot_Clean.lua -o PolyLoot_BROTHERHUB.lua 👉 **Sukses & Validated**.
  3. *Mirroring*:
     Copy-Item PolyLoot_BROTHERHUB.lua ObfuscateHub/PolyLoot_BROTHERHUB.lua -Force.
  4. *Git Commit & Push*:
     Commit cef5f0f (ix(poly-loot): resolve blank UI with 1:1 Flower Shop architecture, holder pattern & add Enchants update support) berhasil di-push ke GitHub origin/main. Repositori publik 100% steril dari kode mentah CleanHub/.
* **Pengumuman Resmi Discord (Rule 12, 12B, 12C)**:
  - Menggunakan modul pengirim resmi tools/discord_announcer.py dengan live API query verifikasi role:
    - Game Role Ping: <@&1549290685645983764> (⚔️ Poly Loot)
    - Update Ping: <@&1548208954163724299> (⚡ Script Update Ping)
    - Member Ping: <@&1547960141263929366> (🎮 Brother Member)
  - Pesan Pengumuman terkirim ke #📢・announcements (Message ID: 1554046914196934669).
  - Pesan Changelog terkirim ke #📜・changelogs (Message ID: 1554046917845975051).
  - 100% steril dari box kode loadstring dan Catbox, mengarahkan member langsung ke #⚡・script-panel (1547960154228793424).

---

### 7.6 Resolusi Presisi Tempur Poly Loot: Filter NPC Ramah, Auto-Equip Swing & Safe Stance Behind (Rule 11)
* **Akar Masalah yang Dilaporkan Pengguna**:
  1. *Salah Target NPC Ramah*: Karakter melayang / berdiri di belakang NPC desa non-monster (seperti Hero Nay, quest givers, atau merchant) alih-alih monster liar yang sesungguhnya.
  2. *Tidak Ada Animasi Swing & Damage Tidak Masuk*: Karakter tidak memegang senjata atau tangan kosong, tidak ada ayunan tebasan senjata (swing animation/trail), serta damage melee tidak terdaftar di server karena jarak melayang terlalu jauh.
* **Solusi & Rekayasa Teknis Mandiri**:
  1. **Deklarasi Koleksi Layanan (CollectionService)**:
     - Menambahkan deklarasi eksplisit `local CollectionService = game:GetService("CollectionService")` di baris atas skrip guna mencegah kegagalan runtime saat melakukan query tag.
  2. **Filter 7-Lapisan 100% Anti-Target NPC Ramah (`isValidCombatTarget`)**:
     - *Layer 1 (CollectionService Exclusion)*: Mengabaikan instans bertag `QuestGiver`, `DisplayNPC`, `StagedNPC`, `Companion`, `Merchant`, `Shop`, `Villager`, dan `NPC`.
     - *Layer 2 (Child Data Heuristics)*: Mengabaikan model yang memiliki folder/objek `Dialogue`, `QuestData`, `Givers`, `OfferScenes`, `Billboard`, atau `ProximityPrompt` interaktif (bicara/toko).
     - *Layer 3 (Peaceful Name Exclusion)*: Mengabaikan nama model yang mengandung kata ramah: `npc`, `villag`, `citizen`, `guard`, `merchant`, `trainer`, `vendor`, `hero`, `quest`, `elder`, `innkeeper`, `blacksmith`.
     - *Layer 4 (Life Check)*: Mengabaikan entitas dengan atribut `_Dying == true`, `Health <= 0`, atau `Humanoid.Health <= 0`.
     - *Layer 5 (Root Part Verifier)*: Wajib memiliki `HumanoidRootPart`, `PrimaryPart`, atau `BasePart`.
     - *Layer 6 (Hostile Tag Matcher)*: Memverifikasi tag resmi `Mob`, `Combatant`, `Knight`, `Boss` atau atribut `MobType` / `IsMob`.
     - *Layer 7 (Hostile Name Keyword Matcher)*: Mencocokkan nama monster liar: `wolf`, `bear`, `boar`, `spider`, `cobra`, `knight`, `warden`, `alder`, `skeleton`, `zombie`, `bandit`, `goblin`, `slime`, `animal`, `mob`.
  3. **Auto-Equip Senjata & Animasi Swing (`tool:Activate()`)**:
     - Menambahkan fungsi pembantu `ensureEquippedWeapon()`: Memeriksa apakah karakter sudah memegang Tool. Jika tangan kosong, otomatis mencari senjata di Backpack dan mengequipnya via `Humanoid:EquipTool()`.
     - Memanggil `tool:Activate()` di setiap siklus serangan untuk memicu animasi tebasan klien, efek suara tebasan, dan weapon trail.
  4. **Safe Stance Mode Default: BEHIND (Di Belakang Punggung Musuh)**:
     - Sesuai instruksi Founder, konfigurasi bawaan `Flags.SafeStanceMode` diatur ke `"Behind"`.
     - Posisi dihitung dari LookVector target: `safePos = tgtPos - (look * dist) + Vector3.new(0, 0.6, 0)`.
     - Karakter diposisikan tepat menghadap punggung musuh (`CFrame.new(safePos, tgtPos)`).
     - Jarak diatur presisi di radius melee (3–5 studs) dengan linear/angular velocity dinolkan (`Vector3.zero`) sesuai **Rule 11** agar pukulan senjata masuk 100% konsisten ke server.
     - Perhitungan `aimDir` serangan diselaraskan menggunakan `(tgt.Part.Position - hrp.Position).Unit`.
     - Pada boss hunt Warden Alder, karakter otomatis melayang di belakang punggung bos saat mode Behind aktif.
* **Build & Deployment Publik (Rule 5C)**:
  - Validasi sintaks Luau: `tools/luau-compile.exe --only-parse CleanHub/PolyLoot_Clean.lua` 👉 **Exit Code 0**.
  - Obfuskasi: `python obfuscate.py -i CleanHub/PolyLoot_Clean.lua -o PolyLoot_BROTHERHUB.lua` 👉 **Passed**.
  - Mirroring: `Copy-Item PolyLoot_BROTHERHUB.lua ObfuscateHub/PolyLoot_BROTHERHUB.lua -Force`.
  - Git Commit & Push: Commit `ed7e23e` berhasil di-push ke branch `main`.
* **Pengumuman Resmi Discord (Rule 12, 12B, 12C)**:
  - Role Mentions Terverifikasi: `<@&1549290685645983764>` (`⚔️ Poly Loot`), `<@&1548208954163724299>` (`⚡ Script Update Ping`), `<@&1547960141263929366>` (`🎮 Brother Member`).
  - Channel Pengumuman (`#📢・announcements`): Pesan ID `1554052672913408064`.
  - Channel Changelog (`#📜・changelogs`): Pesan ID `1554052675488714766`.
  - 100% steril dari loadstring mentah dan Catbox, mengarahkan pemain ke `#⚡・script-panel` (`1547960154228793424`).

---

### 7.7 Pembaruan Mob Target Selector & Auto Farm Mobs Engine Poly Loot (Tanggapan Feedback Prone)
* **Latar Belakang & Masukan Member**:
  Member Discord `Prone` memberikan masukan penting: *"att nya gabisa select mobs nya ya cuman kill aura aja"*. Di mana pemain membutuhkan opsi untuk memilih tipe mob spesifik yang ingin diserang, memfilter jenis mob tertentu, serta automasi Auto Farm yang mengejar dan memburu mob terpilih secara otomatis di belakang punggungnya.
* **Pembedahan Dump Hewan & Monster Poly Loot**:
  - Ditemukan konfigurasi mob di `ReplicatedStorage.Animal_Engine.Config` / `AnimalNames()` yang mencakup lebih dari 60 jenis mob/monster: `Wolf`, `Bear`, `Polar Bear`, `Boar`, `Spider`, `Cobra`, `TripleCobra`, `Skeleton`, `Gargoyle`, `Knight`, `Gorilla`, `Bat`, `Crocodile`, `Shark`, `Lion`, `Tiger`, `Triceratops`, `Ankylosaurus`, `Velicoraptor`, `Spinosaurus`, `King Chicken`, `Redstone Rex`, `Warden Alder`, dan varian lainnya.
  - Skrip dilengkapi `DEFAULT_MOBS` cadangan dan modul runtime scanner yang memindai mob hidup secara berkala di workspace.
* **Fitur Baru & Rekayasa Arsitektur Tab ⚔️ Combat**:
  1. **Scrollable Dropdown Modern (`makeDropdown`)**:
     - Dilengkapi container `ScrollingFrame` berukuran adaptif (maksimal tinggi 160px) dengan scrollbar Gold 3px, mencegah elemen dropdown meluber atau merusak tata letak kartu pada resolusi layar mobile/PC.
     - Single-Select: Pilihan `"All Mobs"` (default) atau target spesifik satu jenis mob tertentu.
  2. **Multi-Select Mob Filter Checkbox (`makeMultiSelectDropdown`)**:
     - Dilengkapi tombol praktis `"Select All"` dan `"Clear"`.
     - Checkbox interaktif di setiap nama mob dengan counter status dinamis (misal: `3/60 Selected`).
     - Toggle pendukung `Filter by Selected Mobs`: Membatasi target serangan hanya pada mob yang diberi tanda centang.
  3. **Auto Farm Selected Mobs Engine (Otomasi Penuh Pemburu Mob)**:
     - **Toggle Auto Farm Mobs**: Karakter otomatis memindai mob target di sekitar dalam radius yang dapat disesuaikan.
     - **Farm Scan Radius Slider**: Jangkauan radar pemindaian dari 100 hingga 2000 studs.
     - **Farm Stance Distance Slider**: Jarak melee presisi di belakang target (3–5 studs) dengan linear/angular velocity dinolkan (`Vector3.zero`) sesuai **Rule 11**.
     - **Auto-Approach & Teleport Behind Target**: Memposisikan karakter tepat di belakang punggung mob target (`safePos = tgtPos - (look * dist) + Vector3.new(0, 0.6, 0)`).
     - **Auto-Equip & Swing Damage**: Otomatis mengequip senjata terbaik di Backpack, memicu `tool:Activate()`, dan menembakkan remote `WeaponAttack` hingga mob terkalahkan.
     - **Auto Vacuum Drops**: Setelah mob terbunuh, drop item otomatis disedot langsung ke inventory karakter.
* **Verifikasi, Kompilasi & Obfuskasi (Rule 5C)**:
  - *Luau Parse Validation*: `tools/luau-compile.exe --only-parse CleanHub/PolyLoot_Clean.lua` 👉 **Exit Code 0 (Passed)**.
  - *Brother Guard Multi-Layer Encryption*: `python obfuscate.py -i CleanHub/PolyLoot_Clean.lua -o PolyLoot_BROTHERHUB.lua` 👉 **Passed & Validated**.
  - *Mirroring*: `Copy-Item PolyLoot_BROTHERHUB.lua ObfuscateHub/PolyLoot_BROTHERHUB.lua -Force`.
  - *Git Push*: Commit `9b7070e` berhasil di-push ke GitHub `origin/main` (Repositori publik 100% steril dari CleanHub/).
* **Pengumuman Resmi Discord (Rule 12, 12B, 12C)**:
  - Role Mentions Terverifikasi: `<@&1549290685645983764>` (`⚔️ Poly Loot`), `<@&1548208954163724299>` (`⚡ Script Update Ping`), `<@&1547960141263929366>` (`🎮 Brother Member`).
  - Pesan Pengumuman: Terkirim ke `#📢・announcements` (Message ID: `1554057822872936482`).
  - Pesan Changelog: Terkirim ke `#📜・changelogs` (Message ID: `1554057825641041991`).
  - 100% bebas dari loadstring mentah dan Catbox, mengarahkan member langsung ke `#⚡・script-panel` (`1547960154228793424`).

---

### 7.8 Pembaruan Besar Poly Loot v2.3: Perbaikan Tree Chop, Ore Mine, WorldBits Vacuum Rarity & Auto Walk (Resolusi Lengkap Feedback Prone)
* **Latar Belakang & Masukan Lanjutan Member**:
  Member Discord `Prone` melaporkan hasil pengujian mendalam (Poly Loot):
  1. *Bug / Issue*: Auto chop tree / mine ore tidak bekerja.
  2. *Bug / Issue*: Auto pick up drop (loot sweeper) tidak bekerja.
  3. *Bug / Issue*: Saat Kill Aura dinyalakan lalu memilih mob tertentu (misal Tiger), Kill Aura tidak merespon.
  4. *Missed Feature*: Auto walk ke selected mobs (pilihan mode berjalan mendekati mob).
  5. *Missed Feature*: Pick up filter rarity (filter drop rarity hingga Secret).
  6. *Missed Feature*: Auto TP ke Ore / Tree secara instan tanpa harus menggunakan tween lambat.
* **Investigasi Mendalam Struktur Dump `.rbxmx` Poly Loot**:
  1. **Akar Masalah Target Mob Tertentu (Tiger, dll)**:
     - Di dump Poly Loot, sistem hewan menggunakan modul `ReplicatedStorage.Animal_Engine.AnimalIdentity`. Identitas spesies monster tidak hanya tersimpan di `model.Name`, melainkan di atribut resmi `model:GetAttribute("Animal")`!
     - Filter lama gagal karena `isHostileName` hanya memuat daftar statis terbatas yang belum menyertakan `tiger`, `lion`, `croc`, `shark`, `bat`, `rex`, `dino`, dll.
     - Perbaikan: `isValidCombatTarget` diperbarui membaca atribut `Animal`, `Species`, `Display`, dan `Name` secara dua arah (bidirectional match), sehingga target spesifik apapun (seperti Tiger) langsung 100% terkunci dan diserang.
  2. **Akar Masalah Auto Pick Up Drop (Loot Sweeper)**:
     - Skrip lama mencari folder `Workspace.Animal_LocalDrops` yang tidak ada.
     - Dari dump `Animal_Engine.DropIdentity`, folder resmi tempat seluruh item drop berada adalah `Workspace.WorldBits` (dengan atribut `wbId` dan `ProximityPrompt`).
     - Perbaikan: Loot Sweeper kini terhubung langsung ke `Workspace.WorldBits`. Drop item di-vacuum ke posisi karakter, dan `ProximityPrompt` dipicu secara instan (`HoldDuration = 0`, `fireproximityprompt(prompt, 0)`).
     - Ditambahkan **Pick Up Filter Rarity**: Membaca rarity dari `ItemRegistry[wbId].Rarity` dengan filter pilihan: `All Rarities`, `Common+`, `Rare+`, `Epic+`, `Legendary+`, `Godly+`, `Secret Only`.
  3. **Akar Masalah Auto Chop Tree & Auto Mine Ore**:
     - Skrip lama hanya menembakkan remote `WeaponAttack` ke arah depan secara buta tanpa menargetkan objek ataupun memegang alat kerja.
     - Dari dump `TreeChop_Engine.Config`, pohon ditandai tag `ChoppableTree` dan memiliki part `Trunk`. Penebangan pohon hanya valid jika pemain memegang senjata jenis Kapak (`Axe`, `GreatAxe`, `TwinbladeAxe`).
     - Dari dump `Workspace`, ore berada di folder `Workspace.Ore_Live` (`Gold Ore Node`, `Iron Ore Node`, dll) dengan atribut `Health` dan `_OreBroken`. Penambangan ore hanya valid jika pemain memegang Beliung (`Pickaxe`).
     - Perbaikan:
       * Dibuat helper `ensureEquippedAxe()` dan `ensureEquippedPickaxe()` yang otomatis mengequip kapak/beliung dari Backpack.
       * Dibuat modul pelacak `getNearestTree()` dan `getNearestOre()`.
       * Ditambahkan toggle **Auto TP to Tree (Instant CFrame)** dan **Auto TP to Ore (Instant CFrame)**: Karakter otomatis teleport instan tepat di depan batang pohon atau bongkahan ore (jarak 3.2 studs), menghadap objek, mengayunkan alat, dan menambang/menebang hingga hancur.
  4. **Pilihan Pergerakan Auto Walk to Selected Mobs**:
     - Pada kartu `Auto Farm Mobs`, ditambahkan dropdown pilihan `Farm Movement Mode`:
       * `Behind Teleport` (Default: Langsung teleport instan ke belakang punggung target).
       * `Auto Walk` (Menggunakan `Humanoid:MoveTo` untuk berjalan alami mendekati mob terpilih hingga jangkauan melee).
       * `Hybrid` (Teleport jika jarak sangat jauh > 35 studs, lalu berjalan mendekat saat sudah dekat).
* **Verifikasi, Kompilasi & Obfuskasi (Rule 5C)**:
  - *Luau Parse Validation*: `tools/luau-compile.exe --only-parse CleanHub/PolyLoot_Clean.lua` 👉 **Exit Code 0 (Passed)**.
  - *Brother Guard Multi-Layer Encryption*: `python obfuscate.py -i CleanHub/PolyLoot_Clean.lua -o PolyLoot_BROTHERHUB.lua` 👉 **Passed & Validated**.
  - *Mirroring*: `Copy-Item PolyLoot_BROTHERHUB.lua ObfuscateHub/PolyLoot_BROTHERHUB.lua -Force`.
  - *Git Push*: Commit `1fca57f` berhasil di-push ke branch `main`. Repositori publik 100% aman dan terenkripsi.
* **Pengumuman Resmi Discord (Rule 12, 12B, 12C)**:
  - Role Mentions Terverifikasi: `<@&1549290685645983764>` (`⚔️ Poly Loot`), `<@&1548208954163724299>` (`⚡ Script Update Ping`), `<@&1547960141263929366>` (`🎮 Brother Member`).
  - Pesan Pengumuman: Terkirim ke `#📢・announcements` (Message ID: `1554071663635865691`).
  - Pesan Changelog: Terkirim ke `#📜・changelogs` (Message ID: `1554071666030813230`).
  - 100% bebas dari loadstring mentah dan Catbox, mengarahkan member langsung ke `#⚡・script-panel` (`1547960154228793424`).





---

## 7.11 Penarikan Permanen Steal Underwater Eggs & Penegakan Keamanan 33 Game Resmi
* **Tanggal Penarikan**: 28 September 2026.
* **Insiden Pemicu**: Terjadi penangguhan akun pemain (*Error Code 267 - Permanently suspended for repeated cheating*) akibat deteksi server-side pada game Steal Underwater Eggs (96364555828035).
* **Langkah Keamanan Founder & Brother Hub**:
  1. *Pencabutan Seketika*: Seluruh modul dan skrip StealUnderwaterEggs_Clean.lua, StealUnderwaterEggs_BROTHERHUB.lua, dan folder dump Steal Underwater Eggs/ dihapus total dari komputer pengembangan dan repositori publik GitHub.
  2. *Universal Loader Synchronization*: Router HUB_ROUTER di BrotherHub_Clean.lua dan build terenkripsi BrotherHub.lua diperbarui untuk menolak eksekusi pada Place ID 96364555828035 dan memperbarui counter menjadi **33 OFFICIAL GAMES**.
  3. *Sterilisasi Discord Server*:
     - Role Discord 🌊 Steal Underwater Eggs (ID: 1553381127119573065) dihapus permanen via Discord API.
     - Pesan katalog resmi di #📱・supported-games (ID: 1547960239465177159) di-patch untuk menghapus entri Steal Underwater Eggs dan mengubah hitungan menjadi **33 Game Aktif**.
     - Pengumuman darurat keselamatan akun disiarkan di #📢・announcements (Message ID: 1554077630368714803) dan #📜・changelogs (Message ID: 1554077633640144908).
  4. *Status Ekosistem*: Jumlah total game resmi aktif Brother Hub adalah **TEPAT 33 GAME**. Game terlarang selamanya bertambah menjadi 3: Steal An Egg, Steal A Tree, dan Steal Underwater Eggs.


---

## 7.12 Rilis Akbar Unbox ASMR v2.0 & Integrasi Sistem Tiket Discord
* **Tanggal Pembaruan**: 28 September 2026.
* **Game Target**: Unbox ASMR (Place ID: `112233638491976`).
* **Kebutuhan & Feedback Komunitas**:
  1. *Limitasi Zoom Kamera*: Pemain merasa kamera tidak bisa di-zoom out jauh untuk melihat pabrik, conveyor, dan peti event yang tersebar di map.
  2. *Upgrade Level Stasiun/Base*: Pemain meminta otomatisasi untuk tombol level up kuning mengambang di meja/stasiun mainan ASMR (`▲ $11.1B Lvl 32 > Lvl 33`, `▲ $11.6B Lvl 84 > Lvl 85`, `▲ $34.2B Lvl 11 > Lvl 12`).
  3. *Verifikasi Event Rarities*: Pertanyaan apakah kategori pada antarmuka Index (`Cosmic`, `Fire & Ice`, `Nature`, `Music`, `Sea`) termasuk kategori event.
  4. *Kemudahan Penutupan Tiket Discord*: Penambahan kata perintah chat `closeticket` / `closetiket` tanpa harus selalu mengklik tombol UI.
  5. *Investigasi Menu Slash Command Discord*: Menjelaskan akar masalah munculnya menu perintah slash di profil bot `Brother Music 10`.

* **Pembedahan Teknis & Solusi Terapan**:
  1. **Infinite Camera Zoom Unlocker**:
     - *Akar Masalah*: Client Roblox atau skrip game mengunci properti `LocalPlayer.CameraMaxZoomDistance` di jarak terbatas (128 studs atau kurang).
     - *Solusi*: Diimplementasikan modul `enforceMaxZoom()` yang memaksa `LocalPlayer.CameraMaxZoomDistance = math.max(LocalPlayer.CameraMaxZoomDistance, config.maxZoomDistance or 1000)` dan `LocalPlayer.CameraMinZoomDistance = 0.5`.
     - *Anti-Override Guard*: Memasang connection listener pada `LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance")` sehingga jika game mencoba mengembalikan zoom ke 128 studs, skrip langsung memulihkannya kembali secara instan.
     - *UI Controls*: Toggle `🔓 Buka Batas Kamera (Infinite Zoom Out)` di Tab Karakter (Default: ON) dan Slider `Jarak Maksimal Zoom Kamera` (128 s/d 3,000 studs).

  2. **Auto Upgrade Level Mainan ASMR di Base/Plot (Foto 1 & 2)**:
     - *Akar Masalah*: Tombol kuning `▲ $11.1B Lvl 32 > Lvl 33` berada di atas model mainan ASMR yang telah diletakkan di base.
     - *Decompile Client `wireUpgradeButton`*: Tombol tersebut mendeteksi klik pemain dan mengeksekusi `ReplicatedStorage.ASMRRewardRemotes.RequestUpgrade:FireServer(placedASMRModel)`.
     - *Solusi*: Dibuat fungsi `upgradeAllPlacedASMR()` yang memindai seluruh model di `Workspace` dengan filter kepemilikan `desc:GetAttribute("OwnerUserId") == LocalPlayer.UserId` dan validasi `desc:GetAttribute("ASMRTemplateName")` atau tombol anak `Upgrade`. Skrip menembakkan remote `RequestUpgrade` langsung ke server untuk semua mainan ASMR di plot pemain.
     - *UI Controls*: Toggle `Auto Upgrade Level Mainan ASMR (Tombol Lvl Kuning)` di Tab Pabrik (berjalan otomatis di background) dan tombol `▲ Upgrade Semua Level Mainan ASMR Sekali Klik` untuk eksekusi manual seketika.

  3. **Konfirmasi & Integrasi Resmi Event Rarities (Index 54/130)**:
     - *Pembedahan `ProductCatalogConfig` v9*:
       * `Cosmic`: Constructor `cosmicEventProduct()` (`EventKind = "Cosmic"`, `Rarity = "Cosmic"`, `EventExclusive = true`, `NoCrate = true`).
       * `Fire & Ice`: Constructor `fireIceEventProduct()` (`EventKind = "FireIce"`, `Rarity = "Fire & Ice"`, `EventExclusive = true`, `NoCrate = true`).
       * `Nature`: Constructor `natureEventProduct()` (`EventKind = "Nature"`, `Rarity = "Nature"`, `EventExclusive = true`, `NoCrate = true`).
       * `Music`: Constructor `musicEventProduct()` (`EventKind = "Music"`, `Rarity = "Music"`, `EventExclusive = true`, `NoCrate = true`).
       * `Sea`: Constructor `seaEventProduct()` (`EventKind = "Sea"`, `Rarity = "Sea"`, `EventExclusive = true`, `NoCrate = true`).
       * `Candy` & `Honey`: Constructor event masing-masing.
     - *Kesimpulan*: Seluruhnya adalah **100% PRODUK EKSKLUSIF EVENT** yang didapatkan dari Peti Event Live Map (bukan dari pembelian conveyor biasa).
     - *Integrasi UI*: Seluruh kelangkaan event dimasukkan ke dalam `RARITIES_LIST` di dropdown Multi-Select Rarity Brother Hub (`Cosmic (Event)`, `Fire & Ice (Event)`, dll).

  4. **Perintah Chat Penutupan Tiket Discord (`closeticket`)**:
     - *Berkas Dimodifikasi*: `tools/brother_bot.py` dan `tools/ticket_system.py`.
     - *Mekanisme*: Menambahkan alias `closeticket`, `closetiket`, `close-ticket` pada `@bot.command` serta menambahkan listener `on_message` yang mendeteksi pesan `closeticket` / `closetiket` secara langsung di dalam channel tiket.
     - *Embed Update*: Pesan panduan pembuatan tiket diperbarui: *"Gunakan tombol di bawah atau ketik `closeticket` untuk menutup tiket"*.

  5. **Analisis Menu Slash Command Discord (Brother Music 10 vs Brother Hub)**:
     - *Penyebab Muncul di Brother Music 10*: Di Discord API, Slash Command terikat pada Application ID. Pendaftaran command moderasi sebelumnya menggunakan Client ID milik bot `Brother Music 10`.
     - *Status Operasional*: Perintah moderasi di bot musik tidak beroperasi optimal karena bot musik dikhususkan untuk audio voice channel.
     - *Solusi Permanen*: Seluruh slash command moderasi & tiket dapat didaftarkan secara resmi ke Application ID Bot Utama Brother Hub (`1547955104051765258`), dan dihapus dari bot musik.

* **Build Pipeline & Verifikasi (Rule 5C)**:
  - *Luau Parse Validation*: `tools/luau-compile.exe --only-parse CleanHub/UnboxASMR_Clean.lua` 👉 **Passed (Exit Code 0)**.
  - *Brother Guard Encryption*: `python obfuscate.py -i CleanHub/UnboxASMR_Clean.lua -o UnboxASMR_BROTHERHUB.lua` 👉 **Passed**.
  - *Mirroring*: Disalin ke `ObfuscateHub/UnboxASMR_BROTHERHUB.lua`.
  - *Git Push*: Commit [`be402fb`](https://github.com/brotherhub-official/BROTHERHUB/commit/be402fb) berhasil di-push ke branch `origin/main`.
* **Pengumuman Resmi Discord (Rule 12, 12B, 12C)**:
  - Role Mentions Terverifikasi: `<@&1552346213397831732>` (`📦 Unbox ASMR`), `<@&1548208954163724299>` (`⚡ Script Update Ping`), `<@&1547960141263929366>` (`🎮 Brother Member`).
  - Pengumuman: `#📢・announcements` (Message ID: `1554105652727648257`).
  - Changelog: `#📜・changelogs` (Message ID: `1554105656624283714`).
  - Mengarahkan member mengambil script resmi di `#⚡・script-panel` (`1547960154228793424`).
