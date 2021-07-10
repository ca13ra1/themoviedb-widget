//
//  themoviedb_widget.swift
//  themoviedb widget
//
//  Created by cole cabral on 2021-05-16.
//

import WidgetKit
import SwiftUI
import Intents
import Combine

private var cancellables = Set<AnyCancellable>()

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), trending: TMDb(results: Array(repeating: Result(backdropPath: "/auFsy7xWxLHGC3WrVyPEeKNVVUJ.jpg", genreIDS: [35,80], originalTitle: "Cruella", posterPath: "/hjS9mH8KvRiGHgjk6VUZH7OT0Ng.jpg", voteAverage: 8.8, overview: "In 1970s London amidst the punk rock revolution, a young grifter named Estella is determined to make a name for herself with her designs...", releaseDate: "2021-05-26", title: "Cruella", name: "Lucifer", originalName: "Lucifer", firstAirDate: "2016-01-25"), count: 1)), genres: Genres(genres: Array(repeating: Genre(id: 35, name: "Comedy"), count: 1)))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var request = URLRequest(url: URL(string:"https://api.themoviedb.org/3/trending/\(configuration.media.stringValue)/\(configuration.time.stringValue)?api_key=API_KEY")!)
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: TMDb.self, decoder: JSONDecoder())
        let publisher2 = publisher
            .flatMap {_ in
                return self.genres(configuration.media.stringValue == "movies" ? String(configuration.media.stringValue.dropLast()) : configuration.media.stringValue)
            }
        Publishers.Zip(publisher, publisher2)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { results, genres in
                let entry = SimpleEntry(date: Date(), configuration: configuration, trending: results, genres: genres)
                completion(entry)
            }).store(in: &cancellables)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        var request = URLRequest(url: URL(string:"https://api.themoviedb.org/3/trending/\(configuration.media.stringValue)/\(configuration.time.stringValue)?api_key=API_KEY")!)
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let publisher = URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: TMDb.self, decoder: JSONDecoder())
        let publisher2 = publisher
            .flatMap {_ in
                return self.genres(configuration.media.stringValue == "movies" ? String(configuration.media.stringValue.dropLast()) : configuration.media.stringValue)
            }
        Publishers.Zip(publisher, publisher2)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("\(error)")
                }
            }, receiveValue: { results, genres in
                let entry = SimpleEntry(date: entryDate, configuration: configuration, trending: results, genres: genres)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }).store(in: &cancellables)
    }
    
    func genres(_ media: String) -> AnyPublisher<Genres, Error >{
        var request = URLRequest(url: URL(string:"https://api.themoviedb.org/3/genre/\(media)/list?api_key=API_KEY")!)
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/42.0", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ $0.data }
            .decode(type: Genres.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let trending: TMDb
    let genres: Genres
}

struct themoviedb_widgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallView(trending: entry.trending, genres: entry.genres ,configuration: entry.configuration)
        case .systemMedium:
            MediumView(trending: entry.trending, genres: entry.genres ,configuration: entry.configuration)
        case .systemLarge:
            LargeView(trending: entry.trending, genres: entry.genres ,configuration: entry.configuration)
        @unknown default:
            EmptyView()
        }
    }
}

@main
struct themoviedb_widget: Widget {
    let kind: String = "themoviedb_widget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            themoviedb_widgetEntryView(entry: entry)
        }
        .configurationDisplayName("themoviedb")
        .description("Daily or weekly trending items from The Movie Database (TMDb).")
    }
}

struct themoviedb_widget_Previews: PreviewProvider {
    static var previews: some View {
        themoviedb_widgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), trending: TMDb(results: Array(repeating: Result(backdropPath: "/auFsy7xWxLHGC3WrVyPEeKNVVUJ.jpg", genreIDS: [35,80], originalTitle: "Cruella", posterPath: "/hjS9mH8KvRiGHgjk6VUZH7OT0Ng.jpg", voteAverage: 8.8, overview: "In 1970s London amidst the punk rock revolution, a young grifter named Estella is determined to make a name for herself with her designs...", releaseDate: "2021-05-26", title: "Cruella", name: "Lucifer", originalName: "Lucifer", firstAirDate: "2016-01-25"), count: 1)), genres: Genres(genres: Array(repeating: Genre(id: 35, name: "Comedy"), count: 1))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .redacted(reason: .placeholder)
    }
}

