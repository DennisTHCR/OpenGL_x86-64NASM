#version 330 core
out vec4 FragColor;
in vec3, position;
void main()
{
	FragColor = vec4(position.x, position.y, 1.0, 1.0);
}
