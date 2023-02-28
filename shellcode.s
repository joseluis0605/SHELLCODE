####### PRACTICA 2 ############

.global _start #indicar donde empieza la ejecucion del programa


# INFORMACION A TENER EN CUENTA
# PATH: "/etc/passwd" --> 2f 65 74 63 2f 70 61 73 / 73 77 64
# buffer --> 64 

.text
_start:

### PASOS ####
# 1: OPEN
# 2: READ
# 3: WRITE

#PREPARAMOS EL PATH Y EL BUFFER

#BUFFER:
	movq %rsp, %r14 #r14 es puntero a buffer
	sub $8, %rsp #ya tenemos reservado el espacio de 8 bytes al buffer
	
#PATH

	movq $0x7361702f6374652f, %r12 #contiene /etc/pas 
	movq $0X647773ff, %r13 #contiene swd
	shr $8, %r13
	push %r13
	push %r12
	#ya tenemos metidos los elementos en la pila, metiendo "f" hasta completar los 8 bytes
	

##### OPEN FILE #####

	movq $0x2fffffffffffffff, %rax #especificamos que queremos abrir fichero
	shr $60, %rax
	movq %rsp, %rdi  #path que se encuentra en la pila
	xorq %rbx, %rbx
	movq %rbx, %rsi    #flag O_RDONLY solo lectura
	syscall
	
	movq %rax, %r15  #almaceno el file descriptor de nuestro fichero abierto en el $r15
	
	xorq %rbx, %rbx
	cmp %rbx, %rax
	jl fin
while: 	
	

##### READ FILE ######
	
	xorq %rbx, %rbx
	mov %rbx,%rax #especificamos que queremos leer
	mov %r15, %rdi #metemos el file descriptor, que es del rax al abrir
	mov %r14, %rsi #metemos el buffer
	mov $0x8fffffffffffffff, %rdx #indicamos el tamaño de lectura
	shr $60, %rdx
	
	syscall

####### COMPARACION SI LECTURA DEVUELVE 0, NO LEE NADA

if:
	xorq %rbx, %rbx
	cmp %rbx, %rax 
	je fin
	
##### HACEMOS EL WRITE #####
	
	mov $0x1fffffffffffffff, %rax #indicamos que es escritura
	shr $60, %rax
	mov $0x1fffffffffffffff, %rdi #indicamos el file descriptor, es decir, 1 para el output
	shr $60, %rdi
	mov %r14, %rsi #metemos nuestro buffer de 64bytes
	mov $0x8fffffffffffffff, %rdx #indicamos el tamaño del buffer nuestro
	shr $60, %rdx
	syscall
	
	jmp while
	
fin:

	mov $0x3cffffffffffffff, %rax #llamada al sistema para cerrar
	shr $56, %rax
	xorq %rbx, %rbx
	mov %rbx, %rdi #0 --> todo OK
	syscall

	
