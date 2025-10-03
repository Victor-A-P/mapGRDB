import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewM = LocationViewModel()
    
    let maxWidthIpad: CGFloat = 600
    
    @State private var showAddLocation = false
  
    var body: some View
    {
        ZStack {
            mapLayer
            
            VStack(spacing: 0)
            {
                headerLocation
                    .padding()
                    .frame(maxWidth: maxWidthIpad)
                                
                if viewM.showLocationList {
                    LocationListView()
                        .transition(.move(edge: .top))
                        .frame(maxWidth: maxWidthIpad)
                        .zIndex(20)
                }
                
                Spacer()
                
               
                
                
               
                
                if viewM.mapLocation != nil {
                    cardStackPreview
                        .frame(maxWidth: maxWidthIpad)
                }
            }
            
            // Botón flotante - AJUSTADO para estar siempre visible
            VStack
            {
                Spacer()
                HStack {
                    Spacer()
                    addLocationButton
                        .zIndex(10)
                    Spacer()
                }
                
            }
            .background(Color.clear)
          
        }
        .environmentObject(viewM)
        .sheet(item: $viewM.isShowingDetailsSheet) { location in
            LocationDetail(location: location)
                .presentationDetents([.height(700)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showAddLocation) {
            AddLocationView()
                .environmentObject(viewM)
        }
    }
}

// MARK: - View Components
extension ContentView {
    
    var mapLayer: some View {
        Map(
            coordinateRegion: $viewM.mapRegion,
            annotationItems: viewM.locations
        ) { location in
            MapAnnotation(coordinate: location.coordinates) {
                PinLocationMapView()
                    .scaleEffect(viewM.mapLocation?.uuid == location.uuid ? 1.25 : 0.8)
                    .shadow(radius: 10)
                    .onTapGesture {
                        viewM.showNextLocation(location)
                    }
            }
        }
        .ignoresSafeArea()
    }
    
    var headerLocation: some View {
        VStack {
            if let currentLocation = viewM.mapLocation {
                Button {
                    viewM.toggleLocationList()
                } label: {
                    Text("\(currentLocation.name), \(currentLocation.cityName)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .overlay(alignment: .leading) {
                            Image(systemName: "arrow.down")
                                .font(.title2)
                                .foregroundStyle(.white)
                                .padding()
                                .rotationEffect(Angle(degrees: viewM.showLocationList ? 180 : 0))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.45), radius: 20, x: 0, y: 15)
                }
            }
        }
    }
    
    var cardStackPreview: some View {
        ZStack {
            ForEach(viewM.locations, id: \.uuid) { location in
                if viewM.mapLocation?.uuid == location.uuid {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .padding(.bottom, 50) // Espacio para el botón
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .bottom)
                        ))
                }
            }
        }
    }
    
    var addLocationButton: some View {
        Button {
            showAddLocation = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                Text("Agregar")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
            )
        }
    }
}

#Preview {
    ContentView()
}
