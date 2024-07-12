-- Constants for weapon hints display
WEAPON_ALTFIRE_HUD_HINT_COUNT = 1
WEAPON_RELOAD_HUD_HINT_COUNT = 1

-- Start with a constraint in place (don't drop to floor)
SF_WEAPON_START_CONSTRAINED = 0
SF_WEAPON_NO_PLAYER_PICKUP = 1
SF_WEAPON_NO_PHYSCANNON_PUNT = 2

-- Clip percentage threshold
CLIP_PERC_THRESHOLD = 0.75

-- -----------------------------------------
-- Vector cones
-- -----------------------------------------

-- VECTOR_CONE_PRECALCULATED - resolves to vec3_origin but indicates that 
-- FireBullets() should not modify the shot direction, as it has already 
-- been modified by another piece of code. See GetActualShotTrajectory().
VECTOR_CONE_PRECALCULATED = vec3_origin
vec3_origin = vector_origin
vec3_angle = Angle(0, 0, 0)

-- The way these are calculated is that each component == sin(degrees/2)
VECTOR_CONE_1DEGREE = Vector(0.00873, 0.00873, 0.00873)
VECTOR_CONE_2DEGREES = Vector(0.01745, 0.01745, 0.01745)
VECTOR_CONE_3DEGREES = Vector(0.02618, 0.02618, 0.02618)
VECTOR_CONE_4DEGREES = Vector(0.03490, 0.03490, 0.03490)
VECTOR_CONE_5DEGREES = Vector(0.04362, 0.04362, 0.04362)
VECTOR_CONE_6DEGREES = Vector(0.05234, 0.05234, 0.05234)
VECTOR_CONE_7DEGREES = Vector(0.06105, 0.06105, 0.06105)
VECTOR_CONE_8DEGREES = Vector(0.06976, 0.06976, 0.06976)
VECTOR_CONE_9DEGREES = Vector(0.07846, 0.07846, 0.07846)
VECTOR_CONE_10DEGREES = Vector(0.08716, 0.08716, 0.08716)
VECTOR_CONE_15DEGREES = Vector(0.13053, 0.13053, 0.13053)
VECTOR_CONE_20DEGREES = Vector(0.17365, 0.17365, 0.17365)
