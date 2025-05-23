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
    git clone [ttps://github.com/BubbaTamer/Project---Design-och-kontruktion-av-grafiska-gr-nssnitt.git
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
└── 📁Project---Design-och-kontruktion-av-grafiska-gr-nssnitt # Root folder for your Flutter project.
    ├── 📁lib # This is where most of your Dart code lives. The heart of your app.
    │   ├── app_theme.dart # Defines the visual theme (colors, fonts) for the app.
    │   ├── main.dart # The main entry point of your Flutter application.
    │   ├── 📁model # Contains data models (classes) and data handling logic.
    │   │   ├── imat_data_handler.dart # Likely handles interactions with a backend/API (IMat).
    │   │   ├── internet_handler.dart # Manages internet connectivity checks or requests.
    │   │   ├── credit_card.dart # Model for credit card data.
    │   │   ├── customer.dart # Model for customer data.
    │   │   ├── order.dart # Model for order data.
    │   │   ├── product.dart # Model for product data.
    │   │   ├── shopping_cart.dart # Model/Logic for the shopping cart.
    │   │   └── user.dart # Model for user data.
    │   ├── 📁pages # Contains the main screens or views of your application.
    │   │   ├── main_view.dart # The primary view/screen (e.g., product Browse).
    │   │   ├── order_history_view.dart # Screen to display past orders.
    │   │   └── shopping_cart_view.dart # Screen for the shopping cart.
    │   └── 📁widgets # Contains reusable UI components (widgets).
    │       ├── 📁main # Widgets used in the main_view.
    │       │   ├── category_sidebar.dart # Sidebar for product categories.
    │       │   ├── product_card.dart # A card to display a single product.
    │       │   └── product_grid.dart # Grid layout to display multiple products.
    │       ├── 📁order_history # Widgets used in the order_history_view.
    │       │   └── order_card.dart # A card to display a single order.
    │       └── 📁shared # Widgets that can be used across multiple pages.
    │           ├── cart_sidebar.dart # Sidebar for the shopping cart.
    │           └── custom_appbar.dart # A custom application bar.
    ├── pubspec.yaml # Project metadata, dependencies (packages), and asset declarations.
    ├── pubspec.lock # Automatically generated, lists exact versions of all dependencies.
    └── analysis_options.yaml # Configuration for Dart static analysis (linter rules).
```

### Skärmdumpar

#### Startsida
![image](https://github.com/user-attachments/assets/3266486d-6036-48c9-b9f0-4753bc073aaf)


#### Tidigare Beställningar
![image](https://github.com/user-attachments/assets/502e4157-ec85-4630-acc1-d8674d5d9ba1)


#### Mina Favoriter
![image](https://github.com/user-attachments/assets/965f6d69-8c50-41cf-aab2-63dc993b8a0c)




### Licens
Unlicensed and private.
