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
  case todo(index: Int, action: TodoAction)
}

enum TodoAction {
  case checkboxTapped
  case textFieldChanged(text: String)
}

struct AppEnvironment {
  
}

struct TodoEnvironment {
  
}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, _ in
  switch action {
  case .checkboxTapped:
    state.isComplete.toggle()
    return .none
    
  case .textFieldChanged(let text):
    state.description = text
    return .none
  }
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> = todoReducer.forEach(
  state: \AppState.todos,
  action: /AppAction.todo(index:action:),
  environment: { _ in TodoEnvironment() }
)

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        List {
          ForEachStore(
            self.store.scope(state: \.todos, action: AppAction.todo(index:action:))
          ) { todoStore in
            WithViewStore(todoStore) { todoViewStore in
              HStack {
                Button(action: { todoViewStore.send(.checkboxTapped) }) {
                  Image(systemName: todoViewStore.isComplete ? "checkmark.square" : "square")
                }
                .buttonStyle(.plain)
                
                TextField(
                  "Untitled Todo",
                  text: todoViewStore.binding(
                    get: \.description,
                    send: TodoAction.textFieldChanged
                  )
                )
              }
              .foregroundColor(todoViewStore.isComplete ? .gray : nil)
            }
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
