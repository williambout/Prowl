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

            TextField(text: $apiKey, prompt: Text("")) {
                Text("API Key").fontDesign(.default)
            }.fontDesign(.monospaced)
#if os(iOS)
                .font(.system(size: 15))
#endif
#if os(macOS)
.textFieldStyle(.roundedBorder)
#endif
        }
    }
}

#Preview {
    GeneralSettingsView()
}
