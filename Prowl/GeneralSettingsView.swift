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
#if os(macOS)
            .textFieldStyle(.roundedBorder)
#endif
            TextField(
                "Port",
                text: $port
            )
#if os(macOS)
            .textFieldStyle(.roundedBorder)
#endif
            TextField(
                "API Key",
                text: $apiKey
            ).fontDesign(.monospaced).font(.system(size: 15))
#if os(macOS)
                .textFieldStyle(.roundedBorder)
#endif
        }
    }
}

#Preview {
    GeneralSettingsView()
}
