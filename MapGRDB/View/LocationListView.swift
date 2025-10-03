import SwiftUI

struct LocationListView: View
{
    @EnvironmentObject var viewM: LocationViewModel

    var body: some View {
        List {
            ForEach(viewM.locations, id: \.uuid) { location in
                Button {
                    viewM.showNextLocation(location)
                } label: {
                    listRowLocations(location: location)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        viewM.deleteLocation(location)
                    } label: {
                        Label("Eliminar", systemImage: "trash")
                    }
                }
            }
            .listRowBackground(Color.blue)
        }
        .scrollContentBackground(.hidden)
        .background(
            Color.clear
                .ignoresSafeArea(.all)
        )
    }
}

// MARK: - Row Components
extension LocationListView {
    
    /**
     Vista de fila individual para cada ubicación
     
     - Parameters:
        - location: La ubicación a mostrar
     
     - Returns: Vista con imagen, nombre y badges de estado
     */
    func listRowLocations(location: Location) -> some View {
        HStack {
            // Imagen de la ubicación
            if let imageName = location.imageNamesArray.first {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            // Información de la ubicación
            VStack(alignment: .leading, spacing: 4) {
                Text(location.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(location.cityName)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Indicadores de estado
            HStack(spacing: 8) {
                if location.visitado {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .help("Visitado")
                }
                
                if location.recomendar {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .help("Recomendado")
                }
                
                if location.visitadoEnMes {
                    Image(systemName: "calendar.badge.clock")
                        .foregroundStyle(.orange)
                        .help("Visitado este mes")
                }
            }
        }
    }
}

#Preview {
    LocationListView()
        .environmentObject(LocationViewModel())
}
