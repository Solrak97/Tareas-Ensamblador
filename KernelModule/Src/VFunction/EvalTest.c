<<<<<<< Updated upstream
#include<stdio.h>
=======
#include <stdio.h>

>>>>>>> Stashed changes
extern void evaluacion(int* funcion, float* x, float* y, float* ret);

int main() {
    //2*x+3
    int funcion[15] = {1,2,3,42,2,120,3,43,1,3,3,43,2,120,0};
    float x[8] = {0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8};
    float y[8] = {0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
    float ret[8];
    evaluacion(funcion, x, y, ret);
<<<<<<< Updated upstream

	for (int i = 0; i < 8; i++){
		printf("%f\n", ret[i]);
	}
=======
    for(int i = 0; i < 8; ++i) {
        printf("%f\n", ret[i]);
    }
>>>>>>> Stashed changes
    return 0;
}
