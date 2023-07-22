#ifdef GL_ES
precision lowp float;
#endif

varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform float u_time;

void main()
{
    vec2 uv = v_texCoord.xy;
    uv.y += sin(uv.x * 10.0 + u_time * 2.0) * 0.04; // 调整波浪效果的强度和频率
    uv.x += cos(uv.y * 10.0 + u_time * 1.5) * 0.03;

    vec4 color = texture2D(u_texture, uv);
    gl_FragColor = color;
}