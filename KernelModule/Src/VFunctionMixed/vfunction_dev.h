#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/kdev_t.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

//Estructura para datos
typedef struct {
    char funcion[75];
    float* puntos;
    float epsilon;
    int cantidad_rangos[2]; //0 para x, 1 para y
    float rangos[12];
    int funcionIdentificada[150];
} DatosVFunction_t;

//Funciones de ensamblador
extern int verificaErrores(char*, float, float, float);
extern void identifica(char*, int*);

//Funciones de VFunction
extern int procesaEstructura(DatosVFunction_t*);

//Propiedades del Modulo
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Daniel Artavia Cordero, Gloriana Mora Villalta, Luis Carlos Quesada Rodriguez");
MODULE_DESCRIPTION("Driver para VFunction");
MODULE_VERSION("1.0");

//Declaraciones del dispositivo
dev_t dev = 0;
static struct class *dev_class;
static struct cdev vfunction_dev_cdev;

//Puntero a puntos que serán retornados
float* puntos = NULL;

//Declaracion de la funciones de vfunction_dev
static int __init vfunction_dev_init(void);
static void __exit vfunction_dev_exit(void);
static int vfunction_dev_open(struct inode *inode, struct file *file);
static int vfunction_dev_release(struct inode *inode, struct file *file);
static ssize_t vfunction_dev_read(struct file *filp, char __user *buf, size_t len,loff_t * off);
static ssize_t vfunction_dev_write(struct file *filp, const char *buf, size_t len, loff_t * off);

//Definicion de las fops (file operation structures) de vfunction_dev
static struct file_operations vfunction_dev_fops = {
    .owner = THIS_MODULE,
    .read = vfunction_dev_read,
    .write = vfunction_dev_write,
    .open = vfunction_dev_open,
    .release = vfunction_dev_release,
};
