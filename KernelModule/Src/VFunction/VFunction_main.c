#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>

//Propiedades del Modulo
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Daniel Artavia Cordero, Gloriana Mora Villalta, Luis Carlos Quesada Rodriguez.");
MODULE_DESCRIPTION("Evaluador de funcion vectorial.");
MODULE_VERSION("1.0");

//Struct que se recibe de VFunctionDev
typedef struct {
    char funcion[75];
    float* puntos;
    float epsilon;
    int cantidad_rangos[2]; //0 para x, 1 para y
    float rangos[12];
    int funcionIdentificada[150];
} DatosVFunction_t;


//Funciones de ensamblador
//Retorna un codigo 0 o 1 en caso de error
//Ambas funciones reciben la direccion de memoria para escribir los puntos
//la funcion que recibe es de ints, ya que está identificada y las constantes pueden necesitar un dword.
//siempre hay intervalos para X
//Los intervalos son floats o ints?
//extern int evaluacion(int* funcion, float* x_val, float* y_val, float* retorno);
extern void evaluacion(int* funcion, float* x, float* y, float* ret);
extern float sumaFloats(float* a, float* b);
//Metodo para copiar un vector de 8 flotantes
//Directamente en una ubicacion del vectorRetorno
//Llenando el vector de solucion en orden
//Parametros:
//from = Vector a copiar
//to = Vector a llenar
//p = posicion a escribir
void cpyTo(float* from, float* to, int p){
	int i = 0;
	while(i < 8){
		to[p] = from[i];
		i++;
		p++;
	}
}

//Funcion para obtener los 8 valores a colocar en valX
void getNumbers(float* valK, float epsilon, float lim_superior, float ultimo) {
    int i;
    /*int nan;
    nan = 2139095041;
    float nanFloat;
    nanFloat = (float)nan;*/
    for(i = 0; i < 8; ++i) {
		sumaFloats(&ultimo, &epsilon);
        if(ultimo <= lim_superior) {
            valK[i] = ultimo;
        } else {
            valK[i] = 0/0; //División entre cero (for the glory of Satan, of course!)
        }
    }
}

//Funcion para setear los valores de un intervalo
//Ya sea X o Y, dentro de los valores de los rangos
//Unidos de acuerdo a una cantidad de rangos
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

//Evaluacion de funciones con
//unica variable
void evaluacionSimple(int* funcion, float epsilon, int* cantidad, float* rangos, float* puntos){
	float valX[8];
	float valY[8] = {0,0,0,0,0,0,0,0};
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

//Evaluacion de funciones con
//doble variable
//Debe haber ciclo anidado para evaluacion de multiples Y en unico X
void evaluacionDoble(int* funcion, float epsilon, int* cantidad, float* rangos, float* puntos){
	float valY[8];
	float ret[8];
	int pRet = 0;
	int cantX, cantY;
	cantX = cantidad[0];
	cantY = cantidad[1];
	float ultX = rangos[0];
	int pRangos = 1;
	while(ultX <= rangos[cantX * 2 -1]){ //Setear condicion de avance en x
		float valX[8] = {ultX, ultX, ultX, ultX, ultX, ultX, ultX, ultX};
		float ultimo = rangos[0] - epsilon;
		while(ultimo <= rangos[cantY * 2 -1]){//Setear condicion de avance en y
			setInterv(valX, rangos, epsilon, ultimo , 'Y');
			evaluacion(funcion, valX, valY, ret);	//Evaluación de 8 elementos
	        ultimo = valY[7];						//seteo de ultimo
			cpyTo(valY, puntos, pRet);				//copia de datos a puntos
		}
		if (ultX < rangos[pRangos] && pRangos / 2 < cantX){
			ultX += epsilon;
		}
		else if (ultX >= rangos[pRangos] && pRangos / 2 < cantX) {
			pRangos += 2;
			ultX += rangos[pRangos - 1];
		}
		else{
			ultX += epsilon;	//Para obligar el caso de sobrepasar el while
		}
	}
}

//Funcion para procesar una estructura
//Recibe una estructurade tipo DatosVFunction
//Retorna un vector de enteros que contiene
//Todos los puntos evaluado en el dominio
//Definido para una funcion parametro
int procesaEstructura(DatosVFunction_t* datos) {
	if(datos->cantidad_rangos[1] == 0){ //Funcion tiene una variable
		evaluacionSimple(datos->funcionIdentificada, datos->epsilon, datos->cantidad_rangos, datos->rangos, datos->puntos);
	}
	else{								//Funcion tiene 2 variables
		evaluacionDoble(datos->funcionIdentificada, datos->epsilon, datos->cantidad_rangos, datos->rangos, datos->puntos);
	}
	return 0;
}


EXPORT_SYMBOL(procesaEstructura);

/*------------------------------INIT Y EXIT------------------------------*/
static int vfunction_init(void){
 	printk(KERN_INFO "VFunction STARTED.\n");
 	return 0;
}

static void vfunction_exit(void){
 	printk(KERN_INFO "VFunction REMOVED.\n");
}

//	Module required functions
module_init(vfunction_init);
module_exit(vfunction_exit);
