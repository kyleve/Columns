//
//  Column.swift
//  Columns
//
//  Created by Kyle Van Essen on 8/8/19.
//  Copyright © 2019 Kyle Van Essen. All rights reserved.
//

import UIKit


struct ColumnProperties
{
    var columns : Int
    var gutterWidth : CGFloat
    
    init(columns: Int, gutterWidth : CGFloat)
    {
        precondition(columns > 0)
        precondition(gutterWidth >= 0)
        
        self.columns = columns
        self.gutterWidth = gutterWidth
    }
}

struct ColumnLayout
{
    let all : [ColumnLayoutElement]
    let columns : [Column]
    let gutters : [Gutter]
    
    let properties : ColumnProperties
    
    init(totalWidth: CGFloat, properties : ColumnProperties)
    {
        self.properties = properties
        
        let gutterCount : Int = self.properties.columns - 1
        let totalGutterWidth = self.properties.gutterWidth * CGFloat(gutterCount)

        let totalColumnWidth = totalWidth - totalGutterWidth
        let columnWidth = totalColumnWidth / CGFloat(self.properties.columns)
        
        // TODO: This doesn't take into account the fact that we need to iterate over each column and use
        // bubble roundint to figure out the actual widths.. but good enough for now.
        
        var all = [ColumnLayoutElement]()
        var columns = [Column]()
        var gutters = [Gutter]()
        
        var offset : CGFloat = 0.0
        
        for index in 0 ..< self.properties.columns
        {
            let isLastColumn = (index == self.properties.columns - 1)
            
            let column = Column(
                width: columnWidth,
                offset: offset,
                index: index
            )
            
            all.append(column)
            columns.append(column)
            
            offset += column.width
            
            if isLastColumn == false {
                let gutter = Gutter(
                    width: self.properties.gutterWidth,
                    offset: offset,
                    index: index
                )
                
                offset += self.properties.gutterWidth
                
                all.append(gutter)
                gutters.append(gutter)
            }
        }
        
        self.all = all
        self.columns = columns
        self.gutters = gutters
    }
}

protocol ColumnLayoutElement
{
    var width : CGFloat { get }
    var offset : CGFloat { get }
    
    var index : Int { get }
}

struct Column : ColumnLayoutElement
{
    let width : CGFloat
    let offset : CGFloat
    
    let index : Int
}

struct Gutter : ColumnLayoutElement
{
    let width : CGFloat
    let offset : CGFloat
    
    let index : Int
}

final class ColumnLayoutPosition
{
    var origin : CGFloat
    var width : CGFloat
    
    let coordinateSpace : UICoordinateSpace
    
    init(origin: CGFloat = 0.0, width : CGFloat, coordinateSpace : UICoordinateSpace)
    {
        self.origin = origin
        self.width = width
        self.coordinateSpace = coordinateSpace
    }
}

protocol ColumnLayoutPositionProvider : UIView
{
    var columnLayoutPosition : ColumnLayoutPosition { get }
}

extension UIView
{
    var columnLayoutPosition : ColumnLayoutPosition {
        var view = self
        
        while true {
            if let view = view as? ColumnLayoutPositionProvider {
                return view.columnLayoutPosition
            } else {
                if let superview = view.superview {
                    view = superview
                } else {
                    break
                }
            }
        }
        
        return ColumnLayoutPosition(origin: 0.0, width: self.bounds.size.width, coordinateSpace: self)
    }
}

final class ColumnLayoutProvider<Layout:SpecificColumnLayout>
{
    unowned var coordinateSpace : UICoordinateSpace
    
    var layout : Layout {
        return Layout(totalWidth: <#T##CGFloat#>, gutterWidth: <#T##CGFloat#>)
    }
    
    init(coordinateSpace : UICoordinateSpace)
    {
        self.coordinateSpace = coordinateSpace
    }
}

protocol SpecificColumnLayout
{
    init(totalWidth: CGFloat, gutterWidth: CGFloat)
}

struct SingleColumnLayout : SpecificColumnLayout
{
    let layout : ColumnLayout

    let column1 : Column
    
    init(totalWidth: CGFloat, gutterWidth: CGFloat)
    {
        self.layout = ColumnLayout(totalWidth: totalWidth, properties: ColumnProperties(columns: 1, gutterWidth: 0.0))
        
        self.column1 = self.layout.columns[0]
    }
}

struct FourColumnLayout : FourColumnLayout
{
    let layout : ColumnLayout
    
    let column1 : Column
    let column2 : Column
    let column3 : Column
    let column4 : Column
    
    let gutter1 : Gutter
    let gutter2 : Gutter
    let gutter3 : Gutter
    
    init(totalWidth: CGFloat, gutterWidth: CGFloat)
    {
        self.layout = ColumnLayout(totalWidth: totalWidth, properties: ColumnProperties(columns: 4, gutterWidth: gutterWidth))
        
        self.column1 = self.layout.columns[0]
        self.column2 = self.layout.columns[1]
        self.column3 = self.layout.columns[2]
        self.column4 = self.layout.columns[3]
        
        self.gutter1 = self.layout.gutters[0]
        self.gutter2 = self.layout.gutters[1]
        self.gutter3 = self.layout.gutters[2]
    }
}
