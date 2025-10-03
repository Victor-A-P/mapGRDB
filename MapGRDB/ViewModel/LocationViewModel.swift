//import SwiftUI
//import MapKit
//import Combine
//
//class LocationViewModel: ObservableObject
//{
//    
//    // MARK: - Published Properties
//    
//    /// Array de todas las ubicaciones cargadas desde la base de datos
//    @Published var locations: [Location] = []
//    
//    /// Ubicación actualmente seleccionada en el mapa
//    @Published var mapLocation: Location? {
//        didSet {
//            if let location = mapLocation {
//                updateMapRegion(to: location)
//            }
//        }
//    }
//    
//    /// Región visible del mapa
//    @Published var mapRegion = MKCoordinateRegion()
//    
//    /// Controla la visibilidad de la lista de ubicaciones
//    @Published var showLocationList: Bool = false
//    
//    /// Ubicación para mostrar en el sheet de detalles
//    @Published var isShowingDetailsSheet: Location? = nil
//    
//    // MARK: - Private Properties
//    
//    /// Referencia al gestor de base de datos
//    private let databaseManager = DatabaseManager.shared
//    
//    /// Zoom del mapa sobre la ubicación
//    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//    
//    // MARK: - Initialization
//    
//    init() {
//        loadLocations()
//    }
//    
//    // MARK: - Database Operations
//    
//    /**
//     Carga todas las ubicaciones desde la base de datos
//     */
//    func loadLocations() {
//        do {
//            // Inicializa la base de datos con datos de ejemplo si está vacía
//            try databaseManager.seedDatabaseIfEmpty()
//            
//            // Carga todas las ubicaciones
//            locations = try databaseManager.getAllLocations()
//            
//            // Establece la primera ubicación como actual si existe
//            if let firstLocation = locations.first {
//                mapLocation = firstLocation
//                updateMapRegion(to: firstLocation)
//            }
//            
//            print("📍 Cargadas \(locations.count) ubicaciones")
//        } catch {
//            print("❌ Error al cargar ubicaciones: \(error)")
//        }
//    }
//    
//    /**
//     Actualiza la opinión de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//        - opinion: El nuevo texto de opinión
//     */
//    func updateOpinion(for location: Location, opinion: String) {
//        do {
//            try databaseManager.updateOpinion(withUUID: location.uuid, opinion: opinion)
//            loadLocations() // Recarga las ubicaciones para reflejar los cambios
//        } catch {
//            print("❌ Error al actualizar opinión: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de recomendación de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleRecomendar(for location: Location) {
//        do {
//            try databaseManager.toggleRecomendar(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar recomendación: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de "visitado en el mes" de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleVisitadoEnMes(for location: Location) {
//        do {
//            try databaseManager.toggleVisitadoEnMes(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar visitado en mes: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de "visitado" de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleVisitado(for location: Location) {
//        do {
//            try databaseManager.toggleVisitado(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar visitado: \(error)")
//        }
//    }
//    
//    /**
//     Elimina una ubicación de la base de datos
//     
//     - Parameters:
//        - location: La ubicación a eliminar
//     */
//    func deleteLocation(_ location: Location) {
//        do {
//            try databaseManager.deleteLocation(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al eliminar ubicación: \(error)")
//        }
//    }
//    
//    // MARK: - UI Operations
//    
//    /**
//     Actualiza la región del mapa para centrarla en una ubicación específica
//     
//     - Parameters:
//        - location: La ubicación en la que centrar el mapa
//     */
//    func updateMapRegion(to location: Location) {
//        withAnimation(.spring()) {
//            mapRegion = MKCoordinateRegion(
//                center: location.coordinates,
//                span: mapSpan
//            )
//        }
//    }
//    
//    /**
//     Alterna la visibilidad de la lista de ubicaciones
//     */
//    func toggleLocationList() {
//        withAnimation(.spring()) {
//            showLocationList.toggle()
//        }
//    }
//    
//    /**
//     Muestra una ubicación específica en el mapa y oculta la lista
//     
//     - Parameters:
//        - location: La ubicación a mostrar
//     */
//    func showNextLocation(_ location: Location) {
//        withAnimation(.spring()) {
//            mapLocation = location
//            showLocationList = false
//        }
//    }
//    
//    /**
//     Avanza a la siguiente ubicación en la lista
//     Si se está en la última ubicación, vuelve a la primera
//     */
//    func nextButtonPressed() {
//        guard let currentLocation = mapLocation,
//              let currentIndex = locations.firstIndex(where: { $0.uuid == currentLocation.uuid })
//        else {
//            print("❌ No se ha podido encontrar el índice en el arreglo de ubicaciones")
//            return
//        }
//        
//        let nextIndex = currentIndex + 1
//        
//        if locations.indices.contains(nextIndex) {
//            let nextLocation = locations[nextIndex]
//            showNextLocation(nextLocation)
//        } else {
//            // Si llegamos al final, volvemos al principio
//            if let firstLocation = locations.first {
//                showNextLocation(firstLocation)
//            }
//        }
//    }
//    
//    // MARK: - Filter Operations
//    
//    /**
//     Obtiene ubicaciones filtradas por estado de visitado
//     
//     - Returns: Array de ubicaciones visitadas
//     */
//    func getVisitedLocations() -> [Location] {
//        locations.filter { $0.visitado }
//    }
//    
//    /**
//     Obtiene ubicaciones filtradas por recomendación
//     
//     - Returns: Array de ubicaciones recomendadas
//     */
//    func getRecommendedLocations() -> [Location] {
//        locations.filter { $0.recomendar }
//    }
//}

//import SwiftUI
//import MapKit
//import Combine
//
//class LocationViewModel: ObservableObject {
//    
//    // MARK: - Published Properties
//    
//    /// Array de todas las ubicaciones cargadas desde la base de datos
//    @Published var locations: [Location] = []
//    
//    /// Ubicación actualmente seleccionada en el mapa
//    @Published var mapLocation: Location? {
//        didSet {
//            if let location = mapLocation {
//                updateMapRegion(to: location)
//            }
//        }
//    }
//    
//    /// Región visible del mapa
//    @Published var mapRegion = MKCoordinateRegion()
//    
//    /// Controla la visibilidad de la lista de ubicaciones
//    @Published var showLocationList: Bool = false
//    
//    /// Ubicación para mostrar en el sheet de detalles
//    @Published var isShowingDetailsSheet: Location? = nil
//    
//    // MARK: - Private Properties
//    
//    /// Referencia al gestor de base de datos
//    private let databaseManager = DatabaseManager.shared
//    
//    /// Zoom del mapa sobre la ubicación
//    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//    
//    // MARK: - Initialization
//    
//    init() {
//        loadLocations()
//    }
//    
//    // MARK: - Database Operations
//    
//    /**
//     Carga todas las ubicaciones desde la base de datos
//     */
//    func loadLocations() {
//        do {
//            // Inicializa la base de datos con datos de ejemplo si está vacía
//            try databaseManager.seedDatabaseIfEmpty()
//            
//            // Carga todas las ubicaciones
//            locations = try databaseManager.getAllLocations()
//            
//            // Establece la primera ubicación como actual si existe
//            if let firstLocation = locations.first {
//                mapLocation = firstLocation
//                updateMapRegion(to: firstLocation)
//            }
//            
//            print("📍 Cargadas \(locations.count) ubicaciones")
//        } catch {
//            print("❌ Error al cargar ubicaciones: \(error)")
//        }
//    }
//    
//    /**
//     Actualiza la opinión de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//        - opinion: El nuevo texto de opinión
//     */
//    func updateOpinion(for location: Location, opinion: String) {
//        do {
//            try databaseManager.updateOpinion(withUUID: location.uuid, opinion: opinion)
//            loadLocations() // Recarga las ubicaciones para reflejar los cambios
//        } catch {
//            print("❌ Error al actualizar opinión: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de recomendación de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleRecomendar(for location: Location) {
//        do {
//            try databaseManager.toggleRecomendar(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar recomendación: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de "visitado en el mes" de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleVisitadoEnMes(for location: Location) {
//        do {
//            try databaseManager.toggleVisitadoEnMes(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar visitado en mes: \(error)")
//        }
//    }
//    
//    /**
//     Alterna el estado de "visitado" de una ubicación
//     
//     - Parameters:
//        - location: La ubicación a actualizar
//     */
//    func toggleVisitado(for location: Location) {
//        do {
//            try databaseManager.toggleVisitado(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al actualizar visitado: \(error)")
//        }
//    }
//    
//    /**
//     Elimina una ubicación de la base de datos
//     
//     - Parameters:
//        - location: La ubicación a eliminar
//     */
//    func deleteLocation(_ location: Location) {
//        do {
//            try databaseManager.deleteLocation(withUUID: location.uuid)
//            loadLocations()
//        } catch {
//            print("❌ Error al eliminar ubicación: \(error)")
//        }
//    }
//    
//    /**
//     Agrega una nueva ubicación a la base de datos
//     
//     - Parameters:
//        - location: La nueva ubicación a agregar
//     */
//    func addLocation(_ location: Location) {
//        do {
//            _ = try databaseManager.createLocation(
//                name: location.name,
//                cityName: location.cityName,
//                latitude: location.latitude,
//                longitude: location.longitude,
//                description: location.description,
//                imageNames: location.imageNamesArray,
//                link: location.link
//            )
//            loadLocations()
//            
//            // Selecciona la nueva ubicación en el mapa
//            if let newLocation = locations.first(where: { $0.name == location.name && $0.cityName == location.cityName }) {
//                showNextLocation(newLocation)
//            }
//        } catch {
//            print("❌ Error al agregar ubicación: \(error)")
//        }
//    }
//    
//    // MARK: - UI Operations
//    
//    /**
//     Actualiza la región del mapa para centrarla en una ubicación específica
//     
//     - Parameters:
//        - location: La ubicación en la que centrar el mapa
//     */
//    func updateMapRegion(to location: Location) {
//        withAnimation(.spring()) {
//            mapRegion = MKCoordinateRegion(
//                center: location.coordinates,
//                span: mapSpan
//            )
//        }
//    }
//    
//    /**
//     Alterna la visibilidad de la lista de ubicaciones
//     */
//    func toggleLocationList() {
//        withAnimation(.spring()) {
//            showLocationList.toggle()
//        }
//    }
//    
//    /**
//     Muestra una ubicación específica en el mapa y oculta la lista
//     
//     - Parameters:
//        - location: La ubicación a mostrar
//     */
//    func showNextLocation(_ location: Location) {
//        withAnimation(.spring()) {
//            mapLocation = location
//            showLocationList = false
//        }
//    }
//    
//    /**
//     Avanza a la siguiente ubicación en la lista
//     Si se está en la última ubicación, vuelve a la primera
//     */
//    func nextButtonPressed() {
//        guard let currentLocation = mapLocation,
//              let currentIndex = locations.firstIndex(where: { $0.uuid == currentLocation.uuid })
//        else {
//            print("❌ No se ha podido encontrar el índice en el arreglo de ubicaciones")
//            return
//        }
//        
//        let nextIndex = currentIndex + 1
//        
//        if locations.indices.contains(nextIndex) {
//            let nextLocation = locations[nextIndex]
//            showNextLocation(nextLocation)
//        } else {
//            // Si llegamos al final, volvemos al principio
//            if let firstLocation = locations.first {
//                showNextLocation(firstLocation)
//            }
//        }
//    }
//    
//    // MARK: - Filter Operations
//    
//    /**
//     Obtiene ubicaciones filtradas por estado de visitado
//     
//     - Returns: Array de ubicaciones visitadas
//     */
//    func getVisitedLocations() -> [Location] {
//        locations.filter { $0.visitado }
//    }
//    
//    /**
//     Obtiene ubicaciones filtradas por recomendación
//     
//     - Returns: Array de ubicaciones recomendadas
//     */
//    func getRecommendedLocations() -> [Location] {
//        locations.filter { $0.recomendar }
//    }
//}


import SwiftUI
import MapKit
import Combine

    class LocationViewModel: ObservableObject {
        
        // MARK: - Published Properties
        
        @Published var locations: [Location] = []
        @Published var mapLocation: Location? {
            didSet {
                if let location = mapLocation {
                    updateMapRegion(to: location)
                }
            }
        }
        @Published var mapRegion = MKCoordinateRegion()
        @Published var showLocationList: Bool = false
        @Published var isShowingDetailsSheet: Location? = nil
        
        // MARK: - Private Properties
        
        private let databaseManager = DatabaseManager.shared
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        // MARK: - Initialization
        
        init() {
            // Ejecutar la carga en background para evitar bloquear el main thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.loadLocations()
            }
        }
        
        // MARK: - Database Operations
        
        func loadLocations() {
            do {
                // Estas operaciones se ejecutan en background
                try databaseManager.seedDatabaseIfEmpty()
                let loadedLocations = try databaseManager.getAllLocations()
                
                // Actualizar la UI en el main thread
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.locations = loadedLocations
                    
                    if let firstLocation = loadedLocations.first {
                        self.mapLocation = firstLocation
                        self.updateMapRegion(to: firstLocation)
                    }
                    
                    print("📍 Cargadas \(loadedLocations.count) ubicaciones")
                }
            } catch {
                DispatchQueue.main.async {
                    print("❌ Error al cargar ubicaciones: \(error)")
                }
            }
        }
        
        func updateOpinion(for location: Location, opinion: String) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    try self?.databaseManager.updateOpinion(withUUID: location.uuid, opinion: opinion)
                    self?.loadLocations()
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al actualizar opinión: \(error)")
                    }
                }
            }
        }
        
        func toggleRecomendar(for location: Location) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    try self?.databaseManager.toggleRecomendar(withUUID: location.uuid)
                    self?.loadLocations()
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al actualizar recomendación: \(error)")
                    }
                }
            }
        }
        
        func toggleVisitadoEnMes(for location: Location) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    try self?.databaseManager.toggleVisitadoEnMes(withUUID: location.uuid)
                    self?.loadLocations()
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al actualizar visitado en mes: \(error)")
                    }
                }
            }
        }
        
        func toggleVisitado(for location: Location) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    try self?.databaseManager.toggleVisitado(withUUID: location.uuid)
                    self?.loadLocations()
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al actualizar visitado: \(error)")
                    }
                }
            }
        }
        
        func deleteLocation(_ location: Location) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    try self?.databaseManager.deleteLocation(withUUID: location.uuid)
                    self?.loadLocations()
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al eliminar ubicación: \(error)")
                    }
                }
            }
        }
        
        func addLocation(_ location: Location) {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                do {
                    _ = try self?.databaseManager.createLocation(
                        name: location.name,
                        cityName: location.cityName,
                        latitude: location.latitude,
                        longitude: location.longitude,
                        description: location.description,
                        imageNames: location.imageNamesArray,
                        link: location.link
                    )
                    self?.loadLocations()
                    
                    // Seleccionar la nueva ubicación después de cargar
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        if let newLocation = self.locations.first(where: { $0.name == location.name && $0.cityName == location.cityName }) {
                            self.showNextLocation(newLocation)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("❌ Error al agregar ubicación: \(error)")
                    }
                }
            }
        }
        
        // MARK: - UI Operations
        
        func updateMapRegion(to location: Location) {
            withAnimation(.spring()) {
                mapRegion = MKCoordinateRegion(
                    center: location.coordinates,
                    span: mapSpan
                )
            }
        }
        
        func toggleLocationList() {
            withAnimation(.spring()) {
                showLocationList.toggle()
            }
        }
        
        func showNextLocation(_ location: Location) {
            withAnimation(.spring()) {
                mapLocation = location
                showLocationList = false
            }
        }
        
        func nextButtonPressed() {
            guard let currentLocation = mapLocation,
                  let currentIndex = locations.firstIndex(where: { $0.uuid == currentLocation.uuid })
            else {
                print("❌ No se ha podido encontrar el índice en el arreglo de ubicaciones")
                return
            }
            
            let nextIndex = currentIndex + 1
            
            if locations.indices.contains(nextIndex) {
                let nextLocation = locations[nextIndex]
                showNextLocation(nextLocation)
            } else {
                if let firstLocation = locations.first {
                    showNextLocation(firstLocation)
                }
            }
        }
        
        // MARK: - Filter Operations
        
        func getVisitedLocations() -> [Location] {
            locations.filter { $0.visitado }
        }
        
        func getRecommendedLocations() -> [Location] {
            locations.filter { $0.recomendar }
        }
    }
