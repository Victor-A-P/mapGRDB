# MapGRDBInfo

##
![App icon](appIcon.png)

### Origin of the idea ￼

The need to manage locations flexibly and persistently.

The app connects to MapKit to search and select locations and to GRDB/SQLite to persist the information, storing data in a local DB (SQLite via GRDB) to ensure access and reliability.

Inspired by the app from the SwiftfulThinking course, MapGRDB improves the experience in adding locations and reliable persistence with a clear interface and consistent organization. Data is stored in SQLite (tables managed with GRDB).

### Technologies ￼
- Platform: iOS
- Language and UI: Swift, SwiftUI
- Integrations: MapKit, GRDB, SQLite
- Persistence: Local SQLite (GRDB)
- Architecture: MVVM

### Purpose ￼

MapGRDB helps add and organize locations found via map search, simplifying the capture of geographic data and metadata and keeping your information organized and accessible.

|![ubicación muestra 1](mpLocation1.png)|![ubicación muestra 2](mpLocation2.png)|
|:-:|:-:|

#### Map and search ￼

It lets you search locations with MapKit, view results on the map, and select a point of interest. The user can fill in the required information (name, notes, coordinates) before saving. It adds value by centralizing capture and persistence in a clear flow.

|![](searchLocation.png)|![](listUpdated.png)| ![](details.png)|![](details2.png)|![](opinionView.png)|
|:-:|:-:|:-:|:-:|:-:|

#### Planned features ￼
> AppStatus 
> - Share extension: Access from the contextual “Share” menu to add locations from other apps.
> - Location detection: Ability to identify locations automatically and prefill relevant data.
> - Add Files and Folder / photos selection for images of the places
