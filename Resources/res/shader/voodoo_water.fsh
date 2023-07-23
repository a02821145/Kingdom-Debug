#ifdef GL_ES
precision mediump float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform float u_time;
uniform vec2 u_resolution;
varying vec2 base_color;

void main()
{
    // 对纹理坐标进行扭曲
    vec2 distortion1 = vec2(sin(v_texCoord.y * u_resolution.y / 100.0 + u_time), 0.0);
    vec2 distortion2 = vec2(-sin(v_texCoord.y * u_resolution.y / 100.0 + u_time), 0.0);

    // 根据扭曲坐标采样纹理
    vec4 color1 = texture(u_texture, v_texCoord + distortion1)*vec4(1,1.5,3,1);
    vec4 color2 = texture(u_texture, v_texCoord + distortion2)*vec4(1,1.5,3,1);

    gl_FragColor = color1 * color2;
}