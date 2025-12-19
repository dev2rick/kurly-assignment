//
//  SearchQueryView.swift
//  Presentation
//
//  Created by rick on 12/15/25.
//

import SwiftUI

public struct SearchQueryListView: View {
    
//    @State private(set) var searchQuery: String = ""
    @StateObject private var viewModel: SearchQueryListViewModel
    
    public init(viewModel: SearchQueryListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List {
            
            switch viewModel.searchState {
            case .idle:
                Section {
                    ForEach(viewModel.cachedQueries, id: \.query) { item in
                        Button {
                            Task { await viewModel.onTapItem(item.query) }
                        } label: {
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
                        }
                        .foregroundColor(.secondary)
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("최근 검색")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(16)
                } footer: {
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
                .listRowInsets(.init())
                .listRowSpacing(0)
                .listRowSeparator(.hidden)
            case .preSearching:
                Section {
                    ForEach(viewModel.cachedQueries, id: \.query) { item in
                        Button {
                            Task { await viewModel.onTapItem(item.query) }
                        } label: {
                            HStack {
                                Text(item.query)
                                Spacer()
                                Text(item.displayDate)
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.secondary)
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .buttonStyle(.plain)
                    }
                }
                .listRowInsets(.init())
                .listRowSpacing(0)
                .listRowSeparator(.hidden)
            case .postSearch:
                Section {
                    ForEach(viewModel.githubRepos, id: \.self) { item in
                        Button {
                            viewModel.onTapRepo(item)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: item.thumbnailUrl)) { result in
                                    result.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: 48, height: 48)
                                    
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    Text(item.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 0)
        .listStyle(.plain)
        .searchable(text: $viewModel.query, prompt: "저장소 검색")
        .onSubmit(of: .search) { Task { await viewModel.onSubmit() } }
        .task {
            await viewModel.onAppear()
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
                fetchGitHubRepoUseCase: StubFetchGitHubUseCase(),
                actions: nil
            )
        )
    }
}
