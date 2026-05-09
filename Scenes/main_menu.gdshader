shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Slight screen curvature
    vec2 centered_uv = uv * 2.0 - 1.0;
    uv += centered_uv * (dot(centered_uv, centered_uv) * 0.05);

    vec4 color = texture(SCREEN_TEXTURE, uv);

    // Scanlines
    float scanline = sin(uv.y * 400.0) * 0.04;
    color.rgb -= scanline;

    // Faint static/grain
    float noise = (fract(sin(dot(uv + TIME, vec2(12.9898,78.233))) * 43758.5453) - 0.5) * 0.05;
    color.rgb += noise;

    // Vignette (dark corners)
    float vignette = smoothstep(0.6, 1.2, length(centered_uv));
    color.rgb -= vignette * 0.5;

    COLOR = color;
}