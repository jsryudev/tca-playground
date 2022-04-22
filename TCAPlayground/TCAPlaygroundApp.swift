//
//  TCAPlaygroundApp.swift
//  TCAPlayground
//
//  Created by Junsang Ryu on 2022/04/23.
//

import SwiftUI

import ComposableArchitecture

@main
struct TCAPlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: AppState(),
          reducer: appReducer,
          environment: AppEnvironment()
        )
      )
    }
  }
}
