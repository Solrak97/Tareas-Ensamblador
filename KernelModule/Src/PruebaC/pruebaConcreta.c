extern void evaluacion(int* funcion, float* x, float* y, float* ret);

int main() {
    //2*x+3
    int funcion[15] = {1,2,3,42,2,120,3,43,1,3,0,0,0,0,0};
    float x[8] = {0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8};
    float y[8] = {0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};
    float ret[8];
    evaluacion(funcion, x, y, ret);
    return 0;
}
