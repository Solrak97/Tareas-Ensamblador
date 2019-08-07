#include "vfunction_dev.h"

/*------------------------------FOPS------------------------------*/
static int vfunction_dev_open(struct inode *inode, struct file *file) {
    //No interesa que haga nada
    return 0;
}

static int vfunction_dev_release(struct inode *inode, struct file *file) {
    //No interesa que haga nada
    return 0;
}

static ssize_t vfunction_dev_read(struct file *filp, char __user *buf, size_t len, loff_t *off) {
    int ret;
    ret = -1;

    if(puntos != NULL) {
        //Casting de char a float
        float* puntos_ptr;
        puntos_ptr = (float*)buf;

        //Copia los puntos
        copy_to_user(puntos_ptr, puntos, len);

        ret = 0;
    }

    return ret;
}

//EN ESTA FUNCION SE REALIZAN LAS COMPROBACIONES Y SE MANDAN LOS DATOS A VFUNCTION
static ssize_t vfunction_dev_write(struct file *filp, const char __user *buf, size_t len, loff_t *off) {
    int ret;
    int i;

    DatosVFunction_t* datos_ptr;
    DatosVFunction_t datos;
    float* puntos_ptr;

    //Cast de char* a struct DatosVFunction*
    datos_ptr = (DatosVFunction_t*)buf;

    //Copia el struct
    copy_from_user(&datos, datos_ptr, len);

    //Valida el dominio para X
    ret = 0;
    for(i = 0; i < datos.cantidad_rangos[0] && !ret; ++i) {
        ret = verificaErrores(datos.funcion, datos.epsilon, datos.rangos[2*i], datos.rangos[2*i+1]);
    }
    //Valida el dominio para Y si corresponde
    if(datos.cantidad_rangos[1]) {
        for(i = 0; i < datos.cantidad_rangos[0] && !ret; ++i) {
            ret = verificaErrores(datos.funcion, datos.epsilon, datos.rangos[2*i+6], datos.rangos[2*i+7]);
        }
    }

    if(!ret) { //Si no hay errores
        //Cast de unsigned long int a float*
        puntos_ptr = (float*)datos.puntos;

        //Reserva la memoria para puntos
        puntos = vmalloc(3276800 * sizeof(float));

        //Copia el arreglo de puntos a la memoria de kernel
        copy_from_user(puntos, puntos_ptr, 3276800 * sizeof(float));

        //Identifica la funcion
        identifica(datos.funcion, datos.funcionIdentificada);

        //Acá debería llamar a VFunction
        ret = procesaEstructura(&datos);
        if(ret != 0) {
            puntos = NULL;
        }
    }

    return ret;
}


/*------------------------------INIT Y EXIT------------------------------*/
//Funciones de init y exit
static int __init vfunction_dev_init(void) {
    int ret = 0;
    printk(KERN_INFO "Iniciando modulo vfunction_dev \n");

    //Reserva un 'major number'
    if((alloc_chrdev_region(&dev, 0, 1, "vfunction_Dev")) < 0) {
        printk(KERN_ERR "No se pudo asignar un 'major number' \n");
        ret = -1;
    }

    //Crea la estructura cdev (character device)
    cdev_init(&vfunction_dev_cdev, &vfunction_dev_fops);

    //Agrega el cdev al sistema
    if(!ret) {
        if((cdev_add(&vfunction_dev_cdev, dev, 1)) < 0){
            printk(KERN_ERR "No se ha podido crear el dispositivo de caracteres (cdev) \n");
            unregister_chrdev_region(dev, 1);
            ret = -1;
        }
    }
    //Crea la estructura de clase del dispositivo
    if(!ret) {
        if((dev_class = class_create(THIS_MODULE, "vfunction_class")) == NULL) {
            printk(KERN_ERR "No se pudo crear la estructura de clase \n");
            class_destroy(dev_class);
            unregister_chrdev_region(dev, 1);
            ret = -1;
        }
    }
    //Crea el dispositivo
    if(!ret) {
        if((device_create(dev_class, NULL, dev, NULL, "vfunction_dev")) == NULL) {
            printk(KERN_ERR "No se pudo crear el dispositivo \n");
            unregister_chrdev_region(dev, 1);
            ret = -1;
        }
    }

    return ret;
}

void __exit vfunction_dev_exit(void) {
    if(puntos != NULL) {
        vfree(puntos); //Limpia la memoria
    }
    device_destroy(dev_class, dev); //Destruye el dispositivo
    class_destroy(dev_class); //Destruye la clase
    cdev_del(&vfunction_dev_cdev); //Destruye el dispositivo de caracteres (cdev)
    unregister_chrdev_region(dev, 1); //Desregistra el dispositivo
    printk(KERN_INFO "Cerrando modulo vfunction_dev \n");
}

module_init(vfunction_dev_init);
module_exit(vfunction_dev_exit);
