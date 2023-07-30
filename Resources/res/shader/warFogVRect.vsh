#ifdef GL_ES
    precision lowp float;
#endif
 
varying vec2 v_texCoord;
 
void main()
{
    vec2 vecDelta = abs(v_texCoord - vec2(0.5,0.5));
    float distance = length(vecDelta);

    float a = 0.0;
    if(vecDelta.x < 0.45 || vecDelta.y < 0.45 ) a = 1.0;
    if(vecDelta.x >= 0.45 || vecDelta.y >= 0.45) a = 1.0-(distance-0.45)*2.2;

    gl_FragColor = vec4(0.0, 0.0, 0.0, a);
}