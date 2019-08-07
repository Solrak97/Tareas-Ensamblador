#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>

//Propiedades del Modulo
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Daniel Artavia Cordero, Gloriana Mora Villalta, Luis Carlos Quesada Rodriguez.");
MODULE_DESCRIPTION("Evaluador de funcion vectorial.");
MODULE_VERSION("1.0");

//Struct que se recibe de VFunctionDev
struct DatosVFunction {
    char funcion[75];
    float* puntos;
    float epsilon;
    int cantidad_rangos[2]; //0 para x, 1 para y
    float rangos[12];
    int funcionIdentificada[150];
};

//Funciones de ensamblador
//Retorna un codigo 0 o 1 en caso de error
//Ambas funciones reciben la direccion de memoria para escribir los puntos
//la funcion que recibe es de ints, ya que está identificada y las constantes pueden necesitar un dword.
//siempre hay intervalos para X
//Los intervalos son floats o ints?
extern simple_evaluation(int* funcion, float epsilon, int rangos_x, float* rangos, float* memoria);
extern double_evaluation(int* funcion, float epsilon, int rangos_x, int rangos_y, float* rangos, float* memoria);

//Funcion para procesar una estructura
int procesaEstructura(struct DatosVFunction* datos) {
    // En esta funcion se puede llamar a ensamblador.
	if(datos.cantidad_rangos[1] == 0){
		simple_evaluation(datos->funcionIdentificada, datos->epsilon, datos->rangos_x, datos->rangos, datos->puntos);
	}
	else{
		double_evaluation(datos->funcionIdentificada, datos->epsilon, datos->rangos_x, rangos_y, datos->rangos, datos->puntos);
	}
}
EXPORT_SYMBOL(procesaEstructura);

/*------------------------------INIT Y EXIT------------------------------*/
static int __init  vfunction_init(void){
 	printk(KERN_INFO "VFunction STARTED.\n");
 	return 0;
}

void __exit vfunction_exit(void){
 	printk(KERN_INFO "VFunction REMOVED.\n");
}

//	Module required functions
module_init(vfunction_init);
module_exit(vfunction_exit);
