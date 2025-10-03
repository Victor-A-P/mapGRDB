 import SwiftUI

struct LocationPreviewView: View {
    @EnvironmentObject private var viewM: LocationViewModel
    
    let location: Location
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 16) {
                locationImage
                nameLocation
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                moreInfoButton
                nextButton
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .cornerRadius(10)
    }
}

// MARK: - View Components
extension LocationPreviewView {
    
    /// Nombre y ciudad con indicadores de estado
    var nameLocation: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(location.cityName)
                .font(.title3)
            
            // Indicadores de estado visibles
            HStack(spacing: 12) {
                if location.visitado {
                    Label("Visitado", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                if location.recomendar {
                    Label("Recomendado", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.yellow)
                }
                
                if location.visitadoEnMes {
                    Label("Este mes", systemImage: "calendar")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Imagen de la ubicación
    var locationImage: some View {
        ZStack {
            if let imageName = location.imageNamesArray.first {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(6)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    /// Botón para ver más información
    var moreInfoButton: some View {
        Button {
            viewM.isShowingDetailsSheet = location
        } label: {
            Text("Saber más")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 125, height: 50)
                .padding(.horizontal)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    /// Botón para avanzar a la siguiente ubicación
    var nextButton: some View {
        Button {
            viewM.nextButtonPressed()
        } label: {
            Text("Siguiente")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 125, height: 50)
                .padding(.horizontal)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.9)
            .ignoresSafeArea()
        
        LocationPreviewView(location: Location(
            name: "Colosseum",
            cityName: "Rome",
            latitude: 41.8902,
            longitude: 12.4922,
            description: "Ancient amphitheatre",
            imageNames: ["rome-colosseum-1"],
            link: "https://example.com"
        ))
        .padding()
    }
    .environmentObject(LocationViewModel())
}
