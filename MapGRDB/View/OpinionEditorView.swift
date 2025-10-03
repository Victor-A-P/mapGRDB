
import SwiftUI

struct OpinionEditorView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var opinion: String
    
    let onSave: () -> Void
    
    @State private var tempOpinion: String
    
    init(opinion: Binding<String>, onSave: @escaping () -> Void) {
        self._opinion = opinion
        self.onSave = onSave
        self._tempOpinion = State(initialValue: opinion.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Instrucciones
                Text("Escribe tu opinión sobre este lugar:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Editor de texto
                TextEditor(text: $tempOpinion)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .frame(minHeight: 200)
                
                // Contador de caracteres
                HStack {
                    Spacer()
                    Text("\(tempOpinion.count) caracteres")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Editar Opinión")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        opinion = tempOpinion
                        onSave()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(tempOpinion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !opinion.isEmpty)
                }
            }
        }
    }
}



#Preview {
    OpinionEditorView(opinion: .constant("Mi opinión sobre este lugar es que es increíble")) {
        print("Opinión guardada")
    }
}
