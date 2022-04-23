//
//  ContentView.swift
//  TCAPlayground
//
//  Created by Junsang Ryu on 2022/04/23.
//

import SwiftUI

import ComposableArchitecture

struct Todo: Equatable, Identifiable {
  let id: UUID
  var description = ""
  var isComplete = false
}

struct AppState: Equatable {
  var todos: [Todo] = []
}

enum AppAction {
  case todoCheckboxTapped(index: Int)
  case todoTextFieldChanged(index: Int, text: String)
}

struct AppEnvironment {
  
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case let .todoCheckboxTapped(index):
    state.todos[index].isComplete.toggle()
    return .none
    
  case let .todoTextFieldChanged(index, text):
    state.todos[index].description = text
    return .none
  }
}

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        List {
          ForEach(Array(viewStore.todos.enumerated()), id: \.element.id) { index, todo in
            HStack {
              Button(action: { viewStore.send(.todoCheckboxTapped(index: index)) }) {
                Image(systemName: todo.isComplete ? "checkmark.square" : "square")
              }
              .buttonStyle(.plain)
              
              TextField(
                "Untitled Todo",
                text: viewStore.binding(
                  get: { $0.todos[index].description },
                  send: { .todoTextFieldChanged(index: index, text: $0) }
                )
              )
            }
            .foregroundColor(todo.isComplete ? .gray : nil)
            
          }
        }
        .navigationBarTitle("Todos")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: AppState(
          todos: [
            Todo(
              id: UUID(),
              description: "Milk",
              isComplete: false
            ),
            Todo(
              id: UUID(),
              description: "Eggs",
              isComplete: false
            ),
            Todo(
              id: UUID(),
              description: "Hand Soap",
              isComplete: true
            ),
          ]
        ),
        reducer: appReducer,
        environment: AppEnvironment()
      )
    )
  }
}
