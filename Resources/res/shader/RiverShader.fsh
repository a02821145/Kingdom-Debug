#ifdef GL_ES
    precision lowp float;
#endif

varying vec2 v_texCoord;

uniform sampler2D u_texture;
uniform float u_time;

void main()
{
    // 按照纹理坐标和时间计算新的纹理坐标
    vec2 newTexCoord1 = vec2(v_texCoord.x+ (sin(u_time) * 0.1), v_texCoord.y);
    vec2 newTexCoord2 = vec2(-v_texCoord.x+ (sin(u_time) * 0.1), v_texCoord.y);

    // 获取纹理颜色
    vec4 color1 = texture2D(u_texture, newTexCoord1);
    vec4 color2 = texture2D(u_texture, newTexCoord);

    gl_FragColor = color;
}