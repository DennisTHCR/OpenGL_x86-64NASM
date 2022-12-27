; initializeShader(file, type, &shader (int))
%macro initializeShader 3
	; load shader into buffer
	mov rax, 2 ; the "open" syscall
	mov rdi, %1 ; path
	xor rsi, rsi ; flags (0 = readonly)
	syscall

	mov rdi, rax ; move the file descriptor (result from last operation)
	xor rax, rax ; the "read" syscall = 0
	mov rsi, shader ; address of buffer
	mov rdx, 4096 ; size of the buffer
	syscall
	
	lea rdx, [shader + rax]
	mov [rdx], byte 0

	mov rdx, rax ; rax contains the number of bytes read, move it to rdx for the amount of characters to write
	mov rax, 1 ; the "write" syscall
	mov rdi, 1 ; file descriptor of stdout
	mov rsi, shader ; address of the buffer
	syscall

	; shader = glCreateShader(type) 
	mov rdi, [%2]
	call [glad_glCreateShader]
	mov [%3], rax

	; glShaderSource(shader (int), 1, pointer to pointer to source, NULL)
	mov rdi, [%3]
	mov rsi, 1
	mov rdx, shaderAddress
	xor rcx, rcx
	call [glad_glShaderSource]

	; glCompileShader(shader (int))
	mov rdi, [%3]
	call [glad_glCompileShader]
%endmacro

%macro openGLInit 0
	xor rsp, 8
	; glfwInit()
	call glfwInit

	; glfwCreateWindow(width = 800, height = 600, title = pointer to "OpenGL in ASM", 0, 0)
	mov rdi, 800
	mov rsi, 600
	mov rdx, title
	xor rcx, rcx
	xor r8, r8
	call glfwCreateWindow

	; move return value into window
	; window = glfwCreateWindow(w, h, title, idk, idk)
	mov [window], rax
	
	; glfwMakeContextCurrent(qword window)
	mov rdi, [window]
	call glfwMakeContextCurrent

	; gladLoadGLLoader(pointer to glfwGetProcAddress())
	mov rdi, glfwGetProcAddress
	call gladLoadGLLoader

	; glClearColor(r = 0.2, g = 0.2, b = 0.2, a = 1.0)
	movss xmm0, [clearCol]
	movss xmm1, xmm0
	movss xmm2, xmm0
	movss xmm3, [onef]
	call [glad_glClearColor]

	; glViewport(x = 0, y = 0, w = 800, h = 600)
	mov rdi, 0
	mov rsi, 0
	mov rdx, 800
	mov rcx, 600
	call [glad_glViewport]

	; glfwSetFramebufferSizeCallback(window = [window], callback = pointer to framebuffer_size_callback)
	mov rdi, [window]
	mov rsi, framebuffer_size_callback
	call glfwSetFramebufferSizeCallback
	
%endmacro
