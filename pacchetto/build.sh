#!/bin/bash
# ============================================================
#  COSTRUZIONE DELLA CACCIA
#
#  Prende la cartella "sorgente" (quella che hai riempito di
#  foto, video, testi) e ne ricava la caccia vera: una serie
#  di archivi zip annidati, ognuno protetto dalla password
#  che chi gioca trova nel passaggio precedente.
#
#      bash build.sh
#
#  Risultato:  output/caccia/     la cartella da mettere sul portatile
#              output/caccia.zip  la stessa cosa, comoda da trasferire
#
#  Puoi rilanciarlo quante volte vuoi: rifà tutto da capo
#  senza toccare "sorgente".
# ============================================================

set -e
cd "$(dirname "$0")"

# ---- le chiavi, in ordine. stepN si apre con la chiave che
#      chi gioca trova nel passaggio precedente.
#      SEMPRE MAIUSCOLE: le password zip distinguono i caratteri.
KEY2="PASSWORD-1"
KEY3="PASSWORD-2"
KEY4="PASSWORD-3"
KEY5="PASSWORD-4"
KEY6="PASSWORD-5"
KEY7="PASSWORD-6"
KEY8="PASSWORD-7"
KEY9="PASSWORD-8"

# ------------------------------------------------------------
command -v zip >/dev/null || { echo "Manca il comando zip. Installalo: sudo apt install zip"; exit 1; }
[ -d sorgente ] || { echo "Non trovo la cartella 'sorgente' qui accanto."; exit 1; }

echo ""
echo "  Costruisco la caccia..."
echo ""

rm -rf build_tmp output
cp -r sorgente build_tmp

# i permessi degli script
chmod +x build_tmp/start.sh build_tmp/step4/viva.sh build_tmp/step9/thesis_defense.sh 2>/dev/null || true

cd build_tmp

# gli step si aprono annidati: il manuale a portata di mano in ogni sezione,
# cosi' "cat manual.txt" funziona anche in fondo. specimen.dat resta in step1:
# e' chi gioca, allo step9, a costruire il path per raggiungerlo.
for n in 2 3 4 5 6 7 8 9; do cp step1/manual.txt "step$n/"; done

# ---- dal fondo verso l'inizio: ogni step viene chiuso a chiave
#      e infilato dentro quello precedente.
for n in 9 8 7 6 5 4 3 2; do
  eval "KEY=\$KEY$n"
  prev=$((n - 1))
  dest="step$prev"

  [ -d "step$n" ] || { echo "  manca la cartella step$n"; exit 1; }

  zip -q -r -P "$KEY" "step$n.zip" "step$n"
  rm -rf "step$n"
  mv "step$n.zip" "$dest/"
  printf "  step%-2s chiuso con la chiave  %s\n" "$n" "$KEY"
done

cd ..
mkdir -p output/caccia
mv build_tmp/start.sh build_tmp/step1 output/caccia/
rm -rf build_tmp

( cd output && zip -q -r caccia.zip caccia )

echo ""
echo "  Fatto."
echo ""
echo "  output/caccia/     copiala sul portatile e lancia bash start.sh"
echo "  output/caccia.zip  la stessa cosa, se devi trasferirla"
echo ""
echo "  Ordine delle chiavi, tienilo sul telefono:"
echo "    1  $KEY2"
echo "    2  $KEY3"
echo "    3  $KEY4"
echo "    4  $KEY5"
echo "    5  $KEY6"
echo "    6  $KEY7"
echo "    7  $KEY8"
echo "    8  $KEY9"
echo ""
