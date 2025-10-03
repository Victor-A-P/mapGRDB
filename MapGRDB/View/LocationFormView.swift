
import SwiftUI
import MapKit

struct LocationFormView: View {
    @Environment(\.dismiss) var dismiss
    
    let mapItem: MKMapItem
    let onSave: (Location) -> Void
    
    @State private var name: String = ""
    @State private var cityName: String = ""
    @State private var description: String = ""
    @State private var link: String = ""
    @State private var imageNamesText: String = ""
    
    init(mapItem: MKMapItem, onSave: @escaping (Location) -> Void) {
        self.mapItem = mapItem
        self.onSave = onSave
        
        // Pre-llenar con información del mapItem
        _name = State(initialValue: mapItem.name ?? "")
        _cityName = State(initialValue: mapItem.placemark.locality ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Información Básica") {
                    TextField("Nombre del lugar", text: $name)
                    TextField("Ciudad", text: $cityName)
                }
                
                Section("Coordenadas") {
                    HStack {
                        Text("Latitud:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "%.6f", mapItem.placemark.coordinate.latitude))
                    }
                    
                    HStack {
                        Text("Longitud:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "%.6f", mapItem.placemark.coordinate.longitude))
                    }
                }
                
                Section("Descripción") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
                
                Section("Información Adicional") {
                    TextField("Enlace (Wikipedia u otro)", text: $link)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    TextField("Nombres de imágenes (separados por comas)", text: $imageNamesText)
                        .autocapitalization(.none)
                }
                
                Section {
                    Text("💡 Tip: Agrega nombres de imágenes que estén en tu proyecto. Ejemplo: image1, image2, image3")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Nueva Ubicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveLocation()
                    }
                    .fontWeight(.bold)
                    .disabled(name.isEmpty || cityName.isEmpty)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func saveLocation() {
        // Procesar nombres de imágenes
        let imageNames = imageNamesText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        // Crear nueva ubicación
        let newLocation = Location(
            name: name,
            cityName: cityName,
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude,
            description: description.isEmpty ? "Sin descripción" : description,
            imageNames: imageNames.isEmpty ? ["placeholder"] : imageNames,
            link: link.isEmpty ? "https://www.google.com/maps" : link
        )
        
        onSave(newLocation)
        dismiss()
    }
}

#Preview {
    let sampleMapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332)))
    sampleMapItem.name = "Ejemplo"
    
    return LocationFormView(mapItem: sampleMapItem) { location in
        print("Nueva ubicación guardada: \(location.name)")
    }
}
