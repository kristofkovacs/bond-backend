//
//  StorableCreatedResponse.swift
//  App
//
//  Created by Gujgiczer Máté on 2018. 04. 23..
//

import FluentProvider
import HTTP

extension Storable {
    
    var createdResponse: Response {
        return Response(status: .created,
                        headers: ["Content-Type": "application/json"],
                        body: (try? JSON(node: ["id": id])) ?? JSON())
    }
}
