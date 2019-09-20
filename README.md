#1. DEMULTIPLEXING


 
>primero se debe hacer un documento de texto separado por tabs en donde la primera columna se especifiquen los barcodes, en la segunda los primers y en la tercera los nombres de los individuos y guardarlo en formato unix. Verificar que no hayan espacios o caracteres desconocidos asociados a los nombres (view>text display>show invisibles)


Para el proceso de demultiplexing utilizamos el codigo:

	process_radtags -p /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data -o /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data/prueba_dem -b /Users/bioweb/Desktop/MINGA_genomica_2019/Hypsiboas_ddRAD/raw-data/demultiplex_todos2.txt -c -q -r --inline_index -- renz_1 sphI --renz_2 mspI


#2. DENOVO MAP | Pruebas genotipificación



**1.1. Preparando archivos para genotipificación**

Primero modificamos el archivo de excel en donde estaban los nombres de los individuos con sus poblaciones. En otra hoja del mismo libro copie los nombres de los individuos, tal y como esta en el archivo prueba\_dem (demultiplexed) y en otra columna pegue las especies de cada individuo. En una tercera columna concatene los nombres de los individuos con las 3 primeras letras de su respectiva especie para saber de que especie es cada individuo. Para cambiar los nombres de los individuos en el archivo prueba\_dem, en otra hoja del mismo libro, en la primera columna se coloca mv (move o cambiar) en la segunda los nombres que estaban en el archivo prueba\_dem y en la tercera columna los nombres con la especie (concatenadas) que se quiere cambiar. Se copian estas columnas al Text Wrangler y se ven los invisibles para que no hayan tabs haciendo 

	Find /t
	Replace (nothing)
	
Una vez este el texto sin espacios, se copia todo esto en el terminal (antes colocandose dentro de prueba\_dem) y automaticamente se cambian los nombres en este archivo.

Despues se hace un mapa de poblaciones (pop\_map) en excel, en donde la primera columna son los nombres de los individuos y en la segunda las poblaciones a las que pertenecen (los nombres de las poblaciones no pueden tener ningun espacio en medio). Esta tabla se copia en Text Wrangler y se quita el final de todos los nombres de los individuos (se reemplaza .fq.gz por nada). Esta tabla tiene que tener tabs entre las columnas. Este archivo se guarda como `.txt` dentro de la carpeta `raw-data`: 

	/Users/claudiateran/desktop/Hypsiboas_ddRAD/raw-data

Por ultimo se crea una carpeta que se llama `outputfolder` dentro de `raw-data`:

	/Users/claudiateran/desktop/Hypsiboas_ddRAD/raw-data/outputfolder

Para correr **denovo\_map**, tengo que colocarme dentro de `raw-data`y usar la siguiente linea de codigo:

	cd raw-data
	denovo_map.pl -M 3 -n 2 -o ./outputfolder --popmap ./pop_map.txt --samples ./prueba_dem
	
	 
**1.2. PRUEBAS DE GENOTIPIFICACION**

Primero hicimos pruebas de genotipificación utilizando unicamente la especie de interes principal, *H. Jimenezi*, y luego hicimos las mismas pruebas de genotipificacion pero con todas las especies, y variando un poco el parametro n (entre las dos pruebas) para tomar en cuenta la diferencia de divergencia entre los dos sets de datos. 

**1.2.1. Pruebas solo con *H. jimenezi*.** Diseñamos una tabla con las combinaciones de los parámetros que vamos a utilizar.


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


Stacks esta diseñado para realizar estudios poblacionales. Por ese motivo se hizo un nuevo **pop\_map** solo con los individuos *H. jimenezi* el cual se llama `pop\_map-jimmy.txt` (se borran los individuos de otras especies).  

Creamos distintos archivos de texto en BBEdit con los comandos para correr el **pop\_map** con las distintas combinaciones de parametros.

Nos conectamos en el servidor de Colorado State University para correr las permutaciones. Exportamos el nuevo pop\_map y los archivos de las combinaciones de parametros al servidor (es decir, los archivos `*.sh`). 
Desde el terminal local: 

	scp pop_map-jimmy.txt salerno@correns.colostate.edu:/home/salerno/scratch_dir/hypsiboas/prueba_dem
	scp *.sh salerno@correns.colostate.edu:/home/salerno/scratch_dir/hypsiboas/prueba_dem
	
Se corre un archivo `*.sh` a la vez:

	sbatch denovo-m4M3n3.sh
	
Se prueba con `squeue` para ver si la corrida ya esta en fila para procesarse.	
	
En una tabla de excel pusimos los valores de los loci y los SNPs obtenidos en los archivos denovo para cada combinación de parámetros.
	
##corriendo populations para obtener r80


Con este programa de Stacks vamos a obtener las matrices de SNPs para evaluar las distintas combinaciones de parametros utilizadas en **denovo_map**. LA idea es determinar, de todos los loci, cuantos loci permanecen cuando se filtran los que estan presentes en menos del 80% de individuos.

Primero, modificamos el **popmap** para tener a todos los individuos como si vinieran de una sola población (no importa cual). 

Luego hicimos los documentos .sh con el código para correr el programa en cada cluster `denovo-m?M?n?`. 

Importar al correns el nuevo **popmap** y los documentos `.sh` 
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


Abrimos el population.log de cada cluster generado por el programa population. Copiamos el número de loci y SNPs kept bajo r 0.8 (se guardan los loci y SNPs que están en el 80% de los individuos). Con esta tabla hicimos dos gráficos, uno para los datos antes de correr populations y otro para los datos de r80. 

![fotito](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico1.png)


![fotito2](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico2.png)

De acuerdo a los resultados mostrados en los gráficos, vemos que disminuye el número de loci y SNPs obtenidos con m5 en comparación a m4 (m es la cantidad mínima de secuencias iguales para formar un stack). M (distancia permitida entre stacks de un mismo locus de un mismo individuo) no afecta en los resultados. Mientras n (distancia permitida entre indiviuos para un mismo locus) aumenta, se ve una disminución de loci y un aumento de SNPs (cambio esperado). En el gráfico de r80 vemos que en n3 hay un pequeño aumento de loci y SNPs, por este motivo hemos decidido aceptar la combinación: m4M3n3.


**1.2.1. Pruebas con todas las *Hypsiboas* de la Gran Sabana** 

Para el resto de las *Hypsiboas*, repetimos las pruebas de genotipificacion y con el mismo codigo que utilizamos para H. jimenezi, pero con la siguiente combinacion de parametros:


permutations |	-m |	-M |	-n
-------------|------|------|-----
a	| 4 | 3 |	3 
b	| 4 | 3 | 4
c	| 4 | 3 | 6
d	| 4 | 4 | 3
e	| 4 | 4 | 4 
f	| 4 | 4 | 6
g	| 5 | 3 | 3
h	| 5 | 3 |	4
i	| 5 | 3 | 6
j 	| 5 | 4 |	3
k	| 5 | 4 | 4
l	| 5 | 4 | 6
	
Para esta pruebas, encontramos los siguientes resultados: 


![fotito3](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico3.png)

![fotito3](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico4.png)

Parece ser, entonces, que la mejor opcion para TODAS las muestras de Hypsiboas, en cuanto a combinacion de parametros, es de m4M3n4, es decir, el optimo solo cambio de n de 3 a 4, y todo lo demas permance igual. ESta sera la combinacion de parametros que usaremos para el resto de los analisis de todos los Hypsiboas. 


#3. GENOTIPIFICACION FINAL CON PARÁMETROS SELECCIONADOS



3.1. VCF TOOLS. 

Necesitamos utilizar vcftools para transformar el archivo de .vcf (que exporta ahora stacks 2.0) a .ped y .map, para poder utilizasr en el programa plink. 


3.2. FILTRADO: PLINK

 Hicimos pruebas de filtrado en plink con distintos niveles de filtrado, para ver el efecto de retencion de SNPs e individuos. 
 
 3.2.1. Pruebas de filtrado con solo jimenezi
 
 

1er Filtro | 2do Filtro | SNPs | Individuos
---------- | ---------- | ---- | ---------
0.5 | 0.5 | 19000 | 25
0.5 | 0.6 | 19000 | 28
0.5 | 0.4 | 19000 | 24
0.25 | 0.6 | 4600 | 33
0.25 | 0.5 | 4600 | 33
0.25 | 0.4 | 4600 | 28
 
En esta tabla se puede ver que cuando se excluyen los SNPs que están en menos del 75% de los individuos, y se excluyen los individuos que no tienen más del 50% de SNPs, nos quedamos con 4600 SNPs y con 33 individuos (se excluyeron solo 4 individuos).


1er FILTRO: 

	./plink --file populations.snps --geno 0.25 --recode --out outputpopulations_a --noweb
	
Total genotyping rate in remaining individuals is 0.331516
71955 SNPs failed missingness test ( GENO > 0.25 )
0 SNPs failed frequency test ( MAF < 0 )
After frequency and genotyping pruning, there are 4680 SNPs
After filtering, 0 cases, 0 controls and 37 missing
After filtering, 0 males, 0 females, and 37 of unspecified sex
Writing recoded ped file to [ outputpopulations_a.ped ] 
Writing new map file to [ outputpopulations_a.map ] 

2do FILTRO: 

	./plink --file outputpopulations_a --mind 0.5 --recode --out outputpopulations_b --noweb
	
Before frequency and genotyping pruning, there are 4680 SNPs
37 founders and 0 non-founders found
Writing list of removed individuals to [ outputpopulations_b.irem ]
4 of 37 individuals removed for low genotyping ( MIND > 0.5 )
Total genotyping rate in remaining individuals is 0.881507

3er FILTRO: 
	
	./plink --file outputpopulations_b --maf 0.016 --recode --out outputpopulations_c --noweb

Before frequency and genotyping pruning, there are 4680 SNPs
33 founders and 0 non-founders found
Total genotyping rate in remaining individuals is 0.881507
0 SNPs failed missingness test ( GENO > 1 )
131 SNPs failed frequency test ( MAF < 0.016 )
After frequency and genotyping pruning, there are 4549 SNPs


LINKAGE DISEQUILIBRIUM

Ver los SNPs que están relacionados por estar muy cerca o en el mismo cromosoma y filtrarlos.

	./plink --file outputpopulations_c --r2 --out outputpopulations --noweb
	
La tabla que se crea (outputpopulations.ld) contiene los valores de linkage entre todos los SNPs que quedan en la matriz. Se abre la tabla en BBEdit, se cambia el nombre a .txt (manualmente) y se abre la tabla en Excel para poder ordenar los valores de R2 (linkage). Se crea una tabla en BBEdit con los SNPs (el primero de cada par) de los que tienen R2 mayor a 0.5 (Blacklist_ld.txt).

Filtrar Blacklist: 

	./plink --file outputpopulations_c --exclude blacklist_ld.txt --recode --out outputpopulations_d --noweb

Se borraron 323 SNPs de la matriz. Ahora la matriz final está en outputpopulations_d.

INBREEDING

	./plink --noweb --file outputpopulations_d --het --out outputpopulations_inbreeding

PGDSpider:
Programa que transforma las matrices finales .ped y map en structure y en genepop. 

Hacer gráficos en R.