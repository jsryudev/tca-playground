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

enum AppAction: Equatable {
  case addButtonTapped
  case todo(index: Int, action: TodoAction)
}

enum TodoAction: Equatable {
  case checkboxTapped
  case textFieldChanged(text: String)
}

struct AppEnvironment {
  var uuid: () -> UUID
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

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  todoReducer.forEach(
    state: \.todos,
    action: /AppAction.todo(index:action:),
    environment: { _ in TodoEnvironment() }
  ),
  Reducer { state, action, environment in
    switch action {
    case .addButtonTapped:
      state.todos.insert(Todo(id: environment.uuid()), at: .zero)
      return .none
      
    case .todo(index: _, action: _):
      return .none
    }
  }
)

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        List {
          ForEachStore(
            self.store.scope(state: \.todos, action: AppAction.todo(index:action:)),
            content: TodoView.init(store:)
          )
        }
        .navigationBarTitle("Todos")
        .navigationBarItems(trailing: Button("Add") {
          viewStore.send(.addButtonTapped)
        })
      }
    }
  }
}

struct TodoView: View {
  let store: Store<Todo, TodoAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Button(action: { viewStore.send(.checkboxTapped) }) {
          Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
        }
        .buttonStyle(.plain)
        
        TextField(
          "Untitled Todo",
          text: viewStore.binding(
            get: { $0.description },
            send: { .textFieldChanged(text: $0) }
          )
        )
      }
      .foregroundColor(viewStore.isComplete ? .gray : nil)
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
        environment: AppEnvironment(
          uuid: { UUID(uuidString: "DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF")! }
        )
      )
    )
  }
}
