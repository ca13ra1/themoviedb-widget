//
//  SmallView.swift
//  themoviedb widgetExtension
//
//  Created by cole cabral on 2021-05-17.
//

import Foundation
import SwiftUI

struct SmallView : View {
    let trending: TMDb
    let genres: Genres
    let configuration: ConfigurationIntent
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { geometry in
                if let url = URL(string:"https://image.tmdb.org/t/p/w500/\(trending.results.first?.posterPath ?? "")"),
                   let imageData = try? Data(contentsOf: url),
                   let image = UIImage(data:imageData) {
                    Image(uiImage:image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            VStack(alignment: .trailing) {
                Text("\(configuration.media.stringValue == "movies" ? trending.results.first?.originalTitle ?? "" : trending.results.first?.originalName ?? "")")
                    .font(.footnote)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .lineLimit(1)
                HStack {
                    Image(systemName: "star.fill")
                        .font(.subheadline)
                        .foregroundColor(Color.yellow)
                        .unredacted()
                    Text(String(format: "%.2f", trending.results.first?.voteAverage ?? 0))
                        .font(.subheadline)
                        .foregroundColor(Color.white)
                }
            }
            .padding(.all, 10)
        }
    }
}
