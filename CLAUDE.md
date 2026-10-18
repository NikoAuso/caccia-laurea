# CLAUDE.md

Contesto di progetto per Claude Code. Leggilo prima di modificare qualsiasi cosa.

---

## Cos'è questo progetto

Una caccia al tesoro da terminale, pensata come regalo per una laurea magistrale in
Bioinformatica. Chi gioca non ha nome né genere: nei testi è solo la pratica `GR-2026`,
discussione il 15 luglio 2026. Si gioca su un portatile al bar, dopo la proclamazione,
davanti a una decina di persone.

Nove sezioni, ognuna chiusa in un archivio zip protetto da password. Chi gioca apre
una sezione, risolve quello che trova, scopre la chiave della successiva.

**Il profilo è da bioinformatico.** Gli enigmi mescolano laboratorio (provette, gel,
western blot, sequenziatore, quaderno di laboratorio) e terminale (file nascosti,
`grep`, script, percorsi): chi gioca conosce entrambi i campi. I comandi restano
comunque scritti per esteso nel file che si sta leggendo, e tutti sono elencati in
`sorgente/step1/manual.txt`: al bar, sotto pressione, nessuno deve bloccarsi sulla
sintassi.

---

## Struttura

Tutto il progetto vive sotto `pacchetto/`; `CLAUDE.md` sta un livello sopra (radice del
repo). **I percorsi in questo file sono relativi a `pacchetto/`**, dove sta `build.sh`.

```
pacchetto/
  sorgente/           quello che si modifica
    start.sh          avvio: controlla i pacchetti, poi stampa il briefing
    step1/            il punto di partenza
      manual.txt      i comandi spiegati a chi gioca
      README.txt      primo indizio
      .protocol       file nascosto, contiene la prima chiave
      specimen.dat    illeggibile, serve solo allo step 9
    step2/ … step9/   una cartella per sezione
  build.sh            costruisce la caccia
  output/             prodotto da build.sh (rigenerabile)
    caccia/           la cartella da mettere sul portatile
    caccia.zip        la stessa cosa, comoda da trasferire
```

Accanto a `pacchetto/`, nella radice del repo, c'è `docs/`: niente di questo finisce
sul portatile.

```
docs/
  GUIDA.md                  il giorno della caccia: password, aiuti per step, preparazione
                            (solo per l'organizzatore)
  CHI-DICE-COSA.md          scaletta del giorno per il tavolo e il barista
  buste.html                le due buste da stampare: PASSWORD-5 (busta 1),
                            PASSWORD-6 (busta 2)
  screenshot/               immagini del README e anteprima social 1280x640
```

Nel repo non ci sono PDF: guida e scaletta si stampano dal markdown, le buste da
`buste.html` aperta nel browser.

Gli screenshot in `docs/screenshot/` mostrano testi, password e pagine così come sono
ora: se cambia qualcosa di visibile (testi del terminale, pagine, chiavi), vanno rifatti
insieme al README.

`build.sh` copia `sorgente/` in una cartella temporanea, chiude ogni `stepN` in un
zip cifrato con la sua chiave, lo infila dentro `step(N-1)`, e produce `output/caccia/`
più `output/caccia.zip`. Non modifica mai `sorgente/`. Si può rilanciare all'infinito.

---

## Gli step

| Step | Cosa fa chi gioca                                                      | Comando nuovo              | Chiave che ottiene |
| ---- | ---------------------------------------------------------------------- | -------------------------- | ------------------ |
| 1    | trova il file nascosto                                                 | `ls -a`                    | `PASSWORD-1`       |
| 2    | seleziona le foto giuste in `gallery.html`                             | —                          | `PASSWORD-2`       |
| 3    | recupera e legge il quaderno                                           | `mv`, `head -n`, `tail -n` | `PASSWORD-3`       |
| 4    | seduta di laurea: `viva.sh` interroga, rispondono le persone al tavolo | `bash script.sh`           | `PASSWORD-4`       |
| 5    | cerca il suo campione in 2000 righe                                    | `grep`                     | `PASSWORD-5`       |
| 6    | legge sette campioni, ordina al bancone, beve lo shot                  | `cat`                      | `PASSWORD-6`       |
| 7    | quiz personale in `defense.html`                                       | —                          | `PASSWORD-7`       |
| 8    | guarda il montaggio di video e parole in `messages.html`               | —                          | `PASSWORD-8`       |
| 9    | carica il campione e avvia `thesis_defense.sh`                         | `cp`                       | —                  |

---

## Vincoli da non violare

### 1. Le chiavi sono duplicate in più file

Questo è il punto più fragile del progetto. Ogni chiave sta in `build.sh` e anche
nel posto dove chi gioca la scopre:

| Chiave       | `build.sh` | Dove compare anche                                                                                              |
| ------------ | ---------- | --------------------------------------------------------------------------------------------------------------- |
| `PASSWORD-1` | `KEY2`     | `sorgente/step1/.protocol`                                                                                      |
| `PASSWORD-2` | `KEY3`     | la parola `CHIAVE` e le `date` valide, in `gallery.html`                                                        |
| `PASSWORD-3` | `KEY4`     | quinta voce di `logbook.txt`, in mezzo al lorem ipsum; l'ultima voce ci rimanda                                 |
| `PASSWORD-4` | `KEY5`     | la riga `KEY=` in `viva.sh`                                                                                     |
| `PASSWORD-5` | `KEY6`     | **in nessun file**: busta 1, sotto il tavolo; la riga `GR2026` di `archive.csv` (riga 1132) ci rimanda soltanto |
| `PASSWORD-6` | `KEY7`     | **in nessun file**: busta 2, la consegna il barista                                                             |
| `PASSWORD-7` | `KEY8`     | il `<p class="word">` in fondo a `defense.html`                                                                 |
| `PASSWORD-8` | `KEY9`     | le righe `word` di `SEQUENCE` in `messages.html`, attaccate senza spazi                                         |

Se ne cambi una, cambiala in entrambi i posti e verificalo con una prova completa.
Le due buste si stampano da `docs/buste.html` (A4 verticale al 100%, scritta nella metà
alta, da piegare a metà); con `#1` o `#2` in coda all'indirizzo la pagina ne mostra una
sola. Se cambi `KEY6` o `KEY7`, cambia la parola in `BUSTE`. Per farne dei PDF, da
`docs/`:

```bash
for k in 1 2; do
  google-chrome --headless --no-pdf-header-footer --virtual-time-budget=3000 \
    --print-to-pdf=busta-$k.pdf "file://$PWD/buste.html#$k"
done
```

**Le password zip distinguono maiuscole e minuscole.** Tutte le chiavi sono
MAIUSCOLE. Lo schema è `PASSWORD-N`, con N lo step in cui si trova la chiave: sono
segnaposto prevedibili, chi gioca può indovinare la successiva senza risolvere lo step.
Per una caccia vera vanno sostituite con parole scelte, sempre MAIUSCOLE e senza accenti.

### 2. Le date della galleria reggono l'enigma

In `gallery.html`, in cima al blocco di configurazione, ci sono la parola `CHIAVE`
(deve restare uguale a `KEY3` in `build.sh`) e il `CUTOFF` (2024-10-01, inizio della
magistrale). Sono valide solo le foto con `date >= CUTOFF`; le loro **lettere si
derivano da sole** da `CHIAVE`, in ordine di figura (la 1ª valida prende la 1ª lettera,
ecc.). Le `letter` non si scrivono a mano: si regolano solo le `date`, e i decoy
hanno `date` precedenti al `CUTOFF`. Unico invariante: **il numero di foto valide deve
essere uguale alla lunghezza di `CHIAVE`** (PASSWORD-2 → 10 valide su 15). Se non torna, la console
del browser lo segnala.

### 3. Nessun comando fuori dal manuale

Il repertorio è chiuso: `ls`, `ls -a`, `cd`, `pwd`, `cat`, `head`, `head -n`, `tail`, `tail -n`,
`grep`, `mv`, `cp`, `unzip`, `bash script.sh`. Non introdurre pipe, redirezioni, `chmod`,
`find`, `sed`, o qualsiasi altra cosa. Se una modifica richiede un comando nuovo, va
prima aggiunto a `manual.txt` con la stessa formattazione degli altri — e comunque è
quasi sempre il segno che la modifica è sbagliata.

### 4. Tutto offline e senza dipendenze

Al bar non c'è wifi e non si installa niente. Le pagine HTML sono file singoli con
CSS e JS inline: **nessun font da Google, nessuna CDN, nessun framework, nessun
`npm install`**. Gli stack di font sono di sistema apposta. Gli script sono bash
puro, POSIX dove possibile.

### 5. Niente si può rompere

Ogni passaggio ha una via d'uscita: se un'immagine manca compare un riquadro
tratteggiato, se un video non parte c'è il pulsante Avanti, se la seduta di laurea
riceve tre risposte sbagliate passa comunque. Mantieni questa proprietà in ogni
modifica: **un errore dell'utente non deve mai bloccare la caccia**.

### 6. Lingua

**Tutto in italiano**, terminale e browser. Restano in inglese solo pochi elementi
tecnici, per realismo o perché sono letterali:

- **Comandi e nomi di file**: `ls`, `cd`, `grep`, `mv`, `cp`, `unzip`, `head`, `tail`, e i
  nomi dei file/estensioni (`README.txt`, `manual.txt`, `logbook.txt`, `*.sh`, `*.zip`,
  `specimen.dat`, `archive.csv`). Non si traducono né si rinominano: `build.sh` e i rimandi
  fra file dipendono da quei nomi.
- **Le chiavi/password** (`PASSWORD-1` … `PASSWORD-8`): sono password, non lingua; ognuna
  si cambia solo col doppio-edit di sempre (`build.sh` + il file dove chi gioca la
  scopre).
- **`archive.csv`**: l'export tecnico resta inglese (nomi degli `assay` — Western blot,
  ELISA, qPCR, … — e i codici di stato: è un dump di database realistico). È tradotta solo
  la riga `GR2026`, l'unica che chi gioca legge dopo il `grep`.
- **`logbook.txt`**: testa e coda (ciò che si legge con `head -n 31`/`tail -n 26`) sono
  ricordi segnaposto in lorem ipsum, da sostituire con quelli veri tenendo lo stesso
  numero di righe; restano in italiano l'intestazione e l'ultima voce con l'indizio. Le
  ~360 voci di riempitivo centrale (~1200 righe), mai lette, restano inglesi.
- **Messaggi letterali del sistema**: `"incorrect password"` — li
  stampa il terminale, si citano come sono.

**Niente genere.** Chi gioca non ha nome né genere: i testi del gioco usano il tu senza
aggettivi o participi concordati, i documenti scrivono «chi gioca». Mai «la laureata»,
«Dott.ssa», «dottoressa» o forme al maschile.

Le domande della seduta non stanno in `viva.sh`: le fanno a voce le persone al tavolo, e
sono scritte in `docs/CHI-DICE-COSA.md`. Regola password: chiavi MAIUSCOLE,
senza accenti.

### 7. Ogni errore fa bere un sorso

Nei tre punti dove chi gioca può sbagliare, il sistema lo segnala e invita a bere
un sorso — è il pegno del gioco, non blocca mai nulla (resta valido il vincolo 5):

- `gallery.html`: cliccare una foto fuori corso tinge la card di rosso (bordo, tick
  con ✗, filigrana X), la fa tremare e mostra il toast «Campione fuori corso — bevi
  un sorso». La foto sbagliata non entra nella chiave. **La selezione è definitiva**:
  una foto segnata — giusta o sbagliata — non si può più togliere.
- `viva.sh`: risposta rifiutata → riga `[ RIFIUTATA ] Risposta sbagliata >> BEVI UN SORSO <<`.
- `defense.html`: risposte sbagliate → toast «Risposte da rivedere — Bevi un sorso».
  Le risposte *mancanti* non fanno bere (è una dimenticanza, non un errore).

Il testo dell'invito è generico («bevi un sorso»), così vale per qualsiasi bevanda.

C'è anche una quarta regola, enunciata nel briefing di `start.sh` («LA REGOLA DEL
GIOCO») ma **non rilevata dal codice** — la fa rispettare il tavolo: si gioca solo dal
terminale, senza aprire o modificare i file a mano se non quando un README lo chiede.
Chi opera di testa sua beve un sorso.

---

## Come provare una modifica

```bash
bash build.sh
cp -r output/caccia /tmp/prova && cd /tmp/prova/step1

unzip -P PASSWORD-1 step2.zip && cd step2
unzip -P PASSWORD-2 step3.zip && cd step3
unzip -P PASSWORD-3 step4.zip && cd step4
unzip -P PASSWORD-4 step5.zip && cd step5
unzip -P PASSWORD-5 step6.zip && cd step6
unzip -P PASSWORD-6 step7.zip && cd step7
unzip -P PASSWORD-7 step8.zip && cd step8
unzip -P PASSWORD-8 step9.zip && cd step9
cp /tmp/prova/step1/specimen.dat . && bash thesis_defense.sh
```

Poi `rm -rf /tmp/prova`. Le pagine HTML vanno aperte davvero in un browser: il
comportamento dei click e dei video non si verifica leggendo il codice.

Non committare mai `output/`: sono artefatti rigenerabili.

### Foto e video

Le foto della galleria e del quiz non ci sono: al loro posto compare un riquadro
tratteggiato con il nome del file atteso (`img/fig1.jpg`, `img/quiz_provetta.jpg`, …).
Per una caccia vera basta metterle in `sorgente/step2/img/` e `sorgente/step7/img/`
con quei nomi, o aggiornare i percorsi in `PHOTOS` e `QUIZ`. I video del montaggio sono
segnaposto senza volti: si sostituiscono allo stesso modo, tenendo i nomi di file o
aggiornando `SEQUENCE`.

I video vanno in **H.264**, non HEVC: i telefoni recenti registrano in HEVC, che Chrome
su Linux mostra come schermo nero con l'audio. Si convertono dentro `step8/media/`
numerandoli dal primo `msgN.mp4` libero; il comando uniforma anche il volume e riduce a
1080p:

```bash
DEST=/percorso/del/repo/pacchetto/sorgente/step8/media
cd /percorso/della/cartella-coi-video   # file rinominati 01, 02, … nell'ordine voluto
i=5; for f in *; do
  ffmpeg -i "$f" -vf "scale=-2:'min(1080,ih)'" \
    -c:v libx264 -crf 20 -preset veryfast -pix_fmt yuv420p \
    -af loudnorm=I=-16:TP=-1.5:LRA=20 -ar 48000 -c:a aac -b:a 192k -movflags +faststart \
    "$DEST/msg$i.mp4"
  i=$((i+1))
done
```

Poi una riga `{ type:"video", src:"media/msgN.mp4", who:"Nome" }` per ognuno in
`SEQUENCE`; le quattro righe `word` non cambiano. Le foto si copiano così come sono.

---

## Convenzioni del codice

- Le pagine HTML hanno in fondo una lista di configurazione (`PHOTOS`, `SEQUENCE`,
  `QUIZ`) preceduta da un commento in italiano che spiega come modificarla.
  Mantieni questo schema: la configurazione separata dalla logica.
- Palette condivisa fra le tre pagine, in `:root`: `--paper #DDE3E6`,
  `--ink #10222B`, `--uv #5B3FD1`, `--muted #5E727C`. Serif Georgia per i titoli,
  sans di sistema per l'interfaccia.
- Gli script bash mettono le parti configurabili in cima, sotto un commento che
  spiega cosa toccare e cosa no.
- Ogni sezione (ogni `stepN`) ha un `README.txt`: è il primo file da
  aprire e contiene le istruzioni di quel passaggio. Il briefing di `start.sh` e
  `manual.txt` insegnano a chi gioca ad aprirlo per primo, e ogni `README.txt` finisce
  indicando come passare alla sezione successiva. Non spostare le istruzioni altrove né
  cambiarne il nome.

---

## Cosa non fare

- Non spoilerare: questo repo contiene tutte le soluzioni. Sul portatile del giorno va
  solo `output/caccia/`, mai il repo.
- Non "modernizzare" (React, build tool, moduli ES, Tailwind). La semplicità qui è
  un requisito, non un limite da superare.
- Non rinominare `stepN`: `build.sh` costruisce i nomi degli archivi da quel
  pattern.
- Non riformattare i file di testo che legge chi gioca: sono allineati a mano per
  essere leggibili in un terminale a larghezza fissa. La larghezza è **72 colonne**
  (README, manuale, campioni, briefing, script e referto): cornici di `=` lunghe 72,
  titoli centrati su 72, nessuna riga stampata oltre.
- Non ripetere fra sezioni lo stesso aneddoto: quello che è una domanda del quiz, della
  seduta o una chiave non ricompare nel quaderno o altrove, perché lo anticiperebbe.
