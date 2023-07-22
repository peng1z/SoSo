//
//  ContentView.swift
//  SoSo
//
//  Created by Peng Zhang on 7/21/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModel()
    @State private var mbti: String = "ISTJ"
    @State private var starSign: String = "Aries"
    @State private var generatedImage: Image? = nil
    @State var image: UIImage?
    @State var text = "SoSo gives you an unique avatar."
    @State var animal = "Great Horned Owl"

    var body: some View {
        NavigationView{
            VStack {
                // Display the generated image above the selection area
                Spacer()
                if let image = image{
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                }
                else{
                    Text(text)
                }
                Spacer()
                Text("Select your MBTI:")
                Picker("MBTI", selection: $mbti) {
                    ForEach(mbtiOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .padding()
                
                Text("Select your star sign:")
                Picker("Star Sign", selection: $starSign) {
                    ForEach(starSignOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                .padding()
                
                Button(action: {
                    Task{
                        var pickAnimal = [
                            "ENFP" : "Dolphin",
                            "ENTP" : "Chimpanzee",
                            "INFP" : "Asian Elephant",
                            "INTP" : "Green Anole Lizard",
                            "ENFJ" : "Arabian Horse",
                            "ENTJ" : "Cheetah",
                            "INFJ" : "Humpback Whale",
                            "INTJ" : "Octopus",
                            "ESFP" : "Blue and Gold Macaw",
                            "ESTP" : "Fox",
                            "ISFP" : "Leopard",
                            "ISTP" : "Crow",
                            "ESFJ" : "Vampire Bat",
                            "ESTJ" : "Wolf",
                            "ISFJ" : "Penguin",
                            "ISTJ" : "Great Horned Owl"
                        ]
                        animal = pickAnimal[mbti] ?? "Great Horned Owl"
                        self.image = nil
                        text = "Generating..."
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil, from: nil, for: nil)
                        let result = await
                        model.generateImage(prompt: "a 3D render of a balloon \(animal) with the lucky color of the \(starSign)")
                        if(result == nil){
                            print("Fail to generate.")
                        }
                        self.image = result
                    }
                }, label: {
                    Text("Generate Image")
                })
            }
            .navigationTitle("Welcome to SoSo!")
            .onAppear{
                model.setup()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Sample data for MBTI and star sign options
let mbtiOptions = ["ISTJ", "ISFJ", "INFJ", "INTJ", "ISTP", "ISFP", "INFP", "INTP", "ESTP", "ESFP", "ENFP", "ENTP", "ESTJ", "ESFJ", "ENFJ", "ENTJ"]

let starSignOptions = ["Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo", "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"]

