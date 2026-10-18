#!/bin/bash
# =============================================================
#  VIVA VOCE - seduta di laurea simulata
#
#  PERSONALIZZA QUI SOTTO. Due righe per ogni domanda:
#
#    WHO      a chi deve chiedere (sii specifico: nome, o
#             "la persona alla tua destra"). Più nomi per la
#             stessa persona separati da | : a ogni domanda ne
#             esce uno a caso ("Mamma|Mammina").
#    ANSWER   la risposta accettata. Basta che la risposta
#             digitata CONTENGA questa parola, quindi tieniti
#             corto: "lisbona", non "a Lisbona, in centro".
#
#  Aggiungi o togli domande liberamente: basta che le due
#  liste restino lunghe uguali. Due domande di fila della
#  stessa persona non vanno bene: alternale.
# =============================================================

WHO=(
  "Chi ti conosce da più tempo"
  "Mamma|Mammina"
  "Chi lavorava al bancone accanto al tuo"
  "Chi divideva la casa con te"
  "Papà|Babbo"
)

ANSWER=(
  "lisbona"
  "lasagn"      # vale sia "lasagne" sia "lasagna"
  "fibroblast"  # vale sia "fibroblasti" sia "fibroblasto"
  "tazze"
  "panda"
)

# Questa parola deve essere identica a KEY5 in build.sh.
KEY="PASSWORD-4"

# =============================================================
#  Da qui in giu' non serve toccare niente.
# =============================================================

# grassetto ANSI, solo su terminale vero
if [ -t 1 ]; then BOLD=$'\033[1m'; RESET=$'\033[0m'; else BOLD=''; RESET=''; fi

# stampa una riga carattere per carattere, effetto macchina da scrivere.
# secondo argomento opzionale: ritardo tra i caratteri (default 0.04s).
typewriter() {
  local s=$1 d=${2:-0.04} i
  for (( i=0; i<${#s}; i++ )); do
    printf '%s' "${s:i:1}"
    sleep "$d"
  done
  printf '\n'
}

TOTAL=${#WHO[@]}

[ -t 1 ] && clear
echo ""
echo "========================================================================"
echo "             ${BOLD}VIVA VOCE  -  seduta della commissione GR-2026${RESET}"
echo "========================================================================"
echo ""
sleep 1
echo "La commissione è seduta intorno a te."
echo ""
echo "$TOTAL domande. Ti dico io chi le fa."
echo "Il resto te lo dicono loro."
echo ""
sleep 2

for i in $(seq 0 $((TOTAL - 1))); do
  echo "------------------------------------------------------------------------"
  echo "${BOLD}DOMANDA $((i + 1)) DI $TOTAL${RESET}"
  echo "------------------------------------------------------------------------"
  echo ""
  IFS='|' read -r -a NAMES <<< "${WHO[$i]}"
  echo "Rivolgiti a:  ${NAMES[RANDOM % ${#NAMES[@]}]}"
  echo ""
  sleep 1

  WANT=$(echo "${ANSWER[$i]}" | tr '[:upper:]' '[:lower:]')
  TRIES=0
  OK=0

  while [ $OK -eq 0 ]; do
    printf "la tua risposta > "
    read -r GIVEN
    GIVEN=$(echo "$GIVEN" | tr '[:upper:]' '[:lower:]')
    TRIES=$((TRIES + 1))

    if [ -n "$GIVEN" ] && [ "${GIVEN#*$WANT}" != "$GIVEN" ]; then
      echo ""
      echo "[ ACCETTATA ]"
      echo ""
      OK=1
    elif [ $TRIES -ge 3 ]; then
      echo ""
      echo "[ ACCETTATA ] Oggi la commissione è di manica larga."
      echo ""
      OK=1
    else
      echo "[ RIFIUTATA ] Risposta sbagliata >> BEVI UN SORSO <<"
      echo ""
    fi
  done
  sleep 1
done

echo "========================================================================"
echo "              ${BOLD}Viva voce conclusa. Commissione soddisfatta.${RESET}"
echo "========================================================================"
echo ""
sleep 2
typewriter "Ecco la chiave d'accesso per te."
typewriter "La commissione l'ha scelta dopo una lunga discussione:"
typewriter "all'unanimità, la password più sicura possibile."
sleep 2.5
typewriter "(SPOILER: non lo è)"
echo ""
sleep 2.5
echo "Chiave d'accesso:  $KEY"
echo ""
echo "Ora lancia:  unzip step5.zip"
echo ""
