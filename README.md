# 1. DEMULTIPLEXING

All genotyping pipeline analyses were performed using Stacks V 2.0, and all filtering steps were performed using stacks and plink (see below). 
 
>Raw data can be found on the dryad repository for this project upon manuscript acceptance. 


For demultiplexing and filtering raw data, we used the following code: 

	process_radtags -p /path/to/raw-data -o /path/to/output -b /path/to/barcodes.txt -c -q -r --inline_index -- renz_1 sphI --renz_2 mspI

The barcodes file can be found [here](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/demultiplex_todos2.txt). For locality data and info, please see [this file](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/HYPSIBOAS_info_codes_localities.xlsx). 

# 2. DENOVO MAP | genotyping tests

We tested various parameter combinations for the three main stacks parameters: `-m` or minimum number or reads to create a stacks, `-M` or maximum number of differences among stacks to call a locus (within individuals), and `-n` or maximum number of differences allowed among individuals. Because `-n` is very important for determining whether paralogs or orthologs are being joined as loci, then we varied this parameter differently according to the dataset. We based these parameter tests and assessments on this [tutorial](http://catchenlab.life.illinois.edu/stacks/param_tut.php) and on [this paper](https://github.com/pesalerno/MingaGenomica2019/blob/master/lecturas/Paris-etal-2017.pdf). 

We wanted to investigate whether genotyping outputs and various diersity and divergence estimates vary according to how they are genotyped, we performed genotyping parameter tests with two sub-datasets. The first oly contained the main species of interest, H. jimenezi, and the second contained also the rest of the Gran Sabana Hypsiboas species, which inherently introduces a substantial amount of divergence of the sample to be analyzed. 


	cd raw-data
	denovo_map.pl -M 3 -n 2 -o ./outputfolder --popmap ./pop_map.txt --samples ./prueba_dem
	
	 

## 2.1. Parameter permutation tests with only *H. jimenezi* | **denovo_map**

We tested the following parameter combinations for this dataset:

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

For these permutations, we found the following results: 


![fotito](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico1.png)


Then, we ran populations for each of these analyses exporting loci that are present in more than 80% of individuals in the sample, as per the r80 rule, using the following code: 

	populations -P ./denovo-m4M3n2 --popmap ./pop_map-jimmy.txt -O ./denovo-m4M3n2 -p 1 -r 0.8 --write_random_snp --plink	

and found the following results: 


![fotito2](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico2.png)


> De acuerdo a los resultados mostrados en los gráficos, vemos que disminuye el número de loci y SNPs obtenidos con m5 en comparación a m4 (m es la cantidad mínima de secuencias iguales para formar un stack). M (distancia permitida entre stacks de un mismo locus de un mismo individuo) no afecta en los resultados. Mientras n (distancia permitida entre indiviuos para un mismo locus) aumenta, se ve una disminución de loci y un aumento de SNPs (cambio esperado). En el gráfico de r80 vemos que en n3 hay un pequeño aumento de loci y SNPs, por este motivo hemos decidido aceptar la combinación: m4M3n3.


## 2.2. Parameter permutations with all Gran Sabana *Hypsiboas*

We used the same parameter combinations as above, but varying parameter `-n` a bit more ot account for the higher divergence:


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
	
For these tests, we found the following results:


![fotito3](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico3.png)

![fotito3](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/fotos/Grafico4.png)

DISCUSS PARAMETER CHOICE: `m4M3n3`

In order to obtain a known outgroup to our Gran Sabana Hypsiboas group of interest, we re-genotyped all *Hypsiboas* using four samples of *H. lundii* from the Brazilian Cerrado, which were previously published in this [paper](https://onlinelibrary.wiley.com/doi/full/10.1111/mec.15045). For this matrix, we increased n to 4, but retained all other parameters the same (so, we ran `m4M3n4`)

The logfiles for the final ***denovo_map*** analyses can be found here for the analyses with [*H. jimenezi* only](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/m4M3n3-denovo_map-jimmy.log), all [Gran Sabana *Hypsiboas*](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/m4M3n3-denovo_map-hypsiALL.log), and for the dataset that includes the [Cerrado outgroup](). 

All graphs in this section were generated using [this master file](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/Grafico_Resultado_param_TODOS.xlsx).


# 3. filtering final matrices in plink


First, we had to re-export the final parameter choice genotyping matrix with `populations` using minimal filters: 

	populations -P ./denovo-m4M3n2 --popmap ./pop_map-jimmy.txt -O ./denovo-m4M3n2 -p 1 -r 0.1 --write_random_snp --vcf	
>The raw unfiltered matrices exported from populations can be found here for [*H. jimenezi* only](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/m4M3n3-populations-jimmy.snps.vcf), for all [Gran Sabana *Hypsiboas*](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/m4M3n3-populations-hypsiALL.snps.vcf), and for the dataset that includes the [Cerrado outgroup](). 


Then, we transformed the `.vcf` files using vcftools into `.ped` and `.map` files for inputting and filtering in plink. 

	vcftools --vcf path/to/file.vcf --plink --out filename

## 3.1. general filtering permutations

The three main filters we used in plink were `--geno`, or eliminating loci with too much missing data, `--mind`, or eliminating individuals with too much missing data, and `--maf` or eliminating loci based on the frequency of the minor allele.  
	
Thus, we tested a few permutations of these filtering thresholds to retain the most number of loci and individuals in all three datasets. 


**a.filtering permutations with only *H jimenezi***
 
 

1er Filtro | 2do Filtro | SNPs | Individuos
---------- | ---------- | ---- | ---------
0.5 | 0.5 | 19000 | 25
0.5 | 0.6 | 19000 | 28
0.5 | 0.4 | 19000 | 24
0.25 | 0.6 | 4600 | 33
0.25 | 0.5 | 4600 | 33
0.25 | 0.4 | 4600 | 28
 
>En esta tabla se puede ver que cuando se excluyen los SNPs que están en menos del 75% de los individuos, y se excluyen los individuos que no tienen más del 50% de SNPs, nos quedamos con 4600 SNPs y con 33 individuos (se excluyeron solo 4 individuos).


	--geno 0.25
	
Which resulted in the following:

	Total genotyping rate in remaining individuals is 0.331516
	71955 SNPs failed missingness test ( GENO > 0.25 )
	0 SNPs failed frequency test ( MAF < 0 )
	After frequency and genotyping pruning, there are 4680 SNPs
	After filtering, 0 cases, 0 controls and 37 missing
	After filtering, 0 males, 0 females, and 37 of unspecified sex
	Writing recoded ped file to [ outputpopulations_a.ped ] 
	Writing new map file to [ outputpopulations_a.map ]

Then we did: 

	--mind 0.5
	
Which resulted in the following: 

	Before frequency and genotyping pruning, there are 4680 SNPs
	37 founders and 0 non-founders found
	Writing list of removed individuals to [ outputpopulations_b.irem ]
	4 of 37 individuals removed for low genotyping ( MIND > 0.5 )
	Total genotyping rate in remaining individuals is 0.881507
		
And finally, we did: 

	--maf 0.016

	Before frequency and genotyping pruning, there are 4680 SNPs
	33 founders and 0 non-founders found
	Total genotyping rate in remaining individuals is 0.881507
	0 SNPs failed missingness test ( GENO > 1 )
	131 SNPs failed frequency test ( MAF < 0.016 )
	After frequency and genotyping pruning, there are 4549 SNPs

**b.filtering permutations with all Gran Sabana *Hypsiboas***

add things here


**c.filtering permutations with cerrado outgroup**

add things here




## 3.2. linkage disequilibrium filter

Ver los SNPs que están relacionados por estar muy cerca o en el mismo cromosoma y filtrarlos.

	./plink --file outputpopulations_c --r2 --out outputpopulations --noweb
	
>La tabla que se crea (outputpopulations.ld) contiene los valores de linkage entre todos los SNPs que quedan en la matriz. Se abre la tabla en BBEdit, se cambia el nombre a .txt (manualmente) y se abre la tabla en Excel para poder ordenar los valores de R2 (linkage). Se crea una tabla en BBEdit con los SNPs (el primero de cada par) de los que tienen R2 mayor a 0.5 (Blacklist_ld.txt).

Filtrar utilizando un Blacklist: 

	./plink --file outputpopulations_c --exclude blacklist_ld.txt --recode --out outputpopulations_d --noweb

Se borraron 323 SNPs de la matriz. Ahora la matriz final está en outputpopulations_d.

## estimando INBREEDING individual en plink

	./plink --noweb --file outputpopulations_d --het --out outputpopulations_inbreeding

>PGDSpider:
Programa que transforma las matrices finales .ped y map en structure y en genepop. 

## estimando estructura poblacional en R
Hacer gráficos utilizando [el siguiente codigo](https://github.com/pesalerno/Hypsiboas-genomics/blob/master/files/SCRIPT_ADEGENET.R) para el paquete **adegenet** en R. 