//
//  JSTListsModel.swift
//  JSTasks
//
//  Created by Jeffrey Sulton on 3/7/20.
//  Copyright © 2020 Jeffrey Sulton. All rights reserved.
//

import Foundation

/// A view-model describing the complete set of lists and their tasks.
public final class JSTListsViewModel: Codable, ObservableObject {
    private let api = JSTTasksAPI()

    @Published
    public var lists: [JSTListModel] = []

    @Published
    public var selectedList: JSTListModel?

    enum CodingKeys: CodingKey {
        case lists
    }

    /// A  map of IDs to `String`s
    @Published
    var list: [Int: String] = [:]

    init() {}

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lists = try container.decode([JSTListModel].self, forKey: .lists)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lists, forKey: .lists)
    }

    /// Fetch the full set of tasks
    func fetch() {
        api.getAllTasks { (lists: [JSTListModel]?) in
            if let lists = lists {
                let listDict: [Int: String] = lists.reduce(into: [:]) { result, next in
                    result[next.id] = next.name
                }

                DispatchQueue.main.async {
                    self.lists = lists
                    self.list = listDict
                    print(self.lists)
                }
            }
        }
    }
}
