#include <math.h>
#include <stdio.h>

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

extern void evaluacion(int* funcion, float* x, float* y, float* ret);

void cpyTo(float* from, float* to, int p){
	int i = 0;
	while(i < 8){
		to[p] = from[i];
		i++;
		p++;
	}
}

void getNumbers(float* valK, float epsilon, float lim_superior, float ultimo) {
    for(int i = 0; i < 8; ++i) {
		ultimo += epsilon;
        if(ultimo <= lim_superior) {
            valK[i] = ultimo;
        } else {
            valK[i] = NAN; //División entre cero (for the glory of Satan, of course!)
        }
    }
}

void setInterv(float* valK, float* rangos, float epsilon, float ultimo, char v) {
    if(v == 'x') { //Para X
        if(ultimo <= rangos[1]) { //Si x pertence al primer intervalo
            getNumbers(valK, epsilon, rangos[1], ultimo);
        } else {
            if(ultimo <= rangos[3]) { //Si x pertence al segundo intervalo
                getNumbers(valK, epsilon, rangos[3], ultimo);
            } else { //Si x pertence al tercer intervalo
                getNumbers(valK, epsilon, rangos[5], ultimo);
            }
        }
    } else { //Para Y
        if(ultimo <= rangos[7]) { //Si x pertence al primer intervalo
            getNumbers(valK, epsilon, rangos[7], ultimo);
        } else {
            if(ultimo <= rangos[9]) { //Si x pertence al segundo intervalo
                getNumbers(valK, epsilon, rangos[9], ultimo);
            } else { //Si x pertence al tercer intervalo
                getNumbers(valK, epsilon, rangos[11], ultimo);
            }
        }
    }
}

void evaluacionSimple(int* funcion, float epsilon, int* cantidad, float* rangos, float* puntos){
	float valX[8];
	float valY[8] = {0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
	float ret[8];
	int cantX = cantidad[0];
	int pRet = 0;
    float ultimo = rangos[0] - epsilon; //Primer elemento del primer rango
	while(ultimo <= rangos[cantX * 2 - 1]){ //Último elemento del último rango
        setInterv(valX, rangos, epsilon, ultimo , 'x');
		evaluacion(funcion, valX, valY, ret);	//Evaluación de 8 elementos
        ultimo = valX[7];						//seteo de ultimo
		cpyTo(ret, puntos, pRet);				//copia de datos a puntos
		pRet += 8;
	}
}

int VFunction(DatosVFunction_t* datos) {
    evaluacionSimple(datos->funcionIdentificada, datos->epsilon, datos->cantidad_rangos, datos->rangos, datos->puntos);
    return 0;
}
