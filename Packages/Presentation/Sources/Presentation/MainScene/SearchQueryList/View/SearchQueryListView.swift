//
//  SearchQueryView.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import SwiftUI

public struct SearchQueryListView: View {
    
    @State private(set) var searchQuery: String = ""
    @StateObject private var viewModel: SearchQueryListViewModel
    
    public init(viewModel: SearchQueryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(viewModel.searchQueries, id: \.query) { item in
                    if searchQuery.isEmpty {
                        HStack(spacing: 24) {
                            Text(item.query)
                            
                            Button {
                                Task { await viewModel.remove(item.query) }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.black, .tertiary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        
                    } else {
                        HStack {
                            Text(item.query)
                                
                            Spacer()
                            Text(item.updatedAt.formatted())
                        }
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .foregroundColor(.secondary)
                
            } header: {
                if searchQuery.isEmpty {
                    Text("최근 검색")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                }
            } footer: {
                if searchQuery.isEmpty {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                Task { await viewModel.removeAll() }
                            } label: {
                                Text("전체삭제")
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, 16)
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .listRowInsets(.init())
            .listRowSpacing(0)
            .listRowSeparator(.hidden)
        }
        .environment(\.defaultMinListRowHeight, 0)
        .animation(.easeInOut, value: searchQuery)
        .listStyle(.plain)
        .searchable(text: $searchQuery)
        .onSubmit(of: .search) {
            Task { await viewModel.onSearch(searchQuery) }
        }
        .refreshable {
            await viewModel.onRefresh(searchQuery)
        }
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: searchQuery) { _, newValue in
            Task { await viewModel.onSearchQueryChange(newValue) }
        }   
    }
}

#Preview {
    NavigationView {
        SearchQueryListView(
            viewModel: SearchQueryListViewModel(
                fetchSearchQueryUseCase: StubFetchSearchQueryUseCase(),
                saveSearchQueryUseCase: StubSaveSearchQueryUseCase(),
                removeSearchQueryUseCase: StubRemoveSearchQueryUseCase(),
                removeAllSearchQueryUseCase: StubRemoveAllSearchQueryUseCase(),
                actions: nil
            )
        )
    }
}
