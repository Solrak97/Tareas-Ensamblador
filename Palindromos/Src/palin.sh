# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-04-23T21:39:02-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: palin.sh
# @Last modified by:   solrak
# @Last modified time: 2019-04-28T15:44:06-06:00

#Conseguir el codigo de A
./parteA
parteA=$?

#Conseguir el codigoo de B
./parteB
parteB=$?

#Hacer Bitshift de 8 en A
results=$(( parteA << 8 ))

#Sumar A con B
results=$(( results + parteB ))

#print de los resultados
echo $results
