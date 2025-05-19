# IMat Flutter App

En enkel online–mataffärsapp byggd med Flutter, speciellt anpassad för seniorer (som våra personas Hjördis & Rune). Appen fokuserar på en tydlig layout, stora knappar och enkel navigering.

## Innehållsförteckning

- [Funktioner](#funktioner)
- [Personas](#personas)
- [Kom igång](#kom-igång)
  - [Förutsättningar](#förutsättningar)
  - [Installation](#installation)
  - [Konfiguration](#konfiguration)
  - [Kör appen](#kör-appen)
- [Projektstruktur](#projekt-struktur)
- [Skärmdumpar](#skärmdumpar)
- [Licens](#licens)

## Funktioner

* Produktkatalog presenterad i ett `GridView`.
* Möjlighet att filtrera och sortera produkter samt markera favoriter.
* Anpassad layout med tre kolumner för bättre översikt.
* Enkel varukorgspanel med tydlig orderknapp.
* State management hanteras med Provider-paketet.
* Tillgänglighetsanpassade typsnitt och knappar för ökad läsbarhet och användarvänlighet.

## Personas

Appen är designad med följande användarpersonas i åtanke:

**Hjördis, 78 år, och Rune, 77 år:**
Seniorer med potentiellt nedsatt syn och grundläggande datorvana. För att möta deras behov har appen:

* Större produktkort och färre kolumner för enklare visuell bearbetning.
* Stora och tydliga knappar (minst `48px` i höjd).
* Klar och tydlig text utan störande eller blinkande animationer.
* Ett enkelt dialogfönster för "Mer info" om produkter.

## Kom igång

Följ dessa steg för att få igång appen på din lokala maskin.

### Förutsättningar

Se till att du har följande programvara installerad:

* Flutter SDK (version 2.10 eller senare)
* Dart SDK (kommer med Flutter)
* En Android-emulator/enhet eller en iOS-simulator/enhet (valfritt för utveckling, nödvändigt för att köra)

### Installation

1.  **Klona repot:**
    ```bash
    git clone [https://github.com/BubbaTamer/Project---Design-och-kontruktion-av-grafiska-gr-nssnitt.git](https://github.com/BubbaTamer/Project---Design-och-kontruktion-av-grafiska-gr-nssnitt.git)
    ```

2.  **Navigera till projektmappen:**
    ```bash
    cd Project---Design-och-kontruktion-av-grafiska-gr-nssnitt
    ```

3.  **Hämta beroenden:**
    ```bash
    flutter pub get
    ```

### Konfiguration

För att appen ska fungera korrekt med backend-tjänsten behöver du konfigurera ditt gruppnummer.

1.  Öppna filen `lib/model/imat/settings.dart`.
2.  Uppdatera värdet för `groupId` till ditt tilldelade gruppnummer:

    ```dart
    // lib/model/imat/settings.dart
    class Settings {
      static const int groupId = 11; // Ändra 11 till ditt gruppnummer
    }
    ```

### Kör appen

När installation och konfiguration är klar kan du starta appen med följande kommando:

```bash
flutter run
```

### Projekt struktur

Projektet har följande mappstruktur:

```
Project---Design-och-kontruktion-av-grafiska-gr-nssnitt/
├── lib/
│   ├── main.dart                 # Appens startpunkt (entrypoint)
│   ├── app_theme.dart            # Definitioner för färger, padding, textstilar etc.
│   ├── model/                    # Datamodeller och datahanterare
│   │   ├── imat_data_handler.dart  # Hanterar logik för IMat-data
│   │   ├── imat/                   # Dataklasser för Produkt, Kund, Order etc.
│   │   └── settings.dart           # Inställningar (t.ex. groupId)
│   ├── pages/
│   │   └── main_view.dart          # Huvudlayouten med sidofält och grid-vy
│   └── widgets/                  # Återanvändbara UI-komponenter
│       ├── category_sidebar.dart   # Sidofält för produktkategorier
│       ├── filter_bar.dart         # Filteringsalternativ
│       ├── product_grid.dart       # Grid-vy för produkter
│       ├── cart_sidebar.dart       # Sidofält för varukorgen
│       └── product_card.dart       # Produktkort och dess underkomponenter
├── pubspec.yaml                  # Projektets beroenden och metadata
└── README.md                     # Denna fil
```

### Skärmdumpar

![image](https://github.com/user-attachments/assets/4d956723-b915-45fa-9a3e-1e85094c7c45)


### Licens
Unlicensed and private.
