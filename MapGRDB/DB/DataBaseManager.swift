import Foundation
import GRDB

    class DatabaseManager {
        
        // MARK: - Singleton
        
        static let shared = DatabaseManager()
        
        // MARK: - Properties
        
        private var dbWriter: DatabaseWriter
        
        // MARK: - Initialization
        
        private init() {
            let fileManager = FileManager.default
            let folderURL = try! fileManager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("Database", isDirectory: true)
            
            try! fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            
            let dbURL = folderURL.appendingPathComponent("locations_database.sqlite")
            print("📍 Base de datos ubicada en: \(dbURL.path)")
            
            // Crear la conexión sin configuración adicional
            dbWriter = try! DatabaseQueue(path: dbURL.path)
            
            setupDatabase()
        }
        
        // MARK: - Database Setup
        
        private func setupDatabase() {
            try! dbWriter.write { db in
                try db.create(table: "location", ifNotExists: true) { tableDefinition in
                    tableDefinition.autoIncrementedPrimaryKey("id")
                    tableDefinition.column("uuid", .text).notNull().unique()
                    tableDefinition.column("name", .text).notNull()
                    tableDefinition.column("cityName", .text).notNull()
                    tableDefinition.column("latitude", .double).notNull()
                    tableDefinition.column("longitude", .double).notNull()
                    tableDefinition.column("description", .text).notNull()
                    tableDefinition.column("imageNames", .text).notNull()
                    tableDefinition.column("link", .text).notNull()
                    tableDefinition.column("opinion", .text).notNull().defaults(to: "")
                    tableDefinition.column("recomendar", .boolean).notNull().defaults(to: false)
                    tableDefinition.column("visitadoEnMes", .boolean).notNull().defaults(to: false)
                    tableDefinition.column("visitado", .boolean).notNull().defaults(to: false)
                }
            }
        }
        
        // MARK: - CRUD Operations
        
        func getAllLocations() throws -> [Location] {
            return try dbWriter.read { db in
                try Location
                    .order(Location.Columns.name.asc)
                    .fetchAll(db)
            }
        }
        
        func createLocation(
            name: String,
            cityName: String,
            latitude: Double,
            longitude: Double,
            description: String,
            imageNames: [String],
            link: String
        ) throws -> Location {
            return try dbWriter.write { db in
                var location = Location(
                    uuid: UUID(),
                    name: name,
                    cityName: cityName,
                    latitude: latitude,
                    longitude: longitude,
                    description: description,
                    imageNames: imageNames,
                    link: link
                )
                
                try location.insert(db)
                print("✅ Ubicación creada: \(location.name)")
                return location
            }
        }
        
        func updateOpinion(withUUID uuid: UUID, opinion: String) throws {
            try dbWriter.write { db in
                if var location = try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .fetchOne(db) {
                    location.opinion = opinion
                    try location.update(db)
                    print("💬 Opinión actualizada para \(location.name)")
                }
            }
        }
        
        func toggleRecomendar(withUUID uuid: UUID) throws {
            try dbWriter.write { db in
                if var location = try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .fetchOne(db) {
                    location.recomendar.toggle()
                    try location.update(db)
                    print("⭐ Recomendación actualizada para \(location.name): \(location.recomendar)")
                }
            }
        }
        
        func toggleVisitadoEnMes(withUUID uuid: UUID) throws {
            try dbWriter.write { db in
                if var location = try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .fetchOne(db) {
                    location.visitadoEnMes.toggle()
                    try location.update(db)
                    print("📅 Estado 'visitado en mes' actualizado para \(location.name): \(location.visitadoEnMes)")
                }
            }
        }
        
        func toggleVisitado(withUUID uuid: UUID) throws {
            try dbWriter.write { db in
                if var location = try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .fetchOne(db) {
                    location.visitado.toggle()
                    try location.update(db)
                    print("✅ Estado 'visitado' actualizado para \(location.name): \(location.visitado)")
                }
            }
        }
        
        func getLocation(withUUID uuid: UUID) throws -> Location? {
            return try dbWriter.read { db in
                try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .fetchOne(db)
            }
        }
        
        func deleteLocation(withUUID uuid: UUID) throws {
            try dbWriter.write { db in
                let deleted = try Location
                    .filter(Location.Columns.uuid == uuid.uuidString)
                    .deleteAll(db)
                print("🗑️ Eliminadas \(deleted) ubicaciones con UUID \(uuid.uuidString)")
            }
        }
        
        func getVisitedLocations() throws -> [Location] {
            return try dbWriter.read { db in
                try Location
                    .filter(Location.Columns.visitado == true)
                    .order(Location.Columns.name.asc)
                    .fetchAll(db)
            }
        }
        
        func getRecommendedLocations() throws -> [Location] {
            return try dbWriter.read { db in
                try Location
                    .filter(Location.Columns.recomendar == true)
                    .order(Location.Columns.name.asc)
                    .fetchAll(db)
            }
        }
        
        // MARK: - Seed Data
        
        func seedDatabaseIfEmpty() throws {
            let count = try dbWriter.read { db in
                try Location.fetchCount(db)
            }
            
            guard count == 0 else {
                print("📍 Base de datos ya contiene \(count) ubicaciones")
                return
            }
            
            print("🌱 Inicializando base de datos con datos de ejemplo...")
            
            _ = try createLocation(
                name: "Colosseum",
                cityName: "Rome",
                latitude: 41.8902,
                longitude: 12.4922,
                description: "The Colosseum is an oval amphitheatre in the centre of the city of Rome, Italy, just east of the Roman Forum. It is the largest ancient amphitheatre ever built, and is still the largest standing amphitheatre in the world today, despite its age.",
                imageNames: ["rome-colosseum-1", "rome-colosseum-2", "rome-colosseum-3"],
                link: "https://en.wikipedia.org/wiki/Colosseum"
            )
            
            _ = try createLocation(
                name: "Pantheon",
                cityName: "Rome",
                latitude: 41.8986,
                longitude: 12.4769,
                description: "The Pantheon is a former Roman temple and since the year 609 a Catholic church, in Rome, Italy, on the site of an earlier temple commissioned by Marcus Agrippa during the reign of Augustus.",
                imageNames: ["rome-pantheon-1", "rome-pantheon-2", "rome-pantheon-3"],
                link: "https://en.wikipedia.org/wiki/Pantheon,_Rome"
            )
            
            _ = try createLocation(
                name: "Trevi Fountain",
                cityName: "Rome",
                latitude: 41.9009,
                longitude: 12.4833,
                description: "The Trevi Fountain is a fountain in the Trevi district in Rome, Italy, designed by Italian architect Nicola Salvi and completed by Giuseppe Pannini and several others. Standing 26.3 metres high and 49.15 metres wide, it is the largest Baroque fountain in the city and one of the most famous fountains in the world.",
                imageNames: ["rome-trevifountain-1", "rome-trevifountain-2", "rome-trevifountain-3"],
                link: "https://en.wikipedia.org/wiki/Trevi_Fountain"
            )
            
            _ = try createLocation(
                name: "Eiffel Tower",
                cityName: "Paris",
                latitude: 48.8584,
                longitude: 2.2945,
                description: "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower.",
                imageNames: ["paris-eiffeltower-1", "paris-eiffeltower-2"],
                link: "https://en.wikipedia.org/wiki/Eiffel_Tower"
            )
            
            _ = try createLocation(
                name: "Louvre Museum",
                cityName: "Paris",
                latitude: 48.8606,
                longitude: 2.3376,
                description: "The Louvre, or the Louvre Museum, is the world's most-visited museum and a historic monument in Paris, France.",
                imageNames: ["paris-louvre-1", "paris-louvre-2", "paris-louvre-3"],
                link: "https://en.wikipedia.org/wiki/Louvre"
            )
            
            print("✅ Base de datos inicializada con éxito")
        }
    }
