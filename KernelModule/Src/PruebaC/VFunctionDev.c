#include <fcntl.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifndef CANTIDAD_PUNTOS
#define CANTIDAD_PUNTOS 3276800
#endif

//Estructura para datos
typedef struct {
    char funcion[75];
    float* puntos;
    float epsilon;
    int cantidad_rangos[2]; //0 para x, 1 para y
    float rangos[12];
    int funcionIdentificada[150];
} DatosVFunction_t;

extern int verificaErrores(char*, float, float, float);
extern void identifica(char*, int*);
extern int VFunction(DatosVFunction_t*);

int VFunctionDev_escribe(DatosVFunction_t* datos) {
    int ret = 0;

    //Hace una sumatoria de los rangos
    float rangosX = datos->rangos[1] - datos->rangos[0];
    rangosX += datos->rangos[3] - datos->rangos[2];
    rangosX += datos->rangos[5] - datos->rangos[4];
    ret = verificaErrores(datos->funcion, datos->epsilon, 0.0, rangosX);

    if(!ret) {
        for(int i = 0; i < 150; ++i) {
            datos->funcionIdentificada[i] = 0;
        }
        identifica(datos->funcion, datos->funcionIdentificada);
    }

    if(!ret) {
        //Llama a VFunction
        VFunction(datos);
    }

    //free(puntos_dev);
    return ret;
}
