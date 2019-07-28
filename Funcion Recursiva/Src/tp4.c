#include <stdio.h>


//void fun(int n){
//    if(n > 0){
//        fun(n-1);
//        printf("%d ", n);
//        fun(n-1);
//    }
//}


extern void fun(int n);

int main() {
    fun(4);
    return 0;
}
