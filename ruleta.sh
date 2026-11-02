#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Ctrl+C
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}
trap ctrl_c INT

function helpPanel()
{
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ${endColour}${purpleColour} $0${endColour}\n"
  echo -e "\t${blueColour}-m)${endColour} ${grayColour}Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Tecnica a utilizar${endColour} ${purpleColour}(${endColour}${yellowColour}martingala${endColour}${purpleColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}"
  exit 1
}

function martingala()
{
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour} ${greenColour}\$$money${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Cuanto dinero deseas apostar? ->${endColour}" && read initial_bet
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿A que deseas apostar continuamente (par/impar)? ->${endColour}" && read par_impar

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inicial de${endColour} ${greenColour}\$$initial_bet${endColour} ${grayColour}a${endColour} ${yellowColour}$par_impar${endColour}"
  
  play_counter=0
  backup_bet=$initial_bet
  jugadas_malas="[ "
  
  tput civis #Ocultar cursor 
  while true; do 

    random_number="$(($RANDOM % 37))"
   
    if [ $money -ge $initial_bet ]; then 
    money=$(($money-$initial_bet))
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Apostado:${endColour} ${blueColour}\$$initial_bet${endColour}${grayColour} Cartera:${endColour} ${yellowColour}\$$money${endColour}"
    echo -e "${yellowColour}[+]${endColour} Ha salido el numero ${blueColour}$random_number${endColour}"
     
      if [ "$par_impar" == "par" ]; then 
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour} ${redColour}Ha salido el 0, pierdes${endColour}"
#            echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
            jugadas_malas+="$random_number "
          else
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par, ¡Ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour} Ganancia total: ${yellowColour}\$$reward${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
            initial_bet=$backup_bet
            jugadas_malas="[ "
          fi
        else
#          echo -e "${yellowColour}[+]${endColour} ${redColour}El numero que ha salido es impar, pierdes${endColour}"
          initial_bet=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
          jugadas_malas+="$random_number "
        fi
      else
         if [ "$(($random_number % 2))" -eq 1 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour} ${redColour}Ha salido el 0, pierdes${endColour}"
#            echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
            jugadas_malas+="$random_number "
          else
 #           echo -e "${yellowColour}[+]${endColour}${greenColour} El numero que ha salido es par, ¡Ganas!${endColour}"
            reward=$(($initial_bet*2))
  #          echo -e "${yellowColour}[+]${endColour} Ganancia total: ${yellowColour}\$$reward${endColour}"
            money=$(($money+$reward))
   #         echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
            initial_bet=$backup_bet
            jugadas_malas="[ "
          fi
        else
#          echo -e "${yellowColour}[+]${endColour} ${redColour}El numero que ha salido es impar, pierdes${endColour}"
          initial_bet=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour} Cartera: ${yellowColour}\$$money${endColour}"
          jugadas_malas+="$random_number "
        fi 
        #sleep 0.5
      fi
    else
      echo -e "${redColour}\n[!] Te has quedado sin dinero suficiente para apostar${endColour}"
      echo -e "${yellowColour}[+]${endColour} Han habido un total de ${yellowColour}$play_counter${endColour} jugadas"
      echo -e "\n${yellowColour}[+]${endColour} Racha perdedora:\n $jugadas_malas]"
      tput cnorm; exit 0
    fi 
    let play_counter+=1
  done

  tput cnorm #Recuperamos el cursor 
}

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour} ${greenColour}\$$money${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿A que deseas apostar continuamente (par/impar)? ->${endColour}" && read par_impar
  
  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

  jugadas_totales=0
  tput civis 
  while true; do
    random_number=$((RANDOM % 37))
    money=$((money - bet))
    if [ "$money" -ge 0 ]; then
      let jugadas_totales+=1
      echo -e "\n${purpleColour}--------------------------------JUGADA $jugadas_totales------------------------------------${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos ${endColour}${yellowColour}\$$bet${endColour}"
      echo -e "${yellowColour}[+]${endColour} Tenemos ${yellowColour}\$$money${endColour}"

      echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido numero ${blueColour}$random_number${endColour}"

      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
          echo -e "${yellowColour}[+]${endColour}${grayColour} El numero es par, !ganas!${endColour}"
          reward=$((bet*2))
          money=$((money+reward))
          echo -e "${yellowColour}[+]${endColour} Tienes ${yellowColour}\$$money${endColour}"

          my_sequence+=($bet)
          my_sequence=(${my_sequence[@]})

          echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestra nueva secuencia es ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ]; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          fi
        else
          if [ "$random_number" -eq 0 ]; then
          echo -e "${redColour}[!] Ha salido el cero, !pierde!${endColour}"
          else
          echo -e "${redColour}[!] El numero es impar, !pierdes!${endColour}"
          fi
          unset my_sequence[0]
          unset my_sequence[-1] 2>/dev/null

          my_sequence=(${my_sequence[@]})

          echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia nos quedaria de la siguiente forma: ${endColour}${greenColour}[${my_sequence[@]}]${endColour}"
          if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[@]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!] Secuencia agotada.${endColour}"
            my_sequence=(1 2 3 4)
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
          fi
        fi
      fi
#      sleep 3
    else
      echo -e "${redColour}\n[!] Te has quedado sin dinero suficiente para apostar${endColour}"
      tput cnorm; exit 1
    fi
  done
  tput cnorm 

}

while getopts "m:t:h" arg; do 
  case $arg in 
    m) money=$OPTARG;; 
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done

if [ $money ] && [ $technique ]; then
  #echo "Dinero disponible: \$$money Tecnica: $technique"
  if [ $technique == "martingala" ]; then
    martingala
  elif [ $technique == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La tecnica introducida no existe.${endColour}"
    helpPanel
  fi
else 
  helpPanel
fi
