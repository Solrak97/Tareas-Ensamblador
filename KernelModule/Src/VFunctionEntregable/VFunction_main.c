#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

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
extern int evaluacion_simple(int* funcion, float epsilon, int rangos_x, float* rangos, float* memoria);

//Funcion para procesar una estructura
int procesaEstructura(DatosVFunction_t* datos) {
    int ret;
    // En esta funcion se puede llamar a ensamblador.
	if(datos->cantidad_rangos[1] == 0){
        printk(KERN_INFO "Holi :)");
		evaluacion_simple(datos->funcionIdentificada, datos->epsilon, datos->cantidad_rangos[0], datos->rangos, datos->puntos);
	} else {
        printk(KERN_INFO "No holi");
	}
    ret = 0;
    return ret;
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
