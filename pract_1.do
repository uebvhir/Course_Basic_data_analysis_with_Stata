

* 1- Activa el directorio de trabajo en una variable global DDIR

global DDIR="H:\_copia_disc\E\Docencia\stata\hematologia\"

* 2.- Activa el fichero para guardar los resultados en el directorio de trabajo “resultados_ses1.txt”
capture log close
log using "$DDIR\resultados_ses1.txt" , text replace

*  3.- Importa la tabla de EXCEL “base_ferritina_usal” (el nombre de la tabla es el mismo que  la hoja
odbc load , dsn("Excel Files;DBQ= $DDIR\base_ferritina_usal.xls") table("base_ferritina_usal$") clear lower  datestring


* 4.- Describe y mira las variables de la tabla
describe
browse

* 5.- Elimina las variable carácter
drop iniciales quela_farmaco_post



* 6. Genera las variables de fecha 
gen data_tph= mdy(real( substr(tph_date,6,2)) ,real(substr(tph_date, 9,2)),real(substr(tph_date,1,4)))
format %td data_tph

gen data_fer_max_tph= mdy(real( substr(fer_max_tph_date,6,2)) ,real(substr(fer_max_tph_date, 9,2)),real(substr(fer_max_tph_date,1,4)))
format %td data_fer_max_tph

gen data_exitus= mdy(real( substr( exitus_date,6,2)) ,real(substr( exitus_date, 9,2)),real(substr( exitus_date,1,4)))
format %td data_exitus

* 7.- Genera una variable que indique si el paciente ha muerto o no. Etiqueta la variable y los valores  vivo y muerto

gen mort=0
replace mort=1 if exitus_date!=""

label var mort"Esta muerto"
label define lab_mort 0"Vivo" 1"Muerto", modify
label val mort lab_mort

* 8.- Genera una variable que indique los años de seguimento. Etiqueta la variable.(Nota para los vivos considera el fin del seguimiento el 31/12/2009)
gen tseg=  (data_exitus-data_tph)/365
replace tseg=  (mdy(12,31,2009)-  data_tph)/365 if tseg==.
label var tseg "Tiempo de seguimiento"

* 9.- Recodifica la variable tiempo de seguimiento en  0-2 años, 2-6 años y mas de 6.

recode tseg  min/2=1 2/6=2 6/max=3, gen(r_tseg1)
label var r_tseg1 "Tiempo seguimiento recodificado"
label define lab_tseg 1"menos de 2" 2"2 a 6" 3"Mas de 6", modify
label val r_tseg1 lab_tseg

egen r_tseg2= cut(tseg), at (0,2,6,100) label
 
 * 10.- Guarda un fichero para los vivos  Guarda un fichero para los muertos
 
preserve

keep if mort==0

save "$DDIR\vivos.dta", replace

restore
preserve
keep if mort==1
save "$DDIR\muertos.dta", replace

restore

use  "$DDIR\vivos.dta", clear



* 11 Abre el fichero para los vivos y añádele el de los muertos y guardalo

append using  "$DDIR\muertos.dta"

save "$DIR\sesion1.dta", replace
* 12 . Cierra el fichero de resultados  y la sesion
log close
exit


