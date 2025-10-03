import SwiftUI
import MapKit

struct LocationDetail: View {
    @EnvironmentObject var viewM: LocationViewModel
    @Environment(\.dismiss) var dismiss
    
    let location: Location
    
    @State private var opinion: String
    @State private var showOpinionEditor = false
    
    init(location: Location) {
        self.location = location
        _opinion = State(initialValue: location.opinion)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                imageDetails
                
                VStack(alignment: .leading, spacing: 16) {
                    locationCityName
                    
                    Divider()
                    
                    // Controles de estado
                    statusControls
                    
                    Divider()
                    
                    // Sección de opinión
                    opinionSection
                    
                    Divider()
                    
                    descriptionLocation
                    
                    Divider()
                    
                    mapOfLocation
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea(.all)
        .background(.ultraThinMaterial)
        .overlay(exitButton, alignment: .topLeading)
        .sheet(isPresented: $showOpinionEditor) {
            OpinionEditorView(opinion: $opinion) {
                viewM.updateOpinion(for: location, opinion: opinion)
            }
        }
    }
}

// MARK: - View Components
extension LocationDetail {
    
    /// Controles interactivos para cambiar el estado de la ubicación
    var statusControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Estado de la Ubicación")
                .font(.headline)
            
            HStack(spacing: 16) {
                // Botón de Visitado
                Button {
                    viewM.toggleVisitado(for: location)
                } label: {
                    HStack {
                        Image(systemName: location.visitado ? "checkmark.circle.fill" : "circle")
                        Text("Visitado")
                    }
                    .foregroundStyle(location.visitado ? .green : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(location.visitado ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Botón de Recomendado
                Button {
                    viewM.toggleRecomendar(for: location)
                } label: {
                    HStack {
                        Image(systemName: location.recomendar ? "star.fill" : "star")
                        Text("Recomendar")
                    }
                    .foregroundStyle(location.recomendar ? .yellow : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(location.recomendar ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            // Botón de Visitado en Mes
            Button {
                viewM.toggleVisitadoEnMes(for: location)
            } label: {
                HStack {
                    Image(systemName: location.visitadoEnMes ? "calendar.badge.clock" : "calendar")
                    Text("Visitado este mes")
                }
                .foregroundStyle(location.visitadoEnMes ? .orange : .secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(location.visitadoEnMes ? Color.orange.opacity(0.2) : Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
    
    /// Sección para mostrar y editar opiniones
    var opinionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Mi Opinión")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    showOpinionEditor = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            
            if opinion.isEmpty {
                Text("No has agregado una opinión aún")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                Text(opinion)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
            }
        }
    }
    
    /// Mini mapa mostrando la ubicación exacta
    var mapOfLocation: some View {
        Map(
            coordinateRegion: .constant(MKCoordinateRegion(
                center: location.coordinates,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )),
            annotationItems: [location]
        ) { location in
            MapAnnotation(coordinate: location.coordinates) {
                PinLocationMapView()
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
    }
    
    /// Descripción y enlace a Wikipedia
    var descriptionLocation: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.description)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            if let url = URL(string: location.link) {
                Link("Para saber más, entra a Wikipedia 🔗", destination: url)
                    .fontWeight(.bold)
                    .foregroundStyle(.blue)
            }
        }
    }
    
    /// Nombre y ciudad del lugar
    var locationCityName: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(location.cityName)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
   
    /// Galería de imágenes con TabView
    var imageDetails: some View {
        TabView {
            ForEach(location.imageNamesArray, id: \.self) {
                Image($0)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    /// Botón para cerrar la vista
    var exitButton: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.title)
                .foregroundColor(.primary)
                .padding()
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
        }
    }
}

#Preview {
    LocationDetail(location: Location(
        name: "Colosseum",
        cityName: "Rome",
        latitude: 41.8902,
        longitude: 12.4922,
        description: "Ancient amphitheatre in Rome",
        imageNames: ["rome-colosseum-1"],
        link: "https://example.com"
    ))
    .environmentObject(LocationViewModel())
}
