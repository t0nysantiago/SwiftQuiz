//
//  ImageView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 08/01/24.
//

import SwiftUI

struct ImageView: View {
    @State private var downloadedImage: UIImage? = nil
    @Binding var radius: Double
    @Binding var imageURLString: String?

    func loadImageFromURL() {
        guard let imageURLString = imageURLString, let url = URL(string: imageURLString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                downloadedImage = UIImage(data: data)
            }
        }.resume()
    }

    var body: some View {
        ZStack {
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: CGFloat(radius), height: CGFloat(radius))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding(.horizontal, 5)
            } else {
                Image("userlogo")
                    .resizable()
                    .frame(width: CGFloat(radius), height: CGFloat(radius))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .padding(.horizontal, 5)
                    .onAppear(perform: loadImageFromURL)
            }
        }
    }
}


#Preview {
    ImageView(radius: .constant(80), imageURLString: .constant("https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/f8af92c0-0180-4c58-a1ef-77f25bc5db57/df6e2fp-6b9b6106-2128-4598-b750-5c3e161252e6.png/v1/fit/w_768,h_768,q_70,strp/avatar_for_steam_by_j4sttrinitrotoluene_df6e2fp-414w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9NzY4IiwicGF0aCI6IlwvZlwvZjhhZjkyYzAtMDE4MC00YzU4LWExZWYtNzdmMjViYzVkYjU3XC9kZjZlMmZwLTZiOWI2MTA2LTIxMjgtNDU5OC1iNzUwLTVjM2UxNjEyNTJlNi5wbmciLCJ3aWR0aCI6Ijw9NzY4In1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.EiP8s0TB8tnN9gqN10rcZW1joOOZB6kj-sLCnqMaxUc"))
}
