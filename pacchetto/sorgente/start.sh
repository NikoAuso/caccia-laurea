#!/bin/bash
# ============================================================
#  AVVIO DELLA CACCIA
#
#  Si lancia con:
#
#      bash start.sh
#
#  Prima controlla che il portatile abbia gli strumenti che la
#  caccia usa dal terminale, poi stampa il briefing iniziale.
#  In fase di setup lancialo tu: se il check passa, il portatile
#  e' pronto e il briefing resta sullo schermo per chi gioca.
#
#  Da toccare: la riga TOOLS, se un giorno servisse un comando in
#  piu' (usa il nome del comando, che su Ubuntu coincide col
#  pacchetto apt). Il briefing sta fra le due righe BRIEFING:
#  cambialo pure, ma tienilo allineato a mano (si legge in un
#  terminale a larghezza fissa).
# ============================================================

# colori ANSI: attivi solo se l'output e' un terminale vero, cosi' reindirizzando
# su file non restano codici sporchi.
if [ -t 1 ]; then
  BOLD=$'\033[1m'; RESET=$'\033[0m'
else
  BOLD=''; RESET=''
fi

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

# stampa un blocco (da stdin) un paragrafo per volta -- paragrafi separati da
# righe vuote -- con una pausa tra l'uno e l'altro (default 1s).
paragraphs() {
  local d=${1:-1} lines i n line prev_blank=1 started=0
  mapfile -t lines
  n=${#lines[@]}
  for (( i=0; i<n; i++ )); do
    line=${lines[i]}
    if [ -z "$line" ]; then
      printf '\n'
      prev_blank=1
      continue
    fi
    if [ "$prev_blank" -eq 1 ] && [ "$started" -eq 1 ]; then
      sleep "$d"
    fi
    # i titoli (riga seguita da una riga di trattini) escono in grassetto
    if [[ ${lines[i+1]} =~ ^[[:space:]]*-+[[:space:]]*$ ]]; then
      printf '%s%s%s\n' "$BOLD" "$line" "$RESET"
    else
      printf '%s\n' "$line"
    fi
    prev_blank=0
    started=1
  done
}

# comandi che la caccia usa dal terminale (nome comando = pacchetto apt)
TOOLS="unzip grep"

[ -t 1 ] && clear
echo ""
missing=""
for cmd in $TOOLS; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    missing="$missing $cmd"
  fi
done

if [ -n "$missing" ]; then
  echo "Questa postazione non è pronta. Manca:$missing"
  echo "Installalo, poi rilancia bash start.sh:"
  echo "      sudo apt install$missing"
  echo ""
  exit 1
fi

printf '%s' "$BOLD"
cat <<'BRIEFING'
========================================================================
                         UNIVERSITÀ DEGLI STUDI
                  Laurea magistrale in Bioinformatica
                          Biennio  2024 / 2026
                   Pratica GR-2026  -  15 luglio 2026
========================================================================
BRIEFING
printf '%s\n' "$RESET"

typewriter "Ti diamo il benvenuto." 0.04 "$BOLD"
echo ""
sleep 0.5

typewriter "La caccia ha inizio. Tutto quello che ti serve è in questa cartella. Non"
typewriter "ti servirà internet, non dovrai installare niente. Tutto ciò che serve"
typewriter "ti sarà fornito in seguito."
sleep 1

paragraphs <<'BRIEFING'





COME FUNZIONA QUESTA CACCIA
---------------------------

Ci sono otto sezioni sigillate, una dentro l'altra, come una serie di
scatole.

Ogni sezione è un file che finisce in .zip, e ognuna è protetta da una
password. Apri una sezione e trovi due cose: qualcosa da risolvere, e la
sezione sigillata successiva.

Trova la password. Apri la scatola dopo. Ripeti otto volte.


LA REGOLA DEL GIOCO
-------------------

Si gioca solo dal terminale, con i comandi del manuale. Non aprire né
modificare i file a mano con altri programmi. Fallo solo quando un
README te lo dice.

Altrimenti, bevi un sorso.


COME APRIRE UNA SEZIONE SIGILLATA
---------------------------------

Scrivi questo, usando il nome del .zip che vedi:

    unzip step2.zip

Il terminale risponderà:

    [step2.zip] step2/README.txt password:

Scrivi la chiave e premi Invio. Non vedrai le lettere comparire mentre
digiti. È normale, il terminale le nasconde. Scrivila lo stesso e premi
Invio.

Le chiavi sono SEMPRE MAIUSCOLE e vanno scritte esatte. Se ottieni
"incorrect password", quasi sempre è una lettera minuscola. Riprova.


COMINCIA DA QUI
---------------

    cd step1
    ls
    cat manual.txt
    cat README.txt

Leggi prima il manuale: un minuto.
Poi leggi README.txt. È il tuo primo enigma, e da qui in poi ogni
sezione sigillata comincia allo stesso modo, con un README che ti dice
cosa fare.





BRIEFING

sleep 1
typewriter "In bocca al lupo e che la caccia abbia inizio."
