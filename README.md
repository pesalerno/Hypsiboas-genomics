  # Hypsiboas-genomics
  
  
DEMULTIPLEXING
--------
Para el proceso de demultriplexing utilizamos el codigo 
*primero hacer un documento de texto separado por tabs en donde la primera columna se especifiquen los barcodes, en la segunda los primers y en la tercera los nombres de los individuos y guardarlo en formato unix.
*verificar que no hayan espacios o caracteres desconocidos asociados a los nombres (view-text display-show invisibles)

	process_radtags -p /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data -o /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data/prueba_dem -b /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data/demultiplex_todos2.txt -c -q -r --inline_index -- renz_1 sphI --renz_2 mspI


DENOVO MAP
------

Primero modificamos el archivo de excel en donde estaban los nombres de los individuos con sus poblaciones. En otra hoja del mismo libro copie los nombres de los individuos, tal y como esta en el archivo prueba\_dem (demultiplexed) y en otra columna pegue las especies de cada individuo. En una tercera columna concatene los nombres de los individuos con las 3 primeras letras de su respectiva especie para saber de que especie es cada individuo. Para cambiar los nombres de los individuos en el archivo prueba\_dem, en otra hoja del mismo libro, en la primera columna se coloca mv (move o cambiar) en la segunda los nombres que estaban en el archivo prueba\_dem y en la tercera columna los nombres con la especie (concatenadas) que se quiere cambiar. Se copian estas columnas al Text Wrangler y se ven los invisibles para que no hayan tabs (Replace tabs /t por espacios). Una vez este el texto sin espacios, se copia todo esto en el terminal (antes colocandose dentro de prueba\_dem) y automaticamente se cambian los nombres en este archivo.

Despues se hace un mapa de poblaciones (pop\_map) en excel, en donde la primera columna son los nombres de los individuos y en la segunda las poblaciones a las que pertenecen (los nombres de las poblaciones no pueden tener ningun espacio en medio). Esta tabla se copia en Text Wrangler y se quita el final de todos los nombres de los individuos (se reemplaza .fq.gz por nada). Esta tabla tiene que tener tabs entre las columnas. Este archivo se guarda como txt dentro de la carpeta raw-data: 

	/Users/claudiateran/desktop/Hypsiboas_ddRAD/raw-data

Por ultimo se crea una carpeta que se llama outputfolder dentro de raw-data:

	/Users/claudiateran/desktop/Hypsiboas_ddRAD/raw-data/outputfolder

Para correr denovo\_map, tengo que colocarme dentro de raw-data (cd raw-data) y copiar el siguiente enlace:

	denovo_map.pl -M 3 -n 2 -o ./outputfolder --popmap ./pop_map.txt --samples ./prueba_dem
	
	 
PRUEBAS DE GENOTIPIFICACION
------
permutations |	-m |	-M |	-n
-------------|------|------|-----
a	| 4 | 3 |	3 
b	| 4 | 3 | 4
c	| 4 | 3 | 2
d	| 4 | 4 | 3
e	| 4 | 4 | 4 
f	| 4 | 4 | 2
g	| 5 | 3 | 3
h	| 5 | 3 |	4
i	| 5 | 3 | 2
j 	| 5 | 4 |	3
k	| 5 | 4 | 4
l	| 5 | 4 | 2

Diseñamos una tabla con las combinaciones de los parámetros que vamos a utilizar.

Stacks esta diseñado para realizar estudios poblacionales. Por ese motivo se hizo un nuevo pop\_map solo con los individuos jimenezi el cual se llama pop\_map-jimmy.txt (se borran los individuos de otras especies).  

Creamos distintos archivos de texto en BBEdit con los comandos para correr el pop\_map con las distintas combinaciones de parametros.

Nos conectamos en el servidor de Colorado State University para correr las permutaciones. Exportamos el nuevo pop\_map y los archivos de las combinaciones de parametros al servidor (*.sh). 
Desde el terminal local: 

	scp pop_map-jimmy.txt salerno@correns.colostate.edu:/home/salerno/scratch_dir/hypsiboas/prueba_dem

	scp *.sh salerno@correns.colostate.edu:/home/salerno/scratch_dir/hypsiboas/prueba_dem
	
Se corre un archivo *.sh a la vez:

	sbatch denovo-m4M3n3.sh
	
Se prueba con `squeue` para ver si la corrida ya esta en fila para procesarse.	
	
En una tabla de excle pusimos los valores de los loci y los SNPs obtenidos en los archivos denovo para cada combinación de parámetros.	
	
	
POPULATIONS
-----
Con este programa de Stacks vamos a obtener las matrices de SNPs con los diferentes parámetros que hemos probado para el anàlisis de los datos. 

Primero modificamos el popmap para tener a todos los individuos como si vinieran de una sola población (no importa cual). 

Luego hicimos los documentos .sh con el código para correr el programa en cada cluster denovo-m?M?n?. 

Importar al corrents el nuevo popmap y los documentos .sh 
Se pueden importar varios archivos al mismo tiempo si tienen algo en común en su  nombre y añadiendo un * antes o después del común denominador.

	#!/bin/bash
	#
	#SBATCH --time=100:00:00
	#SBATCH --job-name=denovo-m4M3n2pop
	#SBATCH --mail-type=ALL
	#SBATCH --mail-user=patriciasalerno@gmail.com
	#SBATCH --error=stderr-denovo-m4M3n2pop
	#SBATCH --output=stdout-denovo-m4M3n2pop

	LD_LIBRARY_PATH=/opt/software/gcc-4.9.0/lib64/
	export LD_LIBRARY_PATH
	stacks-1.42

	/opt/software/stacks-2.0Beta7c/populations -P ./denovo-m4M3n2 --popmap ./pop_map-jimmy.txt -O ./denovo-m4M3n2 -p 1 -r 0.8 --write_random_snp --plink		
		
Este mismo comando se corrió para cada cluster.

Error:
El path de los directorios en el comando para correr populations, se debe tomar en cuenta que el punto que se pone al principio significa que el path comienza desde donde uno está en el terminal (no como si estuvieras en el desktop).


SELECCIÓN DE PARÁMETROS
------
Abrimos el population.log de cada cluster generado por el programa population. Copiamos el número de loci y SNPs kept bajo r 0.8 (se guardan los loci y SNPs que están en el 80% de los individuos). Con esta tabla hicimos dos gráficos, uno para los datos antes de correr populations y otro para los datos de r80. 

![fotito](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico1.png)


![fotito2](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico2.png)

De acuerdo a los resultados mostrados en los gráficos, vemos que disminuye el número de loci y SNPs obtenidos con m5 en comparación a m4 (m es la cantidad mínima de secuencias iguales para formar un stack). M (distancia permitida entre stacks de un mismo locus de un mismo individuo) no afecta en los resultados. Mientras n (distancia permitida entre indiviuos para un mismo locus) aumenta, se ve una disminución de loci y un aumento de SNPs (cambio esperado). En el gráfico de r80 vemos que en n3 hay un pequeño aumento de loci y SNPs, por este motivo hemos decidido aceptar la combinación: m4M3n3.

