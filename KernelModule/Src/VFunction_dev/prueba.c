#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

struct Direcciones {
    char funcion[75];
    unsigned long int puntos;
    int dosRangos;
    float epsilon;
    float rangos[4];
    int funcionIdentificada[150];
};

int main() {
    unsigned int i;
    char funcion[] = "2*x+y+10-5/sx\0";

    //Reserva 12.5MB de floats y los inicializa en NaN
    float* puntos = (float*)malloc(3276800 * sizeof(float)); //12.5MB de floats
    for(i = 0; i < 3276800; ++i) {
        puntos[i] = NAN;
    }

    printf("La funcion ingresada es: %s\n", funcion);

    float rangos[4];
    rangos[0] = 1.0;
    rangos[1] = 2.0;
    rangos[2] = 3.0;
    rangos[3] = 4.0;

    struct Direcciones direcciones;
    strcpy(direcciones.funcion, funcion);
    memcpy(&direcciones.rangos, rangos, sizeof(rangos));
    direcciones.dosRangos = 0;
    direcciones.epsilon = 0.001;
    direcciones.puntos = (unsigned long int)puntos;
    direcciones.funcionIdentificada;

    //Convierte el struct a char*
    char* direcciones_char;
    direcciones_char = (char*)&direcciones;

    //Envia el struct al device driver
    int fd = open("/dev/vfunction_dev", O_RDWR | O_EXCL);
    int wr = write(fd, direcciones_char, sizeof(struct Direcciones));
    if(!wr) {
        printf("VFunctionDev: No ha ocurrido ningun error en la funcion o rangos :)\n");
    } else {
        printf("VFunctionDev: C mamut :v\n");
    }

    if(!wr) {
        //Convierte el arreglo de puntos a arreglo de char
        char* puntos_char;
        puntos_char = (char*)puntos;

        //Lee el arreglo de puntos del driver
        int rd = read(fd, puntos_char, 3276800 * sizeof(float));
        if(!rd) {
            printf("VFunctionDev: Se pudo leer bien el resultado\n");
        } else {
            printf("VFunctionDev: C marmota :v\n");
        }
    }
    close(fd);

    //Limpia la memoria
    free(puntos);
}
