#include <fcntl.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CANTIDAD_PUNTOS 3276800

typedef struct {
    char funcion[75];
    float* puntos;
    float epsilon;
    int cantidad_rangos[2]; //0 para x, 1 para y
    float rangos[12];
    int funcionIdentificada[150];
} DatosVFunction_t;

void obtieneRangosX(DatosVFunction_t* fun) {
    char cont;
    fun->cantidad_rangos[0] = 1;
    printf("Ingrese un limite inferior para el dominio de 'x': ");
    scanf("%f", &fun->rangos[0]);
    printf("Ingrese un limite superior para el dominio de 'x': ");
    scanf("%f", &fun->rangos[1]);
    printf("Desea agregar un segundo intervalo? [S/n]: ");
    scanf(" %c", &cont);
    if(cont == 's' || cont == 'S') {
        ++fun->cantidad_rangos[0];
        printf("Ingrese un limite inferior para el dominio de 'x': ");
        scanf("%f", &fun->rangos[2]);
        printf("Ingrese un limite superior para el dominio de 'x': ");
        scanf("%f", &fun->rangos[3]);
        cont = 0;
        printf("Desea agregar un tercer intervalo? [S/n]: ");
        scanf(" %c", &cont);
        if(cont == 's' || cont == 'S') {
            ++fun->cantidad_rangos[0];
            printf("Ingrese un limite inferior para el dominio de 'x': ");
            scanf("%f", &fun->rangos[4]);
            printf("Ingrese un limite superior para el dominio de 'x': ");
            scanf("%f", &fun->rangos[5]);
        }
    }
}

void obtieneRangosY(DatosVFunction_t* fun) {
    char cont;
    fun->cantidad_rangos[1] = 1;
    printf("Ingrese un limite inferior para el dominio de 'y': ");
    scanf("%f", &fun->rangos[6]);
    printf("Ingrese un limite superior para el dominio de 'y': ");
    scanf("%f", &fun->rangos[7]);
    printf("Desea agregar un segundo intervalo? [S/n]: ");
    scanf(" %c", &cont);
    if(cont == 's' || cont == 'S') {
        ++fun->cantidad_rangos[1];
        printf("Ingrese un limite inferior para el dominio de 'y': ");
        scanf("%f", &fun->rangos[8]);
        printf("Ingrese un limite superior para el dominio de 'y': ");
        scanf("%f", &fun->rangos[9]);
        cont = 0;
        printf("Desea agregar un tercer intervalo? [S/n]: ");
        scanf(" %c", &cont);
        if(cont == 's' || cont == 'S') {
            ++fun->cantidad_rangos[1];
            printf("Ingrese un limite inferior para el dominio de 'y': ");
            scanf("%f", &fun->rangos[10]);
            printf("Ingrese un limite superior para el dominio de 'y': ");
            scanf("%f", &fun->rangos[11]);
        }
    }
}

void numeroError(char* ret, int numero) {
    switch (numero) {
        case 1:
            strcpy(ret, "Error: hay una cantidad invalida de terminos.\n\0");
            break;
        case 2:
            strcpy(ret, "Error: a las funciones trigonometricas solo les puede seguir una varible\n\0");
            break;
        case 3:
            strcpy(ret, "Error: uno de los terminos no tiene suficientes operandos.\n\0");
            break;
        case 4:
            strcpy(ret, "Error: no puede haber dos operadores contiguos.\n\0");
            break;
        case 5:
            strcpy(ret, "Error: se han detectado variables diferentes a 'x' y 'y'.\n\0");
            break;
        case 6:
            strcpy(ret, "Error: las constantes no pueden tener mas de 7 digitos.\n\0");
            break;
        case 7:
            strcpy(ret, "Error: su funcion debe comenzar con una constante o una variable.\n\0");
            break;
        case 8:
            strcpy(ret, "Error: hay una cantidad invalida de elementos en los terminos.\n\0");
            break;
        case 9:
            strcpy(ret, "Error: el valor 'epsilon' escogido no es lo suficientemente grande para el dominio.\n\0");
            break;
        default:
            break;
    }
}

int main() {
    //Inicializa las variables y estructuras necesarias
    char mensaje[150];
    int ok = 0;
    int error = 0;
    char terceraDimension;
    char* dosVariables;
    DatosVFunction_t fun1;
    DatosVFunction_t fun2;
    DatosVFunction_t fun3;
    char* fun1char = (char*)&fun1;
    char* fun2char = (char*)&fun2;
    char* fun3char = (char*)&fun3;
    float* puntos = (float*)malloc(sizeof(float) * CANTIDAD_PUNTOS); //12.5MB de puntos
    for(int i = 0; i < CANTIDAD_PUNTOS; ++i) {
        puntos[i] = NAN;
    }
    char* puntosChar = (char*)puntos;
    //Reutiliza la memoria
    fun1.puntos = puntos;
    fun2.puntos = puntos;
    fun3.puntos = puntos;

    //Abre la comunicación con el 'device driver'
    int dispositivo = open("/dev/vfunction_dev", O_RDWR|O_EXCL);
    int wr;
    int rd;

    //Para el manejo de los archivos de texto
    FILE* archivoTexto;
    archivoTexto = fopen(".VFunctionEjeX.txt", "w");

    if(dispositivo >= 0) { //Si hay comunicación con el dispositivo
        //Interactua con el usuario
        printf("Bienvenido, usuario. Ingrese una funcion vectorial para graficarla.\n");
        printf("Comienze por ingresar un numero 'epsilon' en el que incrementaran las funciones luego de cada operacion: ");
        scanf("%f", &fun1.epsilon);
        //FUNCION 1 (EJE X)
        while(!ok && !error) {
            //Pregunta por la primera función
            printf("Ingrese una funcion para el eje X: ");
            scanf("%s", &fun1.funcion);

            //Pregunta por los intervalos para x
            obtieneRangosX(&fun1);

            //Revisa si hay una variable 'y' en la función
            dosVariables = strchr(fun1.funcion, 'y');
            if(dosVariables != NULL) {
                obtieneRangosY(&fun1);
            } else {
                fun1.cantidad_rangos[1] = 0;
            }

            //Envía los datos al dispositivo
            wr = write(dispositivo, fun1char, sizeof(DatosVFunction_t));
            if(!wr) {
                ok = 1;
            } else {
                numeroError(mensaje, wr);
                printf("%s", mensaje);
            }

            //Lee la respuesta del dispositivo
            rd = read(dispositivo, puntosChar, sizeof(float) * CANTIDAD_PUNTOS);
            if(!rd) { //Si todo salió bien
                for(int i = 0; i < CANTIDAD_PUNTOS; ++i) { //Escribe los puntos en un arhcivo de texto
                    if(puntos[i] != NAN) {
                        fprintf(archivoTexto, "%f\n", puntos[i]);
                    }
                }
                fclose(archivoTexto);
            } else {
                printf("Error desconocido durante el procesamiento de la funcion. Saliendo...\n");
                close(dispositivo);
                error = 1;
                ok = 1;
            }
        }
        ok = 0;

        while(!ok && !error) {
            //FUNCION 2 (EJE Y)
            //Pregunta por la segunda función
            printf("Ingrese una funcion para el eje Y: ");
            scanf("%s", &fun2.funcion);

            //Usa los rangos para 'x' de la primera función
            fun2.cantidad_rangos[0] = fun1.cantidad_rangos[0];
            fun2.rangos[0] = fun1.rangos[0];
            fun2.rangos[1] = fun1.rangos[1];
            fun2.rangos[2] = fun1.rangos[2];
            fun2.rangos[3] = fun1.rangos[3];
            fun2.rangos[4] = fun1.rangos[4];
            fun2.rangos[5] = fun1.rangos[5];

            //Revisa si hay una variable 'y' en la función
            dosVariables = strchr(fun2.funcion, 'y');
            if(dosVariables != NULL) {
                if(fun1.cantidad_rangos[1]) { //Si la funcion 1 tenía dos variable, usa los rangos de la primera funcion
                    fun2.cantidad_rangos[1] = fun1.cantidad_rangos[1];
                    fun2.rangos[6] = fun1.rangos[6];
                    fun2.rangos[7] = fun1.rangos[7];
                    fun2.rangos[8] = fun1.rangos[8];
                    fun2.rangos[9] = fun1.rangos[9];
                    fun2.rangos[10] = fun1.rangos[10];
                    fun2.rangos[11] = fun1.rangos[11];
                } else {
                    obtieneRangosY(&fun2);
                }
            } else {
                fun2.cantidad_rangos[1] = 0;
            }

            //Envía los datos al dispositivo
            wr = write(dispositivo, fun2char, sizeof(DatosVFunction_t));
            if(!wr) {
                ok = 1;
            } else {
                numeroError(mensaje, wr);
                printf("%s", mensaje);
            }

            //Lee la respuesta del dispositivo
            archivoTexto = fopen(".VFunctionEjeY.txt", "w");
            rd = read(dispositivo, puntosChar, sizeof(float) * CANTIDAD_PUNTOS);
            if(!rd) { //Si todo salió bien
                for(int i = 0; i < CANTIDAD_PUNTOS; ++i) { //Escribe los puntos en un arhcivo de texto
                    if(puntos[i] != NAN) {
                        fprintf(archivoTexto, "%f\n", puntos[i]);
                    }
                }
                fclose(archivoTexto);
            } else {
                printf("Error desconocido en el procesamiento de la funcion. Saliendo...\n");
                close(dispositivo);
                error = 1;
                ok = 1;
            }
        }
        ok = 0;

        //Pregunta si se quiere agregar una tercera dimensión
        if(!error) {
            printf("Desea graficar una tercera dimension? [S/n]: ");
            scanf(" %c", &terceraDimension);
        }
        if((terceraDimension == 's' || terceraDimension == 'S') && !error) {
            while(!ok && !error) {
                //FUNCION 3 (EJE Z)
                //Pregunta por la tercera función
                printf("Ingrese una funcion para el eje Z: ");
                scanf("%s", &fun3.funcion);

                //Usa los rangos para 'x' de la segunda función
                fun2.cantidad_rangos[0] = fun2.cantidad_rangos[0];
                fun3.rangos[0] = fun2.rangos[0];
                fun3.rangos[1] = fun2.rangos[1];
                fun3.rangos[2] = fun2.rangos[2];
                fun3.rangos[3] = fun2.rangos[3];
                fun3.rangos[4] = fun2.rangos[4];
                fun3.rangos[5] = fun2.rangos[5];

                //Revisa si hay una variable 'y' en la función
                dosVariables = strchr(fun3.funcion, 'y');
                if(dosVariables != NULL) {
                    if(fun2.cantidad_rangos[1]) { //Si la funcion 2 tiene dos variables, usa sus rangos
                        fun3.cantidad_rangos[1] = fun2.cantidad_rangos[1];
                        fun3.rangos[6] = fun1.rangos[6];
                        fun3.rangos[7] = fun1.rangos[7];
                        fun3.rangos[8] = fun1.rangos[8];
                        fun3.rangos[9] = fun1.rangos[9];
                        fun3.rangos[10] = fun1.rangos[10];
                        fun3.rangos[11] = fun1.rangos[11];
                    } else {
                        obtieneRangosY(&fun3);
                    }
                }

                //Envía los datos al dispositivo
                wr = write(dispositivo, fun3char, sizeof(DatosVFunction_t));
                if(!wr) {
                    ok = 1;
                } else {
                    numeroError(mensaje, wr);
                    printf("%s", mensaje);
                }

                //Lee la respuesta del dispositivo
                archivoTexto = fopen(".VFunctionEjeZ.txt", "w");
                rd = read(dispositivo, puntosChar, sizeof(float) * CANTIDAD_PUNTOS);
                if(!rd) { //Si todo salió bien
                    for(int i = 0; i < CANTIDAD_PUNTOS; ++i) { //Escribe los puntos en un arhcivo de texto
                        if(puntos[i] != NAN) {
                            fprintf(archivoTexto, "%f\n", puntos[i]);
                        }
                    }
                    fclose(archivoTexto);
                } else {
                    printf("Error desconocido en el procesamiento de la funcion. Saliendo...\n");
                    close(dispositivo);
                    error = 1;
                    ok = 1;
                }
            }
        }
        close(dispositivo);
        if(!error) {
            //Grafica si no hay errores
            printf("Graficando... \n");
            //Llama a octave
            if(terceraDimension == 's' || terceraDimension == 'S') {
                system("octave tresDimensiones.m");
            } else {
                system("octave dosDimensiones.m");
            }
        }
        //Limpia los archivos de texto una vez sale de octave
        system("rm .VFunctionEjeX.txt .VFunctionEjeY.txt .VFunctionEjeZ.txt &> /dev/null");
    } else {
        printf("No se ha podido conectar al dispositivo. Verifique que el modulo este cargado.\n");
    }
    free(puntos);
}
