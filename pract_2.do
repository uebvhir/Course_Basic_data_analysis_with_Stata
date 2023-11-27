

* 1- Activa el directorio de trabajo en una variable global DDIR

global DDIR="e:\18949893d\Nuevo Equipo VHIR10 Dropbox\Santi Perez-Hoyos\UEB-compartida\__FORMACIO\Formacio_externa\Pere_Virgili\Stata\datasets"

capture log close
log using "$DDIR\resultados_ses2.txt" , text replace
use "$DDIR\sesion1.dta", replace


* 2.- Calcula el número de muertos . Dibuja el gràfico adecuado.
tab mort
catplot hbar mort, percent stack asyvars


* 3. Dibuja el histograma de la  transferrina previa, maxima y post
histogram transferrina_pre,   kdensity normal
histogram  transferrina_tph ,   kdensity normal
histogram fer_max_tph,   kdensity normal




* 4.- Calcula las medias de estas variables en  funcion de si acaban vivos o muertos
mean  transferrina_pre transferrina_tph fer_max_tph, over(mort)


* 5.- Calcula los percentiles 25, 50 y 75 de estas variables

tabstat transferrina_pre transferrina_tph fer_max_tph, statistics(median p25 p75) 
centile transferrina_pre transferrina_tph fer_max_tph, centile(25 50 75 )

* 6.- Compara gràficamente las tres variables

graph box  transferrina_pre transferrina_tph fer_max_tph


* 7. Calcula el intervalo de confianza de la media de estas variables y del porcentaje de muertes

ci means transferrina_pre transferrina_tph fer_max_tph
ci proportion mort

* 8.- Compara el histograma de la trasferrina previa  y màxima en función si el sujeto acaba muerto o no

histogram transferrina_pre,   kdensity normal by(mort)
histogram fer_max_tph,   kdensity normal by(mort)

* 9 .- Compara el diagrama de cajas la trasferrina previa  y post en función si el sujeto acaba muerto o no.
*  Dibuja el diagrama de cajas del la transferrina màxima en fucnión de si estan o no muertos
 
 graph box  transferrina_pre transferrina_tph  ,over(mort)

 graph box fer_max_tph ,over(mort)
 
* 10. Mira visualmente la normalidad de las variables
 
pnorm   transferrina_pre , title( PPplot transferrina_pre)
pnorm  transferrina_tph , title( PPplot transferrina_post)
pnorm  fer_max_tph , title( PPplot transferrina_max)



* 11. Cierra el fichero de resultados  y la sesión

log close
exit
