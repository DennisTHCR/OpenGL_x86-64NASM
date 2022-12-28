; uninitialized
section .bss
align 8
window resq 1
VBO resd 1
VAO resd 1
EBO resd 1
vertexShader resd 1
fragmentShader resd 1
shaderProgram resd 1
height resd 1
width resd 1
texture1 resd 1
texture2 resd 1
textureWidth resd 1
textureHeight resd 1
nrChannels resd 1
shader resb 4096
data resb 1166400

; initialized
section .rodata
%include "./includes.asm"
%include "./macros.asm"
%include "./constants.asm"
align 8
shaderAddress dq shader
clearCol dd 0.2
onef dd 1.0
vertices dd 0.5, 0.5, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.5, -0.5, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, -0.5, -0.5, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, -0.5, -0.5, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, -0.5, 0.5, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0
indices dd 0, 1, 3, 1, 2, 3
texCoords dd 0.0, 0.0, 1.0, 0.0, 0.5, 1.0

; strings
title db "OpenGL in ASM",0
vertexSource db "./shader.vert", 0
fragmentSource db "./shader.frag", 0
textureSource1 db "/home/dennis/projects/assembly/OpenGL_x86-64NASM/tex1.jpg", 0
textureSource2 db "/home/dennis/projects/assembly/OpenGL_x86-64NASM/tex2.png", 0
; instructions
section .text
; imports
; main function
global main
main:
	openGLInit

	; create vertex shader
	initializeShader vertexSource, GL_VERTEX_SHADER, vertexShader
	
	; create fragment shader
	initializeShader fragmentSource, GL_FRAGMENT_SHADER, fragmentShader

	; glCreateProgram()
	call [glad_glCreateProgram]
	mov [shaderProgram], rax

	; glAttachShader(shaderProgram, vertexShader)
	mov rdi, [shaderProgram]
	mov rsi, [vertexShader]
	call [glad_glAttachShader]

	; glAttachShader(shaderProgram, fragmentShader)
	mov rdi, [shaderProgram]
	mov rsi, [fragmentShader]
	call [glad_glAttachShader]

	; glLinkProgram(shaderProgram)
	mov rdi, [shaderProgram]
	call [glad_glLinkProgram]

	; delete shaders
	mov rdi, [vertexShader]
	call [glad_glDeleteShader]

	mov rdi, [fragmentShader]
	call [glad_glDeleteShader]
	
	; glGenVertexArrays(1, pointer to VAO)
	mov rdi, 1
	mov rsi, VAO
	call [glad_glGenVertexArrays]

	; glBindVertexArray(VAO)
	mov rdi, [VAO]
	call [glad_glBindVertexArray]

	; glGenBuffers(1, pointer to VBO)
	mov rdi, 1
	mov rsi, VBO
	call [glad_glGenBuffers]

	; glBindBuffer(GL_ARRAY_BUFFER, VBO)
	mov rdi, [GL_ARRAY_BUFFER]
	mov rsi, [VBO]
	call [glad_glBindBuffer]

	; glBufferData(GL_ARRAY_BUFFER, sizeof(vertices) = 4*12, pointer to vertices, GL_STATIC_DRAW)
	mov rdi, [GL_ARRAY_BUFFER]
	mov rsi, 4*18
	mov rdx, vertices
	mov rcx, [GL_STATIC_DRAW]
	call [glad_glBufferData]

	; glGenBuffers(1, pointer to EBO)
	mov rdi, 1
	mov rsi, EBO
	call [glad_glGenBuffers]

	; glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO)
	mov rdi, [GL_ELEMENT_ARRAY_BUFFER]
	mov rsi, [EBO]
	call [glad_glBindBuffer]

	; glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices) = 4*6, pointer to indices, GL_STATIC_DRAW)
	mov rdi, [GL_ELEMENT_ARRAY_BUFFER]
	mov rsi, 4*3
	mov rdx, indices
	mov rcx, [GL_STATIC_DRAW]
	call [glad_glBufferData]


	; glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8 * sizeof(float) = 24, NULL)
	mov rdi, 0
	mov rsi, 3
	mov rdx, [GL_FLOAT]
	mov rcx, [GL_FALSE]
	mov r8, 8 * 4
	mov r9, 0
	call [glad_glVertexAttribPointer]
	; glEnableVertexAttribArray(0)
	mov rdi, 0
	call [glad_glEnableVertexAttribArray]
	; glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE, 8 * sizeof(float), 3 * sizeof(float)
	mov rdi,1
	mov rsi, 3
	mov rdx, [GL_FLOAT]
	mov rcx, [GL_FALSE]
	mov r8, 8 * 4
	mov r9, 3 * 4
	call [glad_glVertexAttribPointer]
	mov rdi, 1
	call [glad_glEnableVertexAttribArray]
	; glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8 * sizeof(float), 6 * sizeof(float))
	mov rdi, 2
	mov rsi, 2
	mov rdx, [GL_FLOAT]
	mov rcx, [GL_FALSE]
	mov r8, 8 * 4
	mov r9, 6 * 4
	call [glad_glVertexAttribPointer]
	mov rdi, 2
	call [glad_glEnableVertexAttribArray]

	; glBindBuffer(GL_ARRAY_BUFFER, 0)
	mov rdi, [GL_ARRAY_BUFFER]
	mov rsi, 0
	call [glad_glBindBuffer]

	; generate textures

	; glGenTextures(1, &texture1)
	mov rdi, 1
	mov rsi, texture1
	call [glad_glGenTextures]

	; glBindTexture(GL_TEXTURE_2D, texture1)
	mov rdi, [GL_TEXTURE_2D]
	mov rsi, [texture1]
	call [glad_glBindTexture]

	; glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,T, GL_REPEAT)
	mov rdi, [GL_TEXTURE_2D]
	mov rsi, [GL_TEXTURE_WRAP_S]
	mov rdx, [GL_REPEAT]
	call [glad_glTexParameteri]
	mov rdi, [GL_TEXTURE_2D]
	mov rsi, [GL_TEXTURE_WRAP_T]
	mov rdx, [GL_REPEAT]
	call [glad_glTexParameteri]

	; texture filtering
	mov rdi, [GL_TEXTURE_2D]
	mov rsi, [GL_TEXTURE_MIN_FILTER]
	mov rdx, [GL_LINEAR]
	call [glad_glTexParameteri]
	mov rdi, [GL_TEXTURE_2D]
	mov rsi, [GL_TEXTURE_MAG_FILTER]
	mov rdx, [GL_LINEAR]
	call [glad_glTexParameteri]

	; load image, create texture, generate mipmaps
	mov rdi, 1
	call stbi_set_flip_vertically_on_load
	
	; load texture
	;
	;
	;TODO implement texture loading using stbi
	;
	;
	; glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, data)
	mov rdi, [GL_TEXTURE_2D]
	xor rsi, rsi
	mov rdx, [GL_RGB]
	mov rcx, [width]
	mov r8, [height]
	mov r9, 0
	push GL_RGB
	push GL_UNSIGNED_BYTE
	push data
	call [glad_glTexImage2D]
	pop rax
	pop rax
	pop rax

	; glGenerateMipmap(GL_TEXTURE_2D)
	mov rdi, [GL_TEXTURE_2D]
	call [glad_glGenerateMipmap]
	

mainLoop:
	; glClearColor(r = 0.2, g = 0.2, b = 0.2, a = 1.0)
	movss xmm0, [clearCol]
	movss xmm1, xmm0
	movss xmm2, xmm0
	movss xmm3, [onef]
	call [glad_glClearColor]

	; glClear(GL_COLOR_BUFFER_BIT)
	mov rdi, [GL_COLOR_BUFFER_BIT]
	call [glad_glClear]

	; glUseProgram(shaderProgram)
	mov rdi, [shaderProgram]
	call [glad_glUseProgram]

	; glBindVertexArray(VAO)
	mov rdi, [VAO]
	call [glad_glBindVertexArray]

	; glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0)
	mov rdi, [GL_TRIANGLES]
	mov rsi, 6
	mov rdx, [GL_UNSIGNED_INT]
	mov rcx, 0
	call [glad_glDrawElements]

	; glfwPollEvents()
	call glfwPollEvents

	; glfwSwapBuffers(window)
	mov rdi, [window]
	call glfwSwapBuffers


	; if esc is pressed, quit
	mov rdi, [window]
	mov rsi, [KEY_ESC]
	call glfwGetKey
	cmp rax, 1
	je quit

	; glfwWindowShouldClose(window)
	mov rdi, [window]
	call glfwWindowShouldClose
	
	; if it shouldn't, go back to mainLoop, if it shoud, go on
	cmp rax, 0
	je mainLoop
; function quit()
quit:
	call glfwTerminate
	mov rax, 60
	xor rdi, rdi
	syscall

; framebuffer_size_callback(window, width, height)
framebuffer_size_callback:
	sub rsp, 8
	mov rcx, rdx
	mov rdx, rsi
	xor rsi, rsi
	xor rdi, rdi
	; glViewport(0,0, width, height)
	call [glad_glViewport]
	add rsp, 8
	ret
