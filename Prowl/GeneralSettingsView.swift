//
//  GeneralSettingsView.swift
//  Prowl
//
//  Created by William on 1/13/24.
//

import SwiftUI

struct GeneralSettingsView: View {
    @AppStorage("apiKey") private var apiKey: String = ""
    @AppStorage("host") private var host: String = ""
    @AppStorage("port") private var port: String = ""

    var body: some View {
        Form {
            TextField(
                "Host",
                text: $host
            )
            TextField(
                "Port",
                text: $port
            )
            TextField(
                "API Key",
                text: $apiKey
            )
        }
        .padding(20)
        .frame(width: 350, height: 100)
    }
}

#Preview {
    GeneralSettingsView()
}
