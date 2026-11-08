"""
========================================================================================
BROTHER STUDIO PRODUCTIONS — OFFICIAL 100% BLENDER 5.2.3 LTS FBX EXPORTER
EXPORTS ALL 7 SCULPTED BACKROOMS ENTITIES AS HIGH-FIDELITY .FBX FOR ROBLOX 3D IMPORTER
========================================================================================
"""
import bpy
import math
import os

OUTPUT_DIR = r"C:\Users\andra\Downloads\BrotherHub_Project\CustomBlenderAssets"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def reset_blender():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    for c in list(bpy.data.collections):
        bpy.data.collections.remove(c)

def create_pbr_material(name, color_rgba, roughness=0.5, emission_rgba=(0,0,0,1), emission_strength=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    nodes.clear()
    
    bsdf = nodes.new(type='ShaderNodeBsdfPrincipled')
    bsdf.location = (0, 0)
    bsdf.inputs['Base Color'].default_value = color_rgba
    bsdf.inputs['Roughness'].default_value = roughness
    if emission_strength > 0:
        if 'Emission Color' in bsdf.inputs:
            bsdf.inputs['Emission Color'].default_value = emission_rgba
            bsdf.inputs['Emission Strength'].default_value = emission_strength
            
    out = nodes.new(type='ShaderNodeOutputMaterial')
    out.location = (300, 0)
    mat.node_tree.links.new(bsdf.outputs['BSDF'], out.inputs['Surface'])
    return mat

def export_fbx(filename):
    filepath = os.path.join(OUTPUT_DIR, filename)
    bpy.ops.export_scene.fbx(
        filepath=filepath,
        use_selection=False,
        global_scale=1.0,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_ALL',
        mesh_smooth_type='FACE'
    )
    print(f"[FBX] Exported: {filepath}")

# 1. BACTERIA
def make_bacteria_fbx():
    reset_blender()
    mat_black = create_pbr_material("BacteriaSinew", (0.02, 0.02, 0.02, 1.0), roughness=0.9)
    mat_red = create_pbr_material("BacteriaCore", (0.9, 0.05, 0.05, 1.0), roughness=0.2, emission_rgba=(1,0.05,0.05,1), emission_strength=5.0)

    # Spine S-Curve
    bpy.ops.mesh.primitive_cylinder_add(radius=0.22, depth=4.6, location=(0, 0, 3.2))
    spine = bpy.context.active_object
    spine.data.materials.append(mat_black)
    
    for i in range(8):
        z = 1.8 + (i * 0.4)
        r = 0.7 - (abs(i - 4) * 0.08)
        bpy.ops.mesh.primitive_torus_add(major_radius=r, minor_radius=0.08, location=(0, 0.15, z), rotation=(1.57, 0, 0))
        bpy.context.active_object.data.materials.append(mat_black)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.5, location=(0, 0.35, 5.6))
    head = bpy.context.active_object
    head.scale = (0.75, 1.2, 1.4)
    head.data.materials.append(mat_black)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=2.8, location=(side * 1.0, 0.2, 3.8), rotation=(0.2, side * 0.3, side * 0.35))
        bpy.context.active_object.data.materials.append(mat_black)
        bpy.ops.mesh.primitive_cone_add(radius1=0.14, radius2=0.01, depth=3.2, location=(side * 1.8, 0.6, 2.0), rotation=(0.5, side * -0.2, side * 0.5))
        bpy.context.active_object.data.materials.append(mat_black)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=3.2, location=(side * 0.55, -0.2, 1.6), rotation=(-0.15, side * 0.1, 0))
        bpy.context.active_object.data.materials.append(mat_black)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("Bacteria_Stage1.fbx")

# 2. SMILER
def make_smiler_fbx():
    reset_blender()
    mat_void = create_pbr_material("SmilerVoid", (0.01, 0.01, 0.01, 1.0), roughness=0.98)
    mat_glow = create_pbr_material("SmilerGlow", (0.95, 0.98, 1.0, 1.0), roughness=0.05, emission_rgba=(0.95, 0.98, 1.0, 1.0), emission_strength=8.0)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.3, location=(0, 0, 2.6))
    body = bpy.context.active_object
    body.scale = (1.1, 0.8, 1.4)
    body.data.materials.append(mat_void)

    for i in range(11):
        angle = -1.2 + (i * 0.24)
        x = math.sin(angle) * 0.85
        y = -0.75 + (abs(angle) * 0.25)
        z = 2.4 - (math.cos(angle) * 0.15)
        bpy.ops.mesh.primitive_cone_add(radius1=0.06, depth=0.25, location=(x, y, z), rotation=(1.57, angle * 0.5, 0))
        bpy.context.active_object.data.materials.append(mat_glow)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_uv_sphere_add(radius=0.2, location=(side * 0.42, -0.75, 3.1))
        eye = bpy.context.active_object
        eye.scale = (1.3, 0.4, 1.0)
        eye.data.materials.append(mat_glow)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("Smiler_Stage2.fbx")

# 3. HYDRO LURKER
def make_hydro_fbx():
    reset_blender()
    mat_aquatic = create_pbr_material("HydroPaleSkin", (0.75, 0.88, 0.88, 1.0), roughness=0.15)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.38, depth=3.4, location=(0, 0, 2.2))
    torso = bpy.context.active_object
    torso.scale = (0.9, 0.6, 1.1)
    torso.data.materials.append(mat_aquatic)

    bpy.ops.mesh.primitive_cone_add(radius1=0.35, depth=1.8, location=(0, 0.38, 2.4), rotation=(-0.4, 0, 0))
    bpy.context.active_object.data.materials.append(mat_aquatic)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.45, location=(0, -0.15, 3.9))
    head = bpy.context.active_object
    head.scale = (0.7, 1.4, 0.9)
    head.data.materials.append(mat_aquatic)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=2.8, location=(side * 0.75, -0.1, 2.0), rotation=(0.2, side * 0.2, side * 0.3))
        bpy.context.active_object.data.materials.append(mat_aquatic)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.13, depth=3.0, location=(side * 0.45, 0, 0.9), rotation=(-0.1, side * 0.05, 0))
        bpy.context.active_object.data.materials.append(mat_aquatic)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("HydroStalker_Stage3.fbx")

# 4. CONCRETE HOUND
def make_hound_fbx():
    reset_blender()
    mat_stone = create_pbr_material("ConcreteRoughStone", (0.35, 0.35, 0.36, 1.0), roughness=0.88)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.48, depth=3.0, location=(0, 0, 1.4), rotation=(1.57, 0, 0))
    torso = bpy.context.active_object
    torso.scale = (0.9, 1.0, 1.2)
    torso.data.materials.append(mat_stone)

    for i in range(6):
        y = -0.9 + (i * 0.36)
        bpy.ops.mesh.primitive_cone_add(radius1=0.16, depth=0.5, location=(0, y, 1.9), rotation=(0.2, 0, 0))
        bpy.context.active_object.data.materials.append(mat_stone)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.45, location=(0, -1.7, 1.6))
    skull = bpy.context.active_object
    skull.scale = (0.8, 1.3, 0.9)
    skull.data.materials.append(mat_stone)

    for x, y in [(-0.55, -0.9), (0.55, -0.9), (-0.55, 0.9), (0.55, 0.9)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=1.6, location=(x, y, 0.75), rotation=(0.2 if y < 0 else -0.2, 0, 0))
        bpy.context.active_object.data.materials.append(mat_stone)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("ConcreteHound_Stage4.fbx")

# 5. SHADOW STRIDER
def make_strider_fbx():
    reset_blender()
    mat_decay = create_pbr_material("StriderDecayedSkin", (0.15, 0.14, 0.13, 1.0), roughness=0.75)
    bpy.ops.mesh.primitive_cylinder_add(radius=0.32, depth=3.8, location=(0, 0, 3.6), rotation=(0.3, 0, 0))
    torso = bpy.context.active_object
    torso.scale = (0.8, 0.6, 1.2)
    torso.data.materials.append(mat_decay)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.45, location=(0, -0.4, 5.4))
    head = bpy.context.active_object
    head.scale = (0.7, 1.1, 1.4)
    head.data.materials.append(mat_decay)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=4.0, location=(side * 0.8, -0.2, 2.6), rotation=(0.15, side * 0.1, side * 0.15))
        bpy.context.active_object.data.materials.append(mat_decay)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.13, depth=3.8, location=(side * 0.48, 0.2, 1.6), rotation=(-0.2, side * 0.05, 0))
        bpy.context.active_object.data.materials.append(mat_decay)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("ShadowStrider_Stage5.fbx")

# 6. PARTYGOER
def make_partygoer_fbx():
    reset_blender()
    mat_yellow = create_pbr_material("PartygoerYellow", (0.88, 0.72, 0.18, 1.0), roughness=0.45)
    mat_balloon = create_pbr_material("RedBalloon", (0.9, 0.08, 0.08, 1.0), roughness=0.15)

    bpy.ops.mesh.primitive_cylinder_add(radius=0.4, depth=3.0, location=(0, 0, 2.8))
    torso = bpy.context.active_object
    torso.scale = (1.0, 0.75, 1.1)
    torso.data.materials.append(mat_yellow)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.48, location=(0, 0, 4.5))
    head = bpy.context.active_object
    head.scale = (0.85, 1.0, 1.15)
    head.data.materials.append(mat_yellow)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=2.5, location=(side * 0.7, 0, 2.7), rotation=(0, 0, side * 0.15))
        bpy.context.active_object.data.materials.append(mat_yellow)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.13, depth=2.5, location=(side * 0.38, 0, 1.1))
        bpy.context.active_object.data.materials.append(mat_yellow)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.48, location=(0.9, -0.4, 5.8))
    balloon = bpy.context.active_object
    balloon.scale = (1.0, 1.0, 1.3)
    balloon.data.materials.append(mat_balloon)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("Partygoer_Stage6.fbx")

# 7. NIGHTMARE WENDIGO
def make_wendigo_fbx():
    reset_blender()
    mat_beast = create_pbr_material("WendigoApexFur", (0.05, 0.04, 0.04, 1.0), roughness=0.85)
    mat_bone = create_pbr_material("WendigoAntlerBone", (0.85, 0.82, 0.75, 1.0), roughness=0.55)

    bpy.ops.mesh.primitive_cylinder_add(radius=0.58, depth=4.0, location=(0, 0, 3.6), rotation=(0.15, 0, 0))
    torso = bpy.context.active_object
    torso.scale = (1.2, 0.85, 1.2)
    torso.data.materials.append(mat_beast)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.52, location=(0, -0.3, 5.6))
    skull = bpy.context.active_object
    skull.scale = (0.75, 1.6, 0.9)
    skull.data.materials.append(mat_beast)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=2.2, location=(side * 0.5, -0.1, 6.6), rotation=(-0.3, side * 0.45, side * 0.6))
        bpy.context.active_object.data.materials.append(mat_bone)
        for t in range(3):
            bpy.ops.mesh.primitive_cone_add(radius1=0.07, depth=1.0, location=(side * (0.65 + t * 0.3), -0.2, 6.2 + t * 0.4), rotation=(-0.4, side * 0.3, side * -0.5))
            bpy.context.active_object.data.materials.append(mat_bone)

    for side in (-1, 1):
        bpy.ops.mesh.primitive_cylinder_add(radius=0.2, depth=3.6, location=(side * 1.2, -0.1, 3.4), rotation=(0.2, side * 0.25, side * 0.3))
        bpy.context.active_object.data.materials.append(mat_beast)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.24, depth=2.6, location=(side * 0.65, 0.2, 2.2), rotation=(-0.35, side * 0.1, 0))
        bpy.context.active_object.data.materials.append(mat_beast)
        bpy.ops.mesh.primitive_cylinder_add(radius=0.2, depth=2.4, location=(side * 0.65, -0.3, 0.9), rotation=(0.3, side * 0.1, 0))
        bpy.context.active_object.data.materials.append(mat_beast)

    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.join()
    export_fbx("NightmareWendigo_Stage7.fbx")

if __name__ == "__main__":
    print(">>> EXPORTING ALL 7 BACKROOMS ENTITIES AS FBX...")
    make_bacteria_fbx()
    make_smiler_fbx()
    make_hydro_fbx()
    make_hound_fbx()
    make_strider_fbx()
    make_partygoer_fbx()
    make_wendigo_fbx()
    print(">>> 100% COMPLETE! All 7 FBX files exported to CustomBlenderAssets/")

