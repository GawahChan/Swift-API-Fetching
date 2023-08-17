//
//  ContentView.swift
//  Swift-API-Fetching
//
//  Created by Gawah Chan on 15/08/2023.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        NavigationStack {
            List(results, id: \.trackId) { track in
                VStack {
                    Text(track.trackName)
                }
            }
            .navigationTitle("Taylor Swift Songs")
            .task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        print("fetching data...")
        
        // create url
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        // fetch data from url
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("API not working")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
