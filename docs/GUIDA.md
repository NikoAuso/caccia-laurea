# Guida del giorno — la caccia al tesoro

Il giorno della festa · **contiene tutte le password: tienila sul telefono, non sul tavolo**

## Al bar, prima che arrivi chi gioca

- [ ] Busta 1 attaccata con il nastro sotto il piano del tavolo, dal lato di chi gioca
- [ ] Busta 2 al barista, con l'accordo: alla frase "UN REAGENTE BIANCO" versa lo shot, controlla che venga bevuto tutto e solo dopo consegna la busta
- [ ] Da bere per chi gioca, per i sorsi di penitenza
- [ ] Terminale aperto nella cartella `caccia`, testo ingrandito con Ctrl e +, `bash start.sh` lanciato e briefing lasciato a schermo
- [ ] Accanto al terminale, una finestra dei file aperta su `caccia`: le pagine `.html` si aprono con il doppio clic da lì

## Le password

Sempre in maiuscolo, con il trattino. La password trovata in uno step apre quello successivo; lo Step 9 non ha password.

| Step | Password | Dove la trova |
| --- | --- | --- |
| Step 1 — Registro di laboratorio | PASSWORD-1 | file nascosto `.protocol` |
| Step 2 — Imaging dei campioni | PASSWORD-2 | lettere delle foto della magistrale |
| Step 3 — Recupero del registro | PASSWORD-3 | in un ricordo in cima al quaderno, unica parola in maiuscolo |
| Step 4 — Viva voce | PASSWORD-4 | alla fine di `viva.sh` |
| Step 5 — Ricerca nell'archivio | PASSWORD-5 | busta 1, sotto il tavolo |
| Step 6 — Triage dei campioni | PASSWORD-6 | busta 2, dal barista |
| Step 7 — Discussione della tesi | PASSWORD-7 | quiz superato |
| Step 8 — Presenza a distanza | PASSWORD-8 | parole del montaggio, attaccate |

## Se si blocca

Prima si rimanda al README dello step, poi si dà l'aiuto, e solo alla fine la soluzione.

| Step | Cosa deve fare | Aiuto |
| --- | --- | --- |
| 1 | `ls -a`, poi `cat .protocol`, poi `unzip step2.zip` | il manuale ha un'opzione di `ls` per i file nascosti |
| 2 | aprire `gallery.html`, segnare le foto con data da ottobre 2024 in poi, leggere le lettere in alto | "controllo qualità" vuol dire foto della magistrale; ogni foto sbagliata è un sorso |
| 3 | da `step3`: `mv ../logbook.txt .`, poi `head -n 31 logbook.txt` e `tail -n 26 logbook.txt` | il registro è rimasto in `step2`; l'ultima voce rimanda ai ricordi in cima: la password è l'unica parola in maiuscolo |
| 4 | `bash viva.sh` e rispondere a chi viene chiamato | dopo tre errori la domanda passa comunque; risposte in ordine: lisbona, lasagne, fibroblasti, tazze, panda |
| 5 | `grep GR2026 archive.csv`, poi guardare sotto il tavolo | lo "strumento che legge per te" è `grep`, nel manuale |
| 6 | `cat` dei sette campioni; quello giusto è E: al bancone dice "UN REAGENTE BIANCO" | il G sembra suo ma è vuoto |
| 7 | aprire `defense.html` e rispondere giusto a tutte | risposte in ordine: C B B C B A B B A C |
| 8 | aprire `messages.html`, premere Play, guardare fino alla fine | le parole a schermo intero, in ordine e attaccate, sono la password: PASSWORD-8 |
| 9 | da `step9`:<br>`cp ../../../../../../../../specimen.dat .`<br>poi `bash thesis_defense.sh`; al brindisi ci si alza e si preme Invio | otto volte `..`, una per ogni step sopra; se dice "sequenziatore vuoto", il campione non è stato copiato |

## Se qualcosa va storto

| Problema | Soluzione |
| --- | --- |
| "incorrect password" | sta scrivendo in minuscolo, o c'è un refuso |
| una pagina non si apre col doppio clic | trascinala dentro una finestra del browser |
| un video non parte | ci sono i pulsanti Avanti e le frecce: si va avanti lo stesso |
| una foto non compare | resta un riquadro tratteggiato, la lettera si legge lo stesso |
| serve accorciare | salta lo Step 4 e detta PASSWORD-4 |

**Sblocco d'emergenza.** Dalla cartella in cui c'è lo zip, si apre qualsiasi step a mano con la password dello step prima. Per esempio, per lo Step 4:

```bash
unzip -P PASSWORD-3 step4.zip
```
