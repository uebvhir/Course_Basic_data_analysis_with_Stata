* 1- Activa el directorio de trabajo en una variable global DDIR

global DDIR="H:\_copia_disc\E\Docencia\stata\hematologia\"

capture log close
log using "$DDIR\resultados_ses3.txt" , text replace
use "$DIR\sesion1.dta", replace



* 2.- Existe diferencia en el nivel inicial de trasferrrina entre los vivos y los muertos?. 

* Dibuja el gràfico de densidades comparando


twoway kdensity transferrina_pre if mort==0 || kdensity transferrina_pre if mort==1 ||,legend(label( 1 Vivos) label(2 Muertos))

* Verifica la normalidad de la variable  en cada grupo

by mort,sort: swilk  transferrina_pre
 

* Verifica la homogeneidad de variables

sdtest transferrina_pre, by(mort)

* Compara las medias

ttest transferrina_pre, by(mort)

* Efectua la comparación no paramétrica

ranksum transferrina_pre, by(mort)

* 3.- Repite los análisis para la tranferrina post y màxima

twoway kdensity transferrina_tph if mort==0 || kdensity transferrina_tph if mort==1 ||,legend(label( 1 Vivos) label(2 Muertos))
by mort,sort: swilk  transferrina_tph
sdtest transferrina_tph, by(mort)
ttest transferrina_tph, by(mort)
ranksum transferrina_tph, by(mort)

twoway kdensity  fer_max_tph if mort==0 || kdensity  fer_max_tph if mort==1 ||,legend(label( 1 Vivos) label(2 Muertos))
by mort,sort: swilk   fer_max_tph
sdtest  fer_max_tph, by(mort)
ttest  fer_max_tph, by(mort)
ranksum  fer_max_tph, by(mort)



* 4 .-Compara si hay cambios entre la transferrina previa y post

ttest  transferrina_pre= transferrina_tph
signtest  transferrina_pre= transferrina_tph
signrank  transferrina_pre= transferrina_tph


* 5 .- Calcula la correlacion entre la transferrina previa y post ( grafica y numericamente

twoway sc transferrina_tph  transferrina_pre ||lfit  transferrina_pre  transferrina_tph  || lowess transferrina_pre  transferrina_tph
 
pwcorr transferrina_tph  transferrina_pre

* 6- Cuanto cambia la transferrina post en función de la transferrnina pre

regress transferrina_tph  transferrina_pre

* 7. Cierra el fichero de resultados  y la sesión

log close
exit
