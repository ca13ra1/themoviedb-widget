//
//  MediumView.swift
//  themoviedb widgetExtension
//
//  Created by cole cabral on 2021-05-17.
//

import Foundation
import SwiftUI

struct MediumView : View {
    let trending: TMDb
    let genres: Genres
    let configuration: ConfigurationIntent
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            GeometryReader { geometry in
                if let url = URL(string:"https://image.tmdb.org/t/p/w500/\(trending.results.first?.backdropPath ?? "")"),
                   let imageData = try? Data(contentsOf: url),
                   let image = UIImage(data:imageData) {
                    Image(uiImage:image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            VStack(alignment: .trailing) {
                Text("\(configuration.media.stringValue == "movies" ? trending.results.first?.originalTitle ?? "" : trending.results.first?.originalName ?? "") (\(timeFormat(configuration.media.stringValue == "movies" ? trending.results.first?.releaseDate ?? "" : trending.results.first?.firstAirDate ?? "")))")
                    .font(.footnote)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .lineLimit(1)
                ForEach(genres.genres, id: \.id) { genres in
                    if trending.results.first?.genreIDS.first ?? 0 == genres.id {
                        Text(genres.name)
                            .font(.footnote)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                }
                HStack {
                    let stars = HStack(spacing: 0) {
                        ForEach(0..<(Int(String(format: "%.2f", trending.results.first?.voteAverage ?? 0).dropFirst(2).dropLast()) ?? 0 > 0 ? Int(trending.results.first?.voteAverage ?? 0) + 1 : Int(trending.results.first?.voteAverage ?? 0))) { _ in
                            Image(systemName: "star.fill")
                                .font(.footnote)
                                .unredacted()
                        }
                    }
                    stars.overlay(
                        GeometryReader { g in
                            let width = CGFloat(trending.results.first?.voteAverage ?? 0) / CGFloat(Int(String(format: "%.2f", trending.results.first?.voteAverage ?? 0).dropFirst(2).dropLast()) ?? 0 > 0 ? Int(trending.results.first?.voteAverage ?? 0) + 1 : Int(trending.results.first?.voteAverage ?? 0)) * g.size.width
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(width: width)
                                    .foregroundColor(Color.yellow)
                            }
                        }
                        .mask(stars)
                    )
                    .foregroundColor(Color.gray)
                }
            }
            .padding(.all, 15)
        }
    }
}
