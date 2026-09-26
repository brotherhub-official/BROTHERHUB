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

---

# BAGIAN IV: MASTER ROSTER 34 GAME RESMI BROTHER HUB

Tabel di bawah adalah **Sumber Kebenaran Tunggal (Single Source of Truth)** untuk 34 game resmi yang didukung penuh oleh Brother Hub:

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

### 5.2 Aturan 5B: Game Terlarang Permanen (Steal An Egg & Steal A Tree)
* Game `Steal An Egg` (lama) dan `Steal A Tree` telah **DIHAPUS TOTAL DAN DILARANG SELAMANYA**.
* Total game resmi Brother Hub adalah **TEPAT 34 GAME** (Game #27 adalah `Steal An Anime Egg`, Game #32 adalah `Clone to Steal Eggs`, Game #33 adalah `Super Treehouse Tycoon 2`, Game #34 adalah `Steal Underwater Eggs`).

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


