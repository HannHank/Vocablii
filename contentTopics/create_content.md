# Du willst content hinzufügen? 🥳

Hier sind ein paar Hinweise wie du uns helfen kannst:

- Schau nach, ob jemand anderes schon ähnliche Inhalte hinzugefügt hat
- Wenn du ein Topic findest für dass es noch keine Zusammenfassung gibt freuen wir uns über deinen Beitrag
- Wenn es schon Inhalte zu einem Topic gibt, du aber einen Fehler findest oder die Inhalte ergänzen möchtest hilft uns das ebenfalls sehr

## Neue Inhalte hinzufügen
Bei neuen Inhalten ist der erste Schritt, dich über das Thema zu informieren und das gelernte in Stichpunkten festzuhalten. Dabei solltest du darauf achten, dass keine falschen Informationen in den Stichpunkten enthalten sind und diese einen guten Überblick über das Thema geben.

Wir speichern die Zusammenfassungen in einem Dateiformat namens Markdown. Um ein Markdown file zu erstellen empfehlen wir [github gist](https://gist.github.com) oder [hackmd](https://hackmd.io). Wenn du keine Erfahrung mit Markdown hast haben wir dir weiter unten die wichtigsten Infos zusammengefasst.

Wenn dein Markdown file fertig ist kannst du es entweder an einen der Admins schicken oder einen Pull Request auf github eröffnen. Weitere Infos dazu findest du weiter unten.

## Bestehende Inhalte erweitern
Wenn du einen Fehler in einer Zusammenfassung findest oder gerne mehr Informationen hinzufügen würdest kannst du einen Admin anschreiben oder einen Issue auf github erstellen. Weitere Infos zu Issues findest du weiter unten.

Nachdem der Admin sich den Fehler angesehen hat gibt er dir eine Rückmeldung.

## Zusammenfassung Markdown
**\#** werden für Überschriften verwendet. Je mehr \# du aneinander reihst, desto kleiner wird die Überschrift (**\### kleine Überschrift**)

**\-** werdern für Listen verwendet. Du kannst Listen strukturieren, in dem du unterpunkte mit der **Tab** Taste einrückst.

**\*** machen den Text *italic*

**\*\*** machen den Text **bold**

Eine komplette Liste der Funktionen von Markdown findest du [hier](https://guides.github.com/features/mastering-markdown/).

## Einen Issue erstellen
Bitte versuche dich zu vergewissern, dass es keinen ähnlichen Issue bereits gibt. Du kannst in dem Suchfeld nach Issues suchen und sollte es einen ähnlichen Issue bereits geben unter diesem kommentieren.

Um einen Issue zu erstellen gehe auf die [Issue Seite](https://github.com/HannHank/Vocablii/issues) unseres Projektes. Klicke auf "New Issue" und wähle eine Vorlage für deinen Issue aus.

Danach kannst du in Markdown ein Problem oder Fehler beschreiben. Folge dazu einfach der Vorlage. Der Titel sollte das Problem kurz und verständlich erklären, wärend die Textbox für eine ausführliche Beschreibung vorgesehen ist.

Wenn du den Fehler oder deinen Verbesserungsvorschlag beschrieben hat klicke auf "Submit Issue".

## Einen Pull Request erstellen
Um selbst Datein zu dem Projekt hinzufügen zu können musst du zuerst einen Fork des [Quellcodes](https://github.com/HannHank/Vocablii) auf github erstellen. Klicke dazu einfach auf den Fork button oben rechts.

Danach musst du die Kopie des Quellcodes auf deinen Rechner laden. Nutze dazu den Befehl `git clone https://github.com/<benutzername>/Vocablii.git`. In dem Ordner "Vokablii" kannst du dann Änderungen vornehmen.

Wenn du fertig bist kannst du mit `git add . && git commit -m '<Nachricht mit Änderungen>' && git push` deine veränderte Version hochladen.

In dem [Originalrepository](https://github.com/HannHank/Vocablii/pulls) kannst du jetzt einen Pull Request machen. Klicke dazu auf "New Pull Request" und klicke dann unter der Überschrift auf "compare across forks". Rechts des Pfeiles kannst du jetzt deine Kopie auswählen und auf "Create new pull request" klicken. Danach kannst du einen Titel und eine Beschreibung des Pull Requests eingeben und auf "Create Pull Request" klicken