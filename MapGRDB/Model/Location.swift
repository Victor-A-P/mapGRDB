import Foundation
import MapKit
import GRDB

struct Location: Identifiable, Equatable, Codable
{
        var id: Int64?
        let uuid: UUID
        let name: String
        let cityName: String
        let latitude: Double
        let longitude: Double
        let description: String
        let imageNames: String // JSON string de array
        let link: String
        var opinion: String
        var recomendar: Bool
        var visitadoEnMes: Bool
        var visitado: Bool
        
        // MARK: - Propiedades Computadas
        
        /// Propiedad computada para las coordenadas del mapa
        var coordinates: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        /// Propiedad computada para convertir el JSON string a array de nombres de imágenes
        var imageNamesArray: [String] {
            get {
                (try? JSONDecoder().decode([String].self, from: imageNames.data(using: .utf8) ?? Data())) ?? []
            }
        }
        
        // MARK: - Inicializadores
        
        /// Inicializador completo con valores por defecto para nuevos campos
        init(
            id: Int64? = nil,
            uuid: UUID = UUID(),
            name: String,
            cityName: String,
            latitude: Double,
            longitude: Double,
            description: String,
            imageNames: [String],
            link: String,
            opinion: String = "",
            recomendar: Bool = false,
            visitadoEnMes: Bool = false,
            visitado: Bool = false
        ) {
            self.id = id
            self.uuid = uuid
            self.name = name
            self.cityName = cityName
            self.latitude = latitude
            self.longitude = longitude
            self.description = description
            // Convertimos el array a JSON string para almacenar en SQLite
            self.imageNames = (try? String(data: JSONEncoder().encode(imageNames), encoding: .utf8)) ?? "[]"
            self.link = link
            self.opinion = opinion
            self.recomendar = recomendar
            self.visitadoEnMes = visitadoEnMes
            self.visitado = visitado
        }
        
        // MARK: - Conformance a Equatable
        
        static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.uuid == rhs.uuid
        }
    }

    // MARK: - GRDB Extensions

    extension Location: FetchableRecord, MutablePersistableRecord {
        /// Nombre de la tabla en SQLite
        static let databaseTableName = "location"
        
        /// Enum para acceder a las columnas de forma segura
        enum Columns {
            static let id = Column("id")
            static let uuid = Column("uuid")
            static let name = Column("name")
            static let cityName = Column("cityName")
            static let latitude = Column("latitude")
            static let longitude = Column("longitude")
            static let description = Column("description")
            static let imageNames = Column("imageNames")
            static let link = Column("link")
            static let opinion = Column("opinion")
            static let recomendar = Column("recomendar")
            static let visitadoEnMes = Column("visitadoEnMes")
            static let visitado = Column("visitado")
        }
        
        /// Método llamado después de insertar un registro
        /// Actualiza el ID local con el ID generado por SQLite
        mutating func didInsert(_ inserted: InsertionSuccess) {
            id = inserted.rowID
        }
    }
