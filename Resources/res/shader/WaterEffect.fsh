uniform sampler2D u_texture;
uniform vec4 _BaseColor;
uniform vec4 _WaveBaseColor;
uniform float timeDelta;
varying vec2 v_texCoord;

 vec4 waveColor(vec2 uv) {
    float tilling = 1.0;
    float speed = 0.03;

    vec2 offset = vec2(1, 0) * speed * timeDelta;
    vec4 wColor1 = texture(u_texture, uv * tilling + offset);
    vec4 wColor2 = texture(u_texture, -uv * tilling + offset);
    vec4 wColor = min(wColor1, wColor2);

    wColor = wColor * _WaveBaseColor;

    float stren = 2.0;

    return wColor * stren;
  }


void main()
{
    vec4 col = _BaseColor; // 叠加上水面的本来的颜色

    vec4 wColor = waveColor(v_texCoord);
    col = col + wColor;

    gl_FragColor = col;
}

