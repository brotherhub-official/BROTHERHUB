"""
========================================================================================
BROTHER STUDIO PRODUCTIONS — OFFICIAL 100% SKELETAL SKIN CREATURE GENERATOR
BLENDER 5.2.3 LTS — SKINNED BIPED/QUADRUPED MESHES WITH SUBSURFACE SMOOTHING
PRODUCES TRUE ORGANIC SKELETON-BASED CREATURES (ZERO FLOATING BALLS, ZERO SLUGS!)
========================================================================================
"""
import bpy
import bmesh
import os

OUTPUT_DIR = r"C:\Users\andra\Downloads\BrotherHub_Project\CustomBlenderAssets"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def reset_blender():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    for c in list(bpy.data.collections):
        bpy.data.collections.remove(c)

def create_creature(name, joints, bones, radii, fbx_filename, color_rgba, roughness=0.7):
    reset_blender()
    
    mesh = bpy.data.meshes.new(name + "_Mesh")
    obj = bpy.data.objects.new(name, mesh)
    bpy.context.collection.objects.link(obj)
    bpy.context.view_layer.objects.active = obj
    
    bm = bmesh.new()
    vert_map = {}
    for j_id, coord in joints.items():
        vert_map[j_id] = bm.verts.new(coord)
        
    for j1, j2 in bones:
        if j1 in vert_map and j2 in vert_map:
            bm.edges.new((vert_map[j1], vert_map[j2]))
            
    bm.to_mesh(mesh)
    bm.free()
    
    # Add Skin Modifier
    obj.modifiers.new(name="Skin", type='SKIN')
    skin_data = mesh.skin_vertices[0].data
    
    for idx, (rx, ry) in radii.items():
        if idx < len(skin_data):
            skin_data[idx].radius = (rx, ry)
            
    # Add Subdivision Surface for organic smoothing
    sub = obj.modifiers.new(name="Subdivision", type='SUBSURF')
    sub.levels = 2
    
    # Apply modifiers to create pure single manifold mesh
    bpy.ops.object.modifier_apply(modifier="Skin")
    bpy.ops.object.modifier_apply(modifier="Subdivision")
    
    # Smooth shading
    for poly in obj.data.polygons:
        poly.use_smooth = True
        
    # Material
    mat = bpy.data.materials.new(name=name + "_Mat")
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    nodes.clear()
    bsdf = nodes.new(type='ShaderNodeBsdfPrincipled')
    bsdf.inputs['Base Color'].default_value = color_rgba
    bsdf.inputs['Roughness'].default_value = roughness
    out = nodes.new(type='ShaderNodeOutputMaterial')
    mat.node_tree.links.new(bsdf.outputs['BSDF'], out.inputs['Surface'])
    obj.data.materials.append(mat)
    
    # Export FBX
    out_path = os.path.join(OUTPUT_DIR, fbx_filename)
    bpy.ops.export_scene.fbx(
        filepath=out_path,
        use_selection=False,
        global_scale=1.0,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_ALL',
        mesh_smooth_type='FACE'
    )
    print(f"[SUCCESS] Exported {fbx_filename} ({len(obj.data.vertices)} vertices)")

# ====================================================================
# 1. BACTERIA (KANE PIXELS SLENDER S-CURVE WIRE STALKER)
# ====================================================================
def build_bacteria():
    joints = {
        0: (0, -0.2, 1.8),   # Pelvis
        1: (0, 0.0, 2.6),    # Mid spine
        2: (0, 0.3, 3.4),    # Upper chest
        3: (0, 0.6, 4.2),    # Hunched neck
        4: (0, 0.9, 4.8),    # Slender skull
        5: (0, 1.3, 4.7),    # Needle snout
        # Left Arm (Long multi-jointed)
        6: (-0.7, 0.4, 3.5), # Sh L
        7: (-1.3, 0.5, 2.5), # El L
        8: (-1.7, 0.7, 1.4), # Wr L
        9: (-2.0, 0.9, 0.3), # Scythe L
        # Right Arm
        10: (0.7, 0.4, 3.5), # Sh R
        11: (1.3, 0.5, 2.5), # El R
        12: (1.7, 0.7, 1.4), # Wr R
        13: (2.0, 0.9, 0.3), # Scythe R
        # Left Leg (Digitigrade)
        14: (-0.5, -0.2, 1.6), # Hip L
        15: (-0.6, -0.5, 0.8), # Knee L
        16: (-0.6, -0.1, 0.0), # Ankle L
        17: (-0.6, 0.3, -0.4), # Talon L
        # Right Leg
        18: (0.5, -0.2, 1.6), # Hip R
        19: (0.6, -0.5, 0.8), # Knee R
        20: (0.6, -0.1, 0.0), # Ankle R
        21: (0.6, 0.3, -0.4), # Talon R
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (2,6),(6,7),(7,8),(8,9),
        (2,10),(10,11),(11,12),(12,13),
        (0,14),(14,15),(15,16),(16,17),
        (0,18),(18,19),(19,20),(20,21),
    ]
    radii = {
        0:(0.32,0.25), 1:(0.28,0.22), 2:(0.38,0.28), 3:(0.2,0.2), 4:(0.35,0.45), 5:(0.18,0.25),
        6:(0.2,0.2), 7:(0.16,0.16), 8:(0.12,0.12), 9:(0.06,0.16),
        10:(0.2,0.2), 11:(0.16,0.16), 12:(0.12,0.12), 13:(0.06,0.16),
        14:(0.25,0.25), 15:(0.18,0.18), 16:(0.14,0.14), 17:(0.08,0.2),
        18:(0.25,0.25), 19:(0.18,0.18), 20:(0.14,0.14), 21:(0.08,0.2),
    }
    create_creature("Bacteria_Stage1", joints, bones, radii, "Bacteria_Stage1.fbx", (0.02, 0.02, 0.025, 1.0), 0.9)

# ====================================================================
# 2. SMILER (VOID PHANTOM WITH SPREADING WINGS & JAW)
# ====================================================================
def build_smiler():
    joints = {
        0: (0, 0, 1.8),   # Center void
        1: (0, 0, 2.5),   # Upper void
        2: (0, 0, 3.2),   # Head crest
        3: (0, 0.4, 2.6), # Smiling Maw center
        4: (-0.6, 0.35, 2.8), # Smile corner L
        5: (0.6, 0.35, 2.8),  # Smile corner R
        # Floating mist crests
        6: (-0.9, 0, 2.2),
        7: (-1.4, -0.2, 1.4),
        8: (0.9, 0, 2.2),
        9: (1.4, -0.2, 1.4),
        10: (0, -0.3, 1.0),
        11: (0, -0.5, 0.3),
    }
    bones = [
        (0,1),(1,2),(1,3),(3,4),(3,5),
        (0,6),(6,7),(0,8),(8,9),(0,10),(10,11)
    ]
    radii = {
        0:(0.7,0.7), 1:(0.85,0.85), 2:(0.6,0.6), 3:(0.35,0.25), 4:(0.2,0.15), 5:(0.2,0.15),
        6:(0.4,0.4), 7:(0.2,0.2), 8:(0.4,0.4), 9:(0.2,0.2), 10:(0.45,0.45), 11:(0.2,0.2)
    }
    create_creature("Smiler_Stage2", joints, bones, radii, "Smiler_Stage2.fbx", (0.01, 0.01, 0.015, 1.0), 0.95)

# ====================================================================
# 3. HYDRO LURKER (AQUATIC STREAMLINED PREDATOR)
# ====================================================================
def build_hydro_lurker():
    joints = {
        0: (0, 0, 1.6),    # Pelvis
        1: (0, 0.05, 2.3), # Waist
        2: (0, 0.1, 3.0),  # Chest
        3: (0, 0.2, 3.7),  # Neck
        4: (0, 0.35, 4.3), # Aquatic Head
        5: (0, 0.65, 4.2), # Jaw
        # Dorsal fin crest
        6: (0, -0.35, 2.6),
        7: (0, -0.45, 3.2),
        # Webbed Arms
        8: (-0.75, 0.1, 3.0), 9: (-1.3, 0.15, 2.2), 10: (-1.7, 0.25, 1.3), 11: (-2.0, 0.35, 0.5),
        12: (0.75, 0.1, 3.0), 13: (1.3, 0.15, 2.2), 14: (1.7, 0.25, 1.3), 15: (2.0, 0.35, 0.5),
        # Swimming Legs
        16: (-0.45, 0, 1.4), 17: (-0.5, -0.2, 0.7), 18: (-0.5, 0.0, 0.0), 19: (-0.5, 0.3, -0.3),
        20: (0.45, 0, 1.4), 21: (0.5, -0.2, 0.7), 22: (0.5, 0.0, 0.0), 23: (0.5, 0.3, -0.3),
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (1,6),(2,7),
        (2,8),(8,9),(9,10),(10,11),
        (2,12),(12,13),(13,14),(14,15),
        (0,16),(16,17),(17,18),(18,19),
        (0,20),(20,21),(21,22),(22,23),
    ]
    radii = {
        0:(0.35,0.28), 1:(0.32,0.25), 2:(0.45,0.32), 3:(0.2,0.2), 4:(0.38,0.45), 5:(0.22,0.22),
        6:(0.12,0.28), 7:(0.1,0.32),
        8:(0.22,0.22), 9:(0.18,0.18), 10:(0.14,0.14), 11:(0.08,0.2),
        12:(0.22,0.22), 13:(0.18,0.18), 14:(0.14,0.14), 15:(0.08,0.2),
        16:(0.26,0.26), 17:(0.2,0.2), 18:(0.15,0.15), 19:(0.1,0.22),
        20:(0.26,0.26), 21:(0.2,0.2), 22:(0.15,0.15), 23:(0.1,0.22),
    }
    create_creature("HydroStalker_Stage3", joints, bones, radii, "HydroStalker_Stage3.fbx", (0.72, 0.88, 0.88, 1.0), 0.18)

# ====================================================================
# 4. CONCRETE HOUND (QUADRUPED STONE PREDATOR)
# ====================================================================
def build_concrete_hound():
    joints = {
        0: (0, -0.6, 1.2),  # Hind pelvis
        1: (0, 0.0, 1.3),   # Mid torso
        2: (0, 0.6, 1.4),   # Front chest/shoulders
        3: (0, 1.1, 1.6),   # Muscular neck
        4: (0, 1.6, 1.7),   # Canine skull
        5: (0, 2.1, 1.5),   # Gaping snout
        # Spikes
        6: (0, -0.4, 1.7), 7: (0, 0.2, 1.85), 8: (0, 0.8, 1.9),
        # Front Left Leg
        9: (-0.55, 0.6, 1.2), 10: (-0.6, 0.7, 0.6), 11: (-0.6, 0.7, 0.0),
        # Front Right Leg
        12: (0.55, 0.6, 1.2), 13: (0.6, 0.7, 0.6), 14: (0.6, 0.7, 0.0),
        # Hind Left Leg
        15: (-0.5, -0.6, 1.0), 16: (-0.55, -0.7, 0.5), 17: (-0.55, -0.6, 0.0),
        # Hind Right Leg
        18: (0.5, -0.6, 1.0), 19: (0.55, -0.7, 0.5), 20: (0.55, -0.6, 0.0),
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (0,6),(1,7),(2,8),
        (2,9),(9,10),(10,11),
        (2,12),(12,13),(13,14),
        (0,15),(15,16),(16,17),
        (0,18),(18,19),(19,20),
    ]
    radii = {
        0:(0.45,0.4), 1:(0.48,0.42), 2:(0.55,0.48), 3:(0.35,0.35), 4:(0.38,0.42), 5:(0.25,0.22),
        6:(0.12,0.12), 7:(0.14,0.14), 8:(0.15,0.15),
        9:(0.28,0.28), 10:(0.22,0.22), 11:(0.15,0.22),
        12:(0.28,0.28), 13:(0.22,0.22), 14:(0.15,0.22),
        15:(0.32,0.32), 16:(0.24,0.24), 17:(0.16,0.24),
        18:(0.32,0.32), 19:(0.24,0.24), 20:(0.16,0.24),
    }
    create_creature("ConcreteHound_Stage4", joints, bones, radii, "ConcreteHound_Stage4.fbx", (0.42, 0.43, 0.45, 1.0), 0.88)

# ====================================================================
# 5. SHADOW STRIDER / SKIN STEALER (11-STUD LANKY GROTESQUE HORROR)
# ====================================================================
def build_shadow_strider():
    joints = {
        0: (0, -0.1, 1.8),   # Pelvis
        1: (0, 0.0, 2.6),    # Waist
        2: (0, 0.2, 3.6),    # Upper chest
        3: (0, 0.45, 4.5),   # Bended neck
        4: (0, 0.7, 5.2),    # Head
        5: (0, 1.0, 5.0),    # Drooping jaw
        # Disproportionate Long Arms (Dragging down past feet)
        6: (-0.8, 0.3, 3.7), 7: (-1.3, 0.4, 2.6), 8: (-1.6, 0.5, 1.4), 9: (-1.8, 0.6, 0.1),
        10: (0.8, 0.3, 3.7), 11: (1.3, 0.4, 2.6), 12: (1.6, 0.5, 1.4), 13: (1.8, 0.6, 0.1),
        # Stilt Legs
        14: (-0.45, -0.1, 1.6), 15: (-0.5, 0.0, 0.8), 16: (-0.5, 0.1, 0.0), 17: (-0.5, 0.3, -0.2),
        18: (0.45, -0.1, 1.6), 19: (0.5, 0.0, 0.8), 20: (0.5, 0.1, 0.0), 21: (0.5, 0.3, -0.2),
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (2,6),(6,7),(7,8),(8,9),
        (2,10),(10,11),(11,12),(12,13),
        (0,14),(14,15),(15,16),(16,17),
        (0,18),(18,19),(19,20),(20,21),
    ]
    radii = {
        0:(0.32,0.26), 1:(0.28,0.22), 2:(0.38,0.28), 3:(0.22,0.22), 4:(0.35,0.45), 5:(0.2,0.2),
        6:(0.22,0.22), 7:(0.18,0.18), 8:(0.14,0.14), 9:(0.1,0.16),
        10:(0.22,0.22), 11:(0.18,0.18), 12:(0.14,0.14), 13:(0.1,0.16),
        14:(0.26,0.26), 15:(0.18,0.18), 16:(0.14,0.14), 17:(0.08,0.2),
        18:(0.26,0.26), 19:(0.18,0.18), 20:(0.14,0.14), 21:(0.08,0.2),
    }
    create_creature("ShadowStrider_Stage5", joints, bones, radii, "ShadowStrider_Stage5.fbx", (0.16, 0.15, 0.14, 1.0), 0.78)

# ====================================================================
# 6. THE PARTYGOER (LEATHERY YELLOW STALKER WITH RAISED ARM)
# ====================================================================
def build_partygoer():
    joints = {
        0: (0, 0, 1.6),   # Pelvis
        1: (0, 0, 2.3),   # Waist
        2: (0, 0, 3.1),   # Chest
        3: (0, 0, 3.8),   # Neck
        4: (0, 0.1, 4.5), # Head
        5: (0, 0.35, 4.4),# Face / Smile
        # Left Arm (Dangling at side)
        6: (-0.75, 0, 3.1), 7: (-1.1, 0, 2.2), 8: (-1.3, 0, 1.3),
        # Right Arm (Raised holding balloon)
        9: (0.75, 0, 3.1), 10: (1.2, 0.1, 3.7), 11: (1.4, 0.2, 4.5),
        # Legs
        12: (-0.45, 0, 1.4), 13: (-0.45, 0, 0.7), 14: (-0.45, 0, 0.0), 15: (-0.45, 0.2, -0.1),
        16: (0.45, 0, 1.4), 17: (0.45, 0, 0.7), 18: (0.45, 0, 0.0), 19: (0.45, 0.2, -0.1),
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (2,6),(6,7),(7,8),
        (2,9),(9,10),(10,11),
        (0,12),(12,13),(13,14),(14,15),
        (0,16),(16,17),(17,18),(18,19),
    ]
    radii = {
        0:(0.4,0.32), 1:(0.36,0.28), 2:(0.48,0.35), 3:(0.24,0.24), 4:(0.45,0.5), 5:(0.25,0.25),
        6:(0.22,0.22), 7:(0.18,0.18), 8:(0.12,0.18),
        9:(0.22,0.22), 10:(0.18,0.18), 11:(0.14,0.18),
        12:(0.3,0.3), 13:(0.22,0.22), 14:(0.16,0.16), 15:(0.1,0.22),
        16:(0.3,0.3), 17:(0.22,0.22), 18:(0.16,0.16), 19:(0.1,0.22),
    }
    create_creature("Partygoer_Stage6", joints, bones, radii, "Partygoer_Stage6.fbx", (0.88, 0.72, 0.18, 1.0), 0.45)

# ====================================================================
# 7. NIGHTMARE WENDIGO (APEX MUSCULAR ANTLERED HORROR)
# ====================================================================
def build_nightmare_wendigo():
    joints = {
        0: (0, 0, 1.8),   # Pelvis
        1: (0, 0.05, 2.6),# Waist
        2: (0, 0.15, 3.4),# Broad chest
        3: (0, 0.3, 4.3), # Muscular neck
        4: (0, 0.5, 5.0), # Beast Skull
        5: (0, 0.9, 4.8), # Gaping Maw
        # Branching Antlers
        6: (-0.45, 0.3, 5.6), 7: (-0.85, 0.1, 6.4), 8: (-1.2, -0.1, 7.2),
        9: (0.45, 0.3, 5.6), 10: (0.85, 0.1, 6.4), 11: (1.2, -0.1, 7.2),
        # Massive Arms & Talons
        12: (-1.0, 0.1, 3.5), 13: (-1.6, 0.2, 2.4), 14: (-2.1, 0.4, 1.4), 15: (-2.5, 0.6, 0.5),
        16: (1.0, 0.1, 3.5), 17: (1.6, 0.2, 2.4), 18: (2.1, 0.4, 1.4), 19: (2.5, 0.6, 0.5),
        # Heavy Digitigrade Hind Legs
        20: (-0.65, 0, 1.6), 21: (-0.75, -0.4, 0.8), 22: (-0.75, 0.1, 0.0), 23: (-0.75, 0.5, -0.2),
        24: (0.65, 0, 1.6), 25: (0.75, -0.4, 0.8), 26: (0.75, 0.1, 0.0), 27: (0.75, 0.5, -0.2),
    }
    bones = [
        (0,1),(1,2),(2,3),(3,4),(4,5),
        (4,6),(6,7),(7,8),
        (4,9),(9,10),(10,11),
        (2,12),(12,13),(13,14),(14,15),
        (2,16),(16,17),(17,18),(18,19),
        (0,20),(20,21),(21,22),(22,23),
        (0,24),(24,25),(25,26),(26,27),
    ]
    radii = {
        0:(0.52,0.42), 1:(0.45,0.35), 2:(0.75,0.5), 3:(0.32,0.32), 4:(0.55,0.6), 5:(0.35,0.3),
        6:(0.2,0.2), 7:(0.14,0.14), 8:(0.08,0.08),
        9:(0.2,0.2), 10:(0.14,0.14), 11:(0.08,0.08),
        12:(0.35,0.35), 13:(0.28,0.28), 14:(0.22,0.22), 15:(0.12,0.24),
        16:(0.35,0.35), 17:(0.28,0.28), 18:(0.22,0.22), 19:(0.12,0.24),
        20:(0.42,0.42), 21:(0.32,0.32), 22:(0.24,0.24), 23:(0.15,0.3),
        24:(0.42,0.42), 25:(0.32,0.32), 26:(0.24,0.24), 27:(0.15,0.3),
    }
    create_creature("NightmareWendigo_Stage7", joints, bones, radii, "NightmareWendigo_Stage7.fbx", (0.05, 0.04, 0.04, 1.0), 0.85)

if __name__ == "__main__":
    print(">>> SKELETAL SKIN CREATURE GENERATION STARTING...")
    build_bacteria()
    build_smiler()
    build_hydro_lurker()
    build_concrete_hound()
    build_shadow_strider()
    build_partygoer()
    build_nightmare_wendigo()
    print(">>> ALL 7 SKELETAL ORGANIC BIPED/QUADRUPED FBX MODELS GENERATED!")

