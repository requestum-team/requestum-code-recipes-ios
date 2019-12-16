//
//  APIQuery.swift
//  
//
//  Created by Alex Kovalov on 9/18/19.
//  Copyright © 2019 Requestum. All rights reserved.
//

import Foundation

open class APIQuery: Encodable {
    
    public struct SearchQuery: Encodable {
        
        // Comma separated field names. Will be sent as `query[fields]=field1,field2`
        var fields: String?
        
        // String to search. Will be sent as `query[term]=term`
        var term: String?
    }
    
    // Sorting by fields (pattern 'field|direction', where 'field' is field to sort, and 'direction' is optional and can be 'asc' which is default value and 'desc').
    // Example value: name|desc
    var orderBy: String?
    
    // Page number. Default value: 1
    var page: Int?
    
    // Items on page count. Default value: 20
    var perPage: Int?
    
    // Search query, supports wildcards (*suffix, prefix*, *middle*). Example value: *van
    var query: String?
    
    // When `query` is not enough and needs custom search query
    // Mutually exclusive with `query`, so use `query` or `searchQuery`, not both
    var searchQuery: SearchQuery?
    
    // Comma separated fields list to expand (can be nested). Example value: relation1,relation2.sub_relation
    var expand: String?
    
    
    private enum CodingKeys: String, CodingKey {
        
        case orderBy = "order-by"
        case page
        case perPage = "per-page"
        case query
        case expand
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(orderBy, forKey: .orderBy)
        try container.encodeIfPresent(page, forKey: .page)
        try container.encodeIfPresent(perPage, forKey: .perPage)
        if let query = self.query {
            try container.encode(query, forKey: .query)
        } else if let searchQuery = self.searchQuery {
            try container.encode(searchQuery, forKey: .query)
        }
        try container.encodeIfPresent(expand, forKey: .expand)
    }
}
