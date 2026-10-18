#!/bin/bash
# ---------------------------------------------------------
#  PROTOCOLLO FINALE - sequenziamento dell'intero genoma
# ---------------------------------------------------------

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# grassetto ANSI, solo su terminale vero
if [ -t 1 ]; then BOLD=$'\033[1m'; RESET=$'\033[0m'; else BOLD=''; RESET=''; fi

# stampa una riga carattere per carattere, effetto macchina da scrivere.
# secondo argomento opzionale: ritardo tra i caratteri (default 0.04s).
# terzo argomento opzionale: codice colore ANSI applicato all'intera riga.
typewriter() {
  local s=$1 d=${2:-0.04} c=${3:-} i
  [ -n "$c" ] && printf '%s' "$c"
  for (( i=0; i<${#s}; i++ )); do
    printf '%s' "${s:i:1}"
    sleep "$d"
  done
  [ -n "$c" ] && printf '%s' "$RESET"
  printf '\n'
}

# ---- fuochi d'artificio in ASCII: solo sequenze ANSI, nessuna dipendenza ----
fireworks() {
  local cols rows
  cols=$( (tput cols) 2>/dev/null ) || cols=${COLUMNS:-80}
  rows=$( (tput lines) 2>/dev/null ) || rows=${LINES:-24}
  [ "$cols" -lt 24 ] && cols=24
  [ "$rows" -lt 12 ] && rows=12
  [ "$cols" -gt 110 ] && cols=110
  [ "$rows" -gt 32 ] && rows=32
  local COLR=(91 93 92 96 95 94 33)
  local chars=(o + .)
  trap 'printf "\033[0m\033[?25h"' INT
  printf '\033[?25l\033[2J'
  local b y cx top c r ch phase
  for b in $(seq 1 9); do
    cx=$(( RANDOM % (cols - 16) + 8 ))
    top=$(( RANDOM % (rows / 2) + 4 ))
    c=${COLR[$(( RANDOM % ${#COLR[@]} ))]}

    # il razzo sale lasciando la scia (testa viva, coda che sfuma)
    for (( y=rows-1; y>top; y-- )); do
      printf '\033[1;%dm\033[%d;%dH^\033[0m' "$c" "$y" "$cx"
      printf '\033[0;%dm\033[%d;%dH:\033[0m' "$c" $((y+1)) "$cx"
      printf '\033[2;%dm\033[%d;%dH.\033[0m' "$c" $((y+2)) "$cx"
      printf '\033[%d;%dH ' $((y+3)) "$cx"
      sleep 0.018
    done
    printf '\033[%d;%dH \033[%d;%dH \033[%d;%dH ' $((top+1)) "$cx" $((top+2)) "$cx" $((top+3)) "$cx"

    # esplosione: lampo centrale, poi la raggiera che si allarga
    printf '\033[1;%dm\033[%d;%dH*\033[0m' "$c" "$top" "$cx"
    sleep 0.05
    for r in 1 2 3; do
      ch=${chars[$((r-1))]}
      printf '\033[1;%dm' "$c"
      printf '\033[%d;%dH%s' $((top-r)) "$cx" "$ch"
      printf '\033[%d;%dH%s' $((top+r)) "$cx" "$ch"
      printf '\033[%d;%dH%s' "$top" $((cx-r*2)) "$ch"
      printf '\033[%d;%dH%s' "$top" $((cx+r*2)) "$ch"
      printf '\033[%d;%dH%s' $((top-r)) $((cx-r*2)) "$ch"
      printf '\033[%d;%dH%s' $((top-r)) $((cx+r*2)) "$ch"
      printf '\033[%d;%dH%s' $((top+r)) $((cx-r*2)) "$ch"
      printf '\033[%d;%dH%s' $((top+r)) $((cx+r*2)) "$ch"
      printf '\033[0m'
      sleep 0.08
    done

    # le scintille si spengono (tenui) e poi scompaiono
    for phase in 1 2; do
      if [ "$phase" -eq 1 ]; then ch='.'; printf '\033[2;%dm' "$c"; sleep 0.14
      else ch=' '; printf '\033[0m'; sleep 0.10; fi
      printf '\033[%d;%dH%s' "$top" "$cx" "$ch"
      for r in 1 2 3; do
        printf '\033[%d;%dH%s' $((top-r)) "$cx" "$ch"
        printf '\033[%d;%dH%s' $((top+r)) "$cx" "$ch"
        printf '\033[%d;%dH%s' "$top" $((cx-r*2)) "$ch"
        printf '\033[%d;%dH%s' "$top" $((cx+r*2)) "$ch"
        printf '\033[%d;%dH%s' $((top-r)) $((cx-r*2)) "$ch"
        printf '\033[%d;%dH%s' $((top-r)) $((cx+r*2)) "$ch"
        printf '\033[%d;%dH%s' $((top+r)) $((cx-r*2)) "$ch"
        printf '\033[%d;%dH%s' $((top+r)) $((cx+r*2)) "$ch"
      done
      printf '\033[0m'
    done
    sleep 0.06
  done
  trap - INT
  printf '\033[0m\033[?25h\033[2J\033[H'
}

[ -t 1 ] && clear
if [ ! -f "$DIR/specimen.dat" ]; then
  echo ""
  echo "========================================================================"
  echo "                   ${BOLD}SEQUENZIATORE  -  controllo stato${RESET}"
  echo "========================================================================"
  echo ""
  echo "[ ERRORE ] Il sequenziatore è vuoto."
  echo "Nessun campione caricato. Caricalo e riprova."
  echo ""
  exit 1
fi

echo ""
echo "========================================================================"
echo "              ${BOLD}CORSA DI SEQUENZIAMENTO  -  campione GR-2026${RESET}"
echo "========================================================================"
echo ""
sleep 1.5

steps=("Caricamento campione" "Denaturazione" "Amplificazione" "Corsa su gel" \
       "Lettura delle basi" "Allineamento al riferimento" "Controllo di due anni di dati")

for s in "${steps[@]}"; do
  printf "%-32s" "$s"
  for i in $(seq 1 24); do
    printf "#"
    sleep 0.06
  done
  printf "  fatto\n"
done

echo ""
sleep 1
echo "Sequenziamento completato."
sleep 1
echo "Rilevata un'anomalia nei risultati."
sleep 2
echo ""
echo "------------------------------------------------------------------------"
typewriter "ANOMALIA: il campione contiene una laurea magistrale." 0.04 "$BOLD"
echo "------------------------------------------------------------------------"
echo ""
sleep 2
typewriter "La commissione richiede una dichiarazione orale finale."
echo ""
sleep 1
typewriter "IN PIEDI. Alza il calice."
typewriter "Ringrazia la commissione, il tuo relatore, i tuoi colleghi"
typewriter "e i tuoi compagni di studi."
echo ""
typewriter "Il tavolo sta registrando."
echo ""
sleep 1
printf "Premi INVIO quando l'hai fatto > "
read -r _

echo ""
typewriter "Dichiarazione accettata. Scrivo il referto finale..."
sleep 2

cat > "$DIR/FINAL.txt" <<'EOT'
========================================================================
                    REFERTO FINALE - pratica GR-2026
========================================================================

Soggetto:     pratica GR-2026
Discussione:  15 luglio 2026
Istituzione:  Università degli Studi
Corso:        Bioinformatica (laurea magistrale)
Stato:        COMPLETATO

Conclusioni della commissione:

  Due anni fra bancone e terminale, fra provette e script. Oggi il
  risultato è uno solo, ed è riproducibile.

  Esito: laurea magistrale, conseguita.
  Effetti collaterali: un tavolo intero di persone orgogliose di te.
  Prescrizione: festeggiare stasera, riposare domani.

  Complimenti. Davvero.

Caccia al tesoro:  CONCLUSA
Tesoro:            APERTO

Congratulazioni per la laurea.

========================================================================
EOT

fireworks

echo ""
typewriter "Referto salvato."
echo ""
typewriter "       cat FINAL.txt"
echo ""
