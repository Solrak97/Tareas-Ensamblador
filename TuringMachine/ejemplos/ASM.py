# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-05-02T12:32:58-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: ASM.py
# @Last modified by:   solrak
# @Last modified time: 2019-05-02T16:13:37-06:00


salida = open('div3_hex.txt', 'w')
path = "div3_bin.txt"
with open(path) as file:
    salida.write('v2.0 raw\n')
    for line in file:
        hexline = hex(int(line, 2))[2:] + '\n'
        salida.write(hexline)
