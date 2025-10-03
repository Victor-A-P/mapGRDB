import SwiftUI
import MapKit

// Wrapper para hacer MKMapItem compatible con Map
struct IdentifiableMapItem: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
    
    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }
}

struct AddLocationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewM: LocationViewModel
    
    @StateObject private var searchViewModel = LocationSearchViewModel()
    
    @State private var searchText = ""
    @State private var selectedMapItem: MKMapItem?
    @State private var showForm = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Propiedad computada para el wrapper
    private var selectedItemWrapper: [IdentifiableMapItem] {
        if let item = selectedMapItem {
            return [IdentifiableMapItem(mapItem: item)]
        }
        return []
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: selectedItemWrapper) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                    }
                }
                .ignoresSafeArea()
                
                VStack {
                    searchBar
                    
                    if !searchViewModel.searchResults.isEmpty && !showForm {
                        searchResultsList
                    }
                    
                    Spacer()
                    
                    if selectedMapItem != nil && !showForm {
                        continueButton
                    }
                }
            }
            .navigationTitle("Agregar Ubicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showForm) {
                if let mapItem = selectedMapItem {
                    LocationFormView(
                        mapItem: mapItem,
                        onSave: { newLocation in
                            viewM.addLocation(newLocation)
                            dismiss()
                        }
                    )
                }
            }
        }
    }
}

// MARK: - View Components
extension AddLocationView {
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            
            TextField("Buscar lugares...", text: $searchText)
                .textFieldStyle(.plain)
                .onChange(of: searchText) { newValue in
                    searchViewModel.search(query: newValue)
                }
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    searchViewModel.searchResults = []
                    selectedMapItem = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding()
    }
    
    var searchResultsList: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(searchViewModel.searchResults, id: \.self) { item in
                    Button {
                        selectLocation(item)
                    } label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundStyle(.red)
                            
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Sin nombre")
                                    .font(.headline)
                                
                                if let address = item.placemark.title {
                                    Text(address)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemBackground))
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                }
            }
        }
        .frame(maxHeight: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    var continueButton: some View {
        Button {
            showForm = true
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Continuar con esta ubicación")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(15)
            .padding()
        }
    }
    
    func selectLocation(_ item: MKMapItem) {
        selectedMapItem = item
        searchViewModel.searchResults = []
        searchText = item.name ?? ""
        
        withAnimation {
            region = MKCoordinateRegion(
                center: item.placemark.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
    }
}

#Preview {
    AddLocationView()
        .environmentObject(LocationViewModel())
}
