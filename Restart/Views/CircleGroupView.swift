//
//  CircleGroupView.swift
//  Restart
//
//  Created by user on 17.05.2022.
//

import SwiftUI

struct CircleGroupView: View {
    
    // Property
    @State var ShapeColor: Color
    @State var ShapeOpacity: Double
    @State private var isAnimating: Bool = false
    
    // Body
    var body: some View {
        ZStack{
            Circle()
                .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: 40.0)
                .frame(width: 260.0, height: 260.0, alignment: .center)
            Circle()
                .stroke(ShapeColor.opacity(ShapeOpacity), lineWidth: 80.0)
                .frame(width: 260.0, height: 260.0, alignment: .center)
        }.blur(radius: isAnimating ? 0 : 10.0)
            .opacity(isAnimating ? 1 : 0)
            .scaleEffect(isAnimating ? 1 : 0.5)
            .animation(.easeOut(duration: 1), value: isAnimating)
            .onAppear(perform: {
                isAnimating = true
            })
    }
        
}

struct CircleGroupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
        }
    }
}
