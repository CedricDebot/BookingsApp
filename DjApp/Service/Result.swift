//
//  Result.swift
//  DjApp
//
//  Created by Cedric  Debot on 9/12/16.
//  Copyright © 2016 Cedric Debot. All rights reserved.
//

enum Result<T> {
    case succes(T)
    case failure(Service.Error)
}
