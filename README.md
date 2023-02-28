# SHELLCODE
Convierte el programa ensamblador del ejercicio anterior en shellcode. Se presentan 2 archivos .s, en donde uno es la solución con 
ceros al pasarlo a formato hexadecimal y el otro .s corresponde a la solucion sin ceros.

No es obligatorio generar shellcode sin bytes a cero, pero no se podrá alcanzar la máxima nota si el shellcode contiene bytes a cero.

Hay que probar el shellcode creado con el siguiente programa en C:

--------------------------------------------

#include <sys/mman.h>

 enum{
     Pagesz = 4*1024,
 };

char code[] = {
    // Aquí va tu shellcode como un array de chars
    0xe8, 0x0c, 0x00, 0x00, ...
};

int
main(int argc, char** argv)
{
    int (*f)() = (int(*)())code;
    void *addr =  (void*)((unsigned long long)f / Pagesz * Pagesz);
    mprotect(addr, Pagesz, PROT_READ|PROT_WRITE|PROT_EXEC);
    f();
}

--------------------------------------------

El programa se debe compilar de esta forma:

gcc test.c -g -o test

Hay que entregar dos ficheros:

    un fichero shellcode.s (con el ensamblador del shellcode)
    un fichero test.c listo para probar el shellcode del fichero anterior.

El shellcode y el programa test deben funcionar en la máquina virtual que puedes descargar de aquí:

http://gsyc.urjc.es/~esoriano/smalldebian.ova

Puedes importar ese fichero en Virtual Box. Ese sistema tiene creado un usuario llamado mal (su contraseña es el nombre de usuario: mal). Puedes intercambiar ficheros usando el comando scp desde dentro de la máquina virtual (la IP de la máquina host suele ser 10.0.2.2) para probar si funciona. En realidad, es un sistema Linux AMD64 (Debian) convencional.

Un ejemplo de ejecución:

$ ./test
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
...
$
