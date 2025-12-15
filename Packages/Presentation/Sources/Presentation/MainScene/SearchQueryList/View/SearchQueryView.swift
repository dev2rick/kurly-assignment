//
//  SearchQueryView.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import SwiftUI

public struct SearchQueryView: View {
    
    @State private(set) var searchQuery: String = ""
    @StateObject private var viewModel: SearchQueryListViewModel
    
    public init(viewModel: SearchQueryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List(viewModel.searchQueries, id: \.query) { item in
            Text(item.query)
        }
        .searchable(text: $searchQuery)
        .onSubmit(of: .search) {
            Task { await viewModel.onSearch(query: searchQuery) }
        }
        .refreshable {
            await viewModel.onAppear()
        }
        .task {
            await viewModel.onAppear()
        }
    }
}

#Preview {
    NavigationView {
        SearchQueryView(
            viewModel: SearchQueryListViewModel(
                fetchSearchQueryUseCase: StubFetchSearchQueryUseCase(),
                saveSearchQueryUseCase: StubSaveSearchQueryUseCase()
            )
        )
    }
}
