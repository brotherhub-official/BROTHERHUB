#!/usr/bin/env python3
"""
Brother Hub - Unified Professional Self-Roles System
- 100% UNIFIED in 1 Single Message (No split Bagian 1 / Bagian 2)
- Row 0: 5 Action Buttons for Notification Pings & Device Types
- Row 1: Dropdown Select Menu for all 21 Supported Games
"""

import sys
import os
import discord

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8', errors='replace', line_buffering=True)

AUTHORIZED_GUILD_ID = 1547929421284114453
ROLES_CHANNEL_ID = 1547960169206644838
SERVER_ICON_URL = "https://cdn.discordapp.com/icons/1547929421284114453/45d5b82878099746173bff32ee6a53e1.png?size=512"

# 1. Action Buttons Config (Row 0: 5 Buttons, Row 1: Casino Player)
ACTION_BUTTONS_CONFIG = [
    {"id_key": "announcements", "name": "📢 Announcement Ping", "color": 0x3498DB, "emoji": "📢", "style": discord.ButtonStyle.primary, "row": 0},
    {"id_key": "script_update", "name": "⚡ Script Update Ping", "color": 0xF1C40F, "emoji": "⚡", "style": discord.ButtonStyle.primary, "row": 0},
    {"id_key": "giveaways", "name": "🎁 Giveaway Ping", "color": 0xE91E63, "emoji": "🎁", "style": discord.ButtonStyle.primary, "row": 0},
    {"id_key": "pc_player", "name": "💻 PC Player", "color": 0x95A5A6, "emoji": "💻", "style": discord.ButtonStyle.success, "row": 0},
    {"id_key": "mobile_player", "name": "📱 Mobile Player", "color": 0x2ECC71, "emoji": "📱", "style": discord.ButtonStyle.success, "row": 0},
    {"id_key": "casino_player", "name": "🎰 Casino Player", "color": 0xF1C40F, "emoji": "🎰", "style": discord.ButtonStyle.secondary, "row": 1},
]

# 2. Supported Games Config (Row 2: Dropdown Select Menu up to 25 games)
GAMES_CONFIG = [
    {"id_key": "steal_a_seed", "name": "🌱 Steal A Seed", "color": 0x2ECC71, "emoji": "🌱", "desc": "Auto steal 0s bypass, plant & harvest, sell, seed & pack shop, pet hatch"},
    {"id_key": "fish_on", "name": "🎣 Fish On", "color": 0x00BFFF, "emoji": "🎣", "desc": "Auto cast & reel, instant catch, sell, rod & bait shop, boats & islands"},
    {"id_key": "flower_shop", "name": "🌸 My Flower Shop", "color": 0xFFB6C1, "emoji": "🌸", "desc": "Auto craft, sell bouquets, planter & garden"},
    {"id_key": "dig_secrets", "name": "⛏️ Dig Into Secrets", "color": 0xE67E22, "emoji": "⛏️", "desc": "God speed clicker, auto training & layer nuker"},
    {"id_key": "sell_ores", "name": "💎 Sell Ores", "color": 0x1ABC9C, "emoji": "💎", "desc": "Smart auto drill, fuser, roll ore & teleport"},
    {"id_key": "fish_anime", "name": "🎣 Fish an Anime", "color": 0x3498DB, "emoji": "🎣", "desc": "Auto cast & reel, RNG rolls, sell & island TP"},
    {"id_key": "the_mimic", "name": "👹 The Mimic", "color": 0x9B59B6, "emoji": "👹", "desc": "Full chapter helper, monster ESP & night vision"},
    {"id_key": "farm_industry", "name": "🌾 Farm Industry", "color": 0x2ECC71, "emoji": "🌾", "desc": "Auto harvest, sell crops, factory & tractor"},
    {"id_key": "poly_loot", "name": "⚔️ Poly Loot", "color": 0xE74C3C, "emoji": "⚔️", "desc": "Kill aura, safe stance, auto loot & chests"},
    {"id_key": "dungeon_lootr", "name": "⚔️ Dungeon Lootr", "color": 0x9B59B6, "emoji": "⚔️", "desc": "M1 kill aura, spam skills, safe stance & TP"},
    {"id_key": "dungeon_quest", "name": "🏰 Dungeon Quest Reborn", "color": 0x3498DB, "emoji": "🏰", "desc": "Auto dungeon clear, boss farm & skill spam"},
    {"id_key": "idle_mafia", "name": "🕵️ Idle Mafia", "color": 0x34495E, "emoji": "🕵️", "desc": "Auto business buy, heist, collect cash & mafia"},
    {"id_key": "storage_hunters", "name": "📦 Storage Hunters", "color": 0xF39C12, "emoji": "📦", "desc": "Auto auction bid, lockpick, sell pawnshop & jobs"},
    {"id_key": "drill_earth", "name": "🌍 Drill to Earth's Core", "color": 0xE67E22, "emoji": "🌍", "desc": "Auto mine layers, instant fuel sell & core drill"},
    {"id_key": "defeat_anime", "name": "💥 Defeat Anime RNG", "color": 0xE91E63, "emoji": "💥", "desc": "Auto attack, roll aura, cards & boss farm"},
    {"id_key": "catch_dragons", "name": "🐉 Catch Dragons To Defend", "color": 0x00FFC8, "emoji": "🐉", "desc": "Auto cast ball, catch dragons & defend base"},
    {"id_key": "pop_bubbles", "name": "🫧 Pop Bubbles", "color": 0x00D2FF, "emoji": "🫧", "desc": "Auto blow, pop bubbles, pet hatch & teleports"},
    {"id_key": "heavyweight_fishing", "name": "🎣 Heavyweight Fishing", "color": 0x3498DB, "emoji": "🎣", "desc": "Auto perfect cast & reel, fish index & sell"},
    {"id_key": "shoguns_reign", "name": "⚔️ Shogun's Reign", "color": 0xE74C3C, "emoji": "⚔️", "desc": "Combat aura, auto farm, mining, iron & jobs"},
    {"id_key": "clicker_simulator", "name": "🖱️ Clicker Simulator", "color": 0x00D2FF, "emoji": "🖱️", "desc": "Machine-gun clicker, auto rebirth & egg hatch"},
    {"id_key": "loot_up", "name": "💎 Loot Up", "color": 0x00FFC8, "emoji": "💎", "desc": "Kill aura, safe stance, auto rolls, dungeon & tower"},
    {"id_key": "pack_brainrot", "name": "🃏 Pack A Brainrot Card", "color": 0xFF007F, "emoji": "🃏", "desc": "Auto buy packs, base slots, sell filters & rebirth"},
    {"id_key": "mine_it", "name": "⛏️ Mine It", "color": 0xF39C12, "emoji": "⛏️", "desc": "Auto mine ores, multi-select, stance offset, shop & teleports"},
    {"id_key": "dungeons_tower", "name": "🏰 Dungeons Tower", "color": 0x9B59B6, "emoji": "🏰", "desc": "Auto solo party, kill aura, safe stance, drop vacuum & chests"},
    {"id_key": "pets_universe", "name": "🐾 Pets Universe", "color": 0x00FFC8, "emoji": "🐾", "desc": "Auto farm breakables, hatch eggs, machines, moon upgrades, chests & TP"},
]

ALL_CONFIGS = ACTION_BUTTONS_CONFIG + GAMES_CONFIG

async def ensure_roles_exist(guild: discord.Guild):
    """Pastikan seluruh role yang dikonfigurasi sudah ada di server"""
    role_map = {}
    for item in ALL_CONFIGS:
        role = discord.utils.get(guild.roles, name=item["name"])
        if not role:
            try:
                role = await guild.create_role(
                    name=item["name"],
                    color=discord.Color(item["color"]),
                    mentionable=True,
                    reason="Brother Hub Self-Roles Setup"
                )
                print(f"[ROLE CREATED] '{role.name}' ({role.id})")
            except Exception as e:
                print(f"[ERROR] Failed to create role {item['name']}: {e}")
        role_map[item["id_key"]] = role
    return role_map


class SelfRoleButton(discord.ui.Button):
    def __init__(self, config_item):
        full_name = config_item["name"]
        emoji = config_item.get("emoji")
        clean_label = full_name
        if emoji and clean_label.startswith(emoji):
            clean_label = clean_label[len(emoji):].strip()

        super().__init__(
            label=clean_label,
            style=config_item["style"],
            emoji=emoji,
            custom_id=f"bh_selfrole_{config_item['id_key']}",
            row=config_item["row"]
        )
        self.role_name = full_name

    async def callback(self, interaction: discord.Interaction):
        guild = interaction.guild
        member = interaction.user
        role = discord.utils.get(guild.roles, name=self.role_name)

        if not role:
            return await interaction.response.send_message(
                f"❌ Role `{self.role_name}` tidak ditemukan di server!",
                ephemeral=True
            )

        if role in member.roles:
            try:
                await member.remove_roles(role, reason="Self-Role Button Toggled Off")
                await interaction.response.send_message(
                    f"❌ Role **{role.name}** telah **dilepas** dari profil Anda!",
                    ephemeral=True
                )
            except Exception as e:
                await interaction.response.send_message(f"⚠️ Gagal melepas role: {e}", ephemeral=True)
        else:
            try:
                await member.add_roles(role, reason="Self-Role Button Toggled On")
                await interaction.response.send_message(
                    f"✅ Role **{role.name}** berhasil **ditambahkan** ke profil Anda!",
                    ephemeral=True
                )
            except Exception as e:
                await interaction.response.send_message(f"⚠️ Gagal menambahkan role: {e}", ephemeral=True)


class SelfRoleGameSelect(discord.ui.Select):
    def __init__(self):
        options = []
        for g in GAMES_CONFIG:
            full_name = g["name"]
            emoji = g.get("emoji")
            clean_label = full_name
            if emoji and clean_label.startswith(emoji):
                clean_label = clean_label[len(emoji):].strip()

            options.append(
                discord.SelectOption(
                    label=clean_label,
                    value=g["id_key"],
                    emoji=emoji,
                    description=g.get("desc", f"Role {clean_label}")[:100]
                )
            )

        super().__init__(
            placeholder="🎮 Pilih Game Favorit Anda (Klik untuk Ambil / Lepas Role)",
            min_values=1,
            max_values=1,
            options=options,
            custom_id="bh_selfrole_games_dropdown",
            row=2
        )
        self.games_by_key = {g["id_key"]: g["name"] for g in GAMES_CONFIG}

    async def callback(self, interaction: discord.Interaction):
        key = self.values[0]
        role_name = self.games_by_key.get(key)
        if not role_name:
            return await interaction.response.send_message("❌ Role tidak dikenali!", ephemeral=True)

        guild = interaction.guild
        member = interaction.user
        role = discord.utils.get(guild.roles, name=role_name)
        if not role:
            return await interaction.response.send_message(f"❌ Role `{role_name}` tidak ditemukan di server!", ephemeral=True)

        if role in member.roles:
            try:
                await member.remove_roles(role, reason="Self-Role Dropdown Toggled Off")
                await interaction.response.send_message(
                    f"❌ Role **{role.name}** telah **dilepas** dari profil Anda!",
                    ephemeral=True
                )
            except Exception as e:
                await interaction.response.send_message(f"⚠️ Gagal melepas role: {e}", ephemeral=True)
        else:
            try:
                await member.add_roles(role, reason="Self-Role Dropdown Toggled On")
                await interaction.response.send_message(
                    f"✅ Role **{role.name}** berhasil **ditambahkan** ke profil Anda!",
                    ephemeral=True
                )
            except Exception as e:
                await interaction.response.send_message(f"⚠️ Gagal menambahkan role: {e}", ephemeral=True)


class SelfRolesView(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=None)
        # Action Buttons (Row 0 & Row 1)
        for item in ACTION_BUTTONS_CONFIG:
            self.add_item(SelfRoleButton(item))
        # Row 2: Unified Dropdown for all 23 games
        self.add_item(SelfRoleGameSelect())


# Backward-compatibility wrappers
class SelfRolesViewPart1(SelfRolesView):
    pass

class SelfRolesViewPart2(SelfRolesView):
    pass


def create_roles_embed() -> discord.Embed:
    embed = discord.Embed(
        title="🎭 BROTHER HUB | OFFICIAL ROLES SELECTION",
        description=(
            "Selamat datang di Panel Pemilihan Role Mandiri **BROTHER HUB**!\n"
            "Gunakan tombol dan menu dropdown di bawah untuk mengambil atau melepas role sesuai minat Anda:\n\n"
            "🔔 **NOTIFICATION PINGS & COMMUNITY**\n"
            "• `📢 Announcement Ping` : Dapatkan info pengumuman penting server.\n"
            "• `⚡ Script Update Ping` : Notifikasi instan saat ada update script Roblox.\n"
            "• `🎁 Giveaway Ping` : Peringatan saat ada event giveaway berhadiah.\n"
            "• `🎰 Casino Player` : Notifikasi event jackpot & update kasino di `#🎰・casino`.\n"
            "• `💻 PC Player` | `📱 Mobile Player` : Tipe perangkat bermain Anda.\n\n"
            "🎮 **25 SUPPORTED GAMES LIST (PILIH LEWAT DROPDOWN DI BAWAH)**\n"
            "• `🌱 Steal A Seed` • `🎣 Fish On` • `🌸 My Flower Shop`\n"
            "• `⛏️ Dig Into Secrets` • `💎 Sell Ores` • `🎣 Fish an Anime`\n"
            "• `👹 The Mimic` • `🌾 Farm Industry` • `⚔️ Poly Loot`\n"
            "• `⚔️ Dungeon Lootr` • `🏰 Dungeon Quest Reborn` • `🕵️ Idle Mafia`\n"
            "• `📦 Storage Hunters` • `🌍 Drill to Earth` • `💥 Defeat Anime RNG`\n"
            "• `🐉 Catch Dragons` • `🫧 Pop Bubbles` • `🎣 Heavyweight Fishing`\n"
            "• `⚔️ Shogun's Reign` • `🖱️ Clicker Simulator` • `💎 Loot Up`\n"
            "• `🃏 Pack A Brainrot Card` • `⛏️ Mine It` • `🏰 Dungeons Tower`\n"
            "• `🐾 Pets Universe`\n\n"
            "────────────────────────────────────────\n"
            "💡 **CARA PENGGUNAAN:**\n"
            "1. Klik tombol **Pings / Community / Device** di atas untuk toggle instan.\n"
            "2. Klik menu dropdown **'🎮 Pilih Game Favorit Anda'** di bawah untuk memilih game yang Anda mainkan.\n"
            "3. Memilih game yang sama untuk kedua kalinya otomatis **melepas** role tersebut."
        ),
        color=0x00E5FF
    )
    embed.set_thumbnail(url=SERVER_ICON_URL)
    embed.set_footer(text="Brother Hub Community • 100% Unified Self-Roles Suite")
    return embed


def create_roles_embed_part1() -> discord.Embed:
    return create_roles_embed()

def create_roles_embed_part2() -> discord.Embed:
    return create_roles_embed()
