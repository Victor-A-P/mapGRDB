
import Foundation
import MapKit
import Combine

class LocationSearchViewModel: NSObject, ObservableObject
{
    
    @Published var searchResults: [MKMapItem] = []
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentSearchTask: Task<Void, Never>?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.pointOfInterest, .address]
    }
    
    /**
     Realiza una búsqueda de ubicaciones
     
     - Parameters:
        - query: Texto de búsqueda
     */
    func search(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        // Cancela la búsqueda anterior si existe
        currentSearchTask?.cancel()
        
        currentSearchTask = Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = query
                
                let search = MKLocalSearch(request: request)
                let response = try await search.start()
                
                await MainActor.run {
                    self.searchResults = response.mapItems
                }
            } catch {
                if !Task.isCancelled {
                    print("❌ Error en búsqueda: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate
extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Opcional: Podrías usar los resultados del completer para autocompletado
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("❌ Error en completer: \(error.localizedDescription)")
    }
}
