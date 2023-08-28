#ifdef GL_ES
    precision lowp float;
#endif
 
varying vec2 v_texCoord;
 
void main()
{
    vec2 vecDelta = abs(v_texCoord - vec2(0.5,0.5));
    float distance = length(v_texCoord - vec2(0.5,0.5));
    float a = 0.0;
    if(distance < 0.1) a = 1.0;
    if(distance > 0.1 && distance <= 0.5) a = 1.0-(distance-0.1)*2.2;
    gl_FragColor = vec4(0.0, 0.0, 0.0, a);
}