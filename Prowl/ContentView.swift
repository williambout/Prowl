//
//  ContentView.swift
//  Prowl
//
//  Created by William on 1/13/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("host") private var host: String = ""
    @AppStorage("port") private var port: String = ""
    @State private var isLoading: Bool = false
    @State private var results = [Torrent]()
    @State private var query: String = ""
    let formatter = DateComponentsFormatter()

    init() {
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = [.dropLeading, .dropTrailing]
        formatter.maximumUnitCount = 1
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(results, id: \.guid) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(.headline)
                        HStack(spacing: 4) {
                            if item.downloaded ?? false {
                                Image(systemName: "arrow.down.circle.fill").font(.caption2).foregroundStyle(.green)
                            }
                            Text(formatter.string(from: item.ageMinutes * 60)!).font(.subheadline).foregroundStyle(.secondary)
                            HStack(spacing: 2) {
                                Image(systemName: "arrow.up").font(.caption2).foregroundStyle(.secondary)
                                Text(String(item.seeders)).font(.subheadline).foregroundStyle(.secondary)
                                Image(systemName: "arrow.down").font(.caption2).foregroundStyle(.secondary)
                                Text(String(item.leechers)).font(.subheadline).foregroundStyle(.secondary)
                            }
                            Text(ByteCountFormatter.string(fromByteCount: item.size, countStyle: .file)).font(.subheadline).foregroundStyle(.secondary)
                        }
                    }.padding(4)
                        .swipeActions(edge: .trailing) {
                            Button { Task { await download(item: item) }} label: {
                                Label("Download", systemImage: "arrow.down.circle.fill")
                            }
                        }
                }
            }
        }
        .searchable(text: $query)
        .onSubmit(of: .search) {
            Task {
                await search()
            }
        }
    }

    func search() async {
        isLoading = true
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/api/v1/search"
        components.port = Int(port)

        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]

        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpMethod = "GET"

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            isLoading = false
            if let decodedResponse = try? JSONDecoder().decode([Torrent].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Checkout failed: \(error.localizedDescription)")
            isLoading = false
        }
    }

    func download(item: Torrent) async {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/api/v1/search"
        components.port = Int(port)

        var request = URLRequest(url: components.url!)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.httpMethod = "POST"

        let body = ["guid": item.guid, "indexerId": String(item.indexerId)]
        let serializedBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = serializedBody

        URLSession.shared.dataTask(with: request) { _, _, _ in
            // TODO: Show success indicator
//            if let httpResponse = response as? HTTPURLResponse {
//                if httpResponse.statusCode == 200 {
//                }
//            }
        }.resume()
    }
}

struct Torrent: Codable {
    var guid: String
    var title: String
    var size: Int64
    var seeders: Int
    var leechers: Int
    var indexerId: Int
    var ageMinutes: Double
    var downloaded: Bool?
}
