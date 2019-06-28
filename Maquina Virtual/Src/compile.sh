# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-04-23T19:19:44-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: compile.sh
# @Last modified by:   solrak
# @Last modified time: 2019-05-06T00:18:26-06:00


yasm -g dwarf2 -f elf64 logica.asm -l logica.lst
if [ $? = 0 ]
then
  echo "> Logica ensamblada"
  yasm -g dwarf2 -f elf64 maquina_virtual.asm -l maquina.lst
  if [ $? = 0 ]
  then
    echo "> Maquina Virtual ensamblada"
    ld -o maquina_virtual maquina_virtual.o logica.o
    if [ $? = 0 ]
    then
      echo "> Proyecto linkeado"
    else
      echo "> El proyecto no se ha linkeado correctamente"
    fi
  else
    "> La maquina virtual no se ha ensamblado correctamente"
  fi
else
  echo "> La logica no se ha ensamblado correctamente"
fi
