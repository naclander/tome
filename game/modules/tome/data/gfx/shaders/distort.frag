uniform sampler2D tex;
uniform float tick;
uniform sampler2D mainfbo;
uniform vec2 texSize;
uniform float power;
uniform float power_time;
uniform float blacken;

void main(void)
{
	float distortionPower = power * cos(tick / power_time);
	vec3 distortionColor = texture2D(tex, gl_TexCoord[0].xy);
	vec2 distortionOffset = vec2(distortionColor.r - 0.5f, distortionColor.g - 0.5f) * distortionPower;
	gl_FragColor = texture2D(mainfbo, gl_FragCoord.xy / texSize.xy + distortionOffset.xy) * (1.0 - length(distortionOffset) * blacken);
}
