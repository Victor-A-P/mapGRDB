import SwiftUI

struct PinLocationMapView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Círculo principal del pin
            Image(systemName: "map.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .font(.headline)
                .foregroundStyle(.white)
                .padding(6)
                .background(Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
                .clipShape(Circle())
            
            // Punta del pin (triángulo invertido)
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)))
                .rotationEffect(Angle(degrees: 180))
                .offset(y: -5)
                .padding(.bottom, 40)
        }
        .background(Color.clear)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.3)
            .ignoresSafeArea()
        
        PinLocationMapView()
    }
}
