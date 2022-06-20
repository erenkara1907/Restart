//
//  OnboardingView.swift
//  Restart
//
//  Created by user on 17.05.2022.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive : Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0.0
    @State private var isAnimating: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var indicatorOpacity: Double = 1.0
    @State private var textTitle: String = "Share."
    
    let hapticFeedBack = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            VStack(spacing: 20.0){
                // Header
                Spacer()
                VStack(spacing: 0.0){
                    Text(textTitle)
                        .font(.system(size: 60.0))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(textTitle)
                    
                    Text("""
    It's not how much we give but
how much love we put into giving.æ
""").font(.title3).fontWeight(.light).foregroundColor(.white).multilineTextAlignment(.center).padding(.horizontal, 10.0)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : -40.0)
                .animation(.easeOut(duration: 1.0), value: isAnimating)
                
                // Center
                ZStack{
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1.0), value: imageOffset)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimating)
                        .offset(x: imageOffset.width * 1.2, y: 0.0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(DragGesture()
                                    .onChanged{gesture in
                            if abs(imageOffset.width) <= 150.0 {
                                imageOffset = gesture.translation
                                
                                withAnimation(.linear(duration: 0.25)) {
                                    indicatorOpacity = 0.0
                                    textTitle = "Give."
                                }
                            }
                                
                        }.onEnded{_ in
                            imageOffset = .zero
                            
                            withAnimation(.linear(duration: 0.25)) {
                                indicatorOpacity = 1.0
                                textTitle = "Share."
                            }
                        }).animation(.easeOut(duration: 1.0),value: imageOffset)
                }.overlay(
                Image(systemName: "arrow.left.and.right.circle")
                    .font(.system(size: 44.0, weight: .ultraLight))
                    .foregroundColor(.white)
                    .offset(y: 20.0)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeOut(duration: 1.0).delay(2.0), value: isAnimating)
                    .opacity(indicatorOpacity)
                , alignment: .bottom
                )
                
                
                Spacer()
                
                // Footer
                ZStack{
                    // 1. Background Static
                    Capsule()
                        .fill(.white.opacity(0.2))
                    
                    Capsule()
                        .fill(.white.opacity(0.2))
                        .padding(8.0)
                    
                    // 2. Call-To-Action Static
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20.0)
                    
                    // 3. Capsule Dynamic Width
                    HStack{
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }
                    
                    // 4. Circle Draggable
                    HStack{
                        ZStack{
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8.0)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24.0, weight: .bold))
                        }.foregroundColor(.white)
                            .frame(width: 80.0, height: 80.0, alignment: .center)
                            .offset(x: buttonOffset )
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        if gesture.translation.width > 0.0 && buttonOffset <= buttonWidth - 80 {
                                            buttonOffset = gesture.translation.width
                                        }
                                    }
                                    .onEnded { _ in
                                        withAnimation(Animation.easeOut(duration: 0.4)){
                                            if buttonOffset > buttonWidth  / 2 {
                                                hapticFeedBack.notificationOccurred(.success)
                                                playSound(sound: "chimeup", type: "mp3")
                                                buttonOffset = buttonWidth -  80
                                                isOnboardingViewActive = false
                                            }else {
                                                hapticFeedBack.notificationOccurred(.warning)
                                                buttonOffset = 0
                                            }
                                        }
                                    }
                            )
                        
                        Spacer()
                    }
                }
                .frame(width: buttonWidth, height: 80.0, alignment: .center)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 40.0)
                .animation(.easeOut(duration: 1.0), value: isAnimating)
            }
        }
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
