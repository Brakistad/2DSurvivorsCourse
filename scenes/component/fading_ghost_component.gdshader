shader_type canvas_item;

uniform float invisibilty : hint_range(0.0, 1.0) = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
	// Fade visibilty
	COLOR.a *= (1.0 - invisibilty);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
