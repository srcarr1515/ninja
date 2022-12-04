shader_type canvas_item;

// 振動の強さ
uniform float shake_power = 0.03;
// 振動率
uniform float shake_rate : hint_range( 0.0, 1.0 ) = 0.2;
// 振動速度
uniform float shake_speed = 5.0;
// 振動ブロックサイズ
uniform float shake_block_size = 30.5;
// 色の分離率
uniform float shake_color_rate : hint_range( 0.0, 1.0 ) = 0.01;

uniform bool Smooth = true;
uniform float width : hint_range(0.0, 16) = 1.0;
uniform vec4 outline_color : hint_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform int pixel_size : hint_range(1, 10) = 4;


float random( float seed )
{
	return fract( 543.2543 * sin( dot( vec2( seed, seed ), vec2( 3525.46, -54.3415 ) ) ) );
}

void fragment( )
{
	
	float enable_shift = float(
		random( trunc( TIME * shake_speed ) )
	<	shake_rate
	);

	vec2 fixed_uv = UV;
	fixed_uv.x += (
		random(
			( trunc( UV.y * shake_block_size ) / shake_block_size )
		+	TIME
		) - 0.5
	) * shake_power * enable_shift;

	vec4 pixel_color = textureLod( TEXTURE, fixed_uv, 0.0 );
	pixel_color.r = mix(
		pixel_color.r
	,	textureLod( TEXTURE, fixed_uv + vec2( shake_color_rate, 0.0 ), 0.0 ).r
	,	enable_shift
	);
	pixel_color.b = mix(
		pixel_color.b
	,	textureLod( TEXTURE, fixed_uv + vec2( -shake_color_rate, 0.0 ), 0.0 ).b
	,	enable_shift
	);

	vec2 unit = (1.0/float(pixel_size) ) / vec2(textureSize(TEXTURE, 0));
	if (pixel_color.a == 0.0) {
		pixel_color = outline_color;
		pixel_color.a = 0.0;
		for (float x = -ceil(width); x <= ceil(width); x++) {
			for (float y = -ceil(width); y <= ceil(width); y++) {
				if (texture(TEXTURE, UV + vec2(x*unit.x, y*unit.y)).a == 0.0 || (x==0.0 && y==0.0)) {
					continue;
				}
				if (Smooth) {
					pixel_color.a += outline_color.a / (pow(x,2)+pow(y,2)) * (1.0-pow(2.0, -width));
					if (pixel_color.a > 1.0) {
						pixel_color.a = 1.0;
					}
				} else {
					pixel_color.a = outline_color.a;
					return
				}
			}
		}
	}
	
	
	
	
	COLOR = pixel_color;
}